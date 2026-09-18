#!/bin/bash
# ============================================================
# Deb 单包模式打包 —— TOS 7
# 产物：<appid>_<platform>.deb（文件名不含版本号，见指引 5.9）
# ============================================================
set -e
APPID="$(python3 -c "import json;print(json.load(open('config.ini'))['id'])")"
VERSION="$(python3 -c "import json;print(json.load(open('config.ini'))['version'])")"
PLATFORM="${1:-x86_64}"
[ "$PLATFORM" = "aarch64" ] && DPKG_ARCH=arm64 || DPKG_ARCH=amd64

STAGING="build/${PLATFORM}/staging"
OUT="build/output"

echo "=== Building ${APPID} v${VERSION} for ${PLATFORM} ==="

# ---- 前置校验 ----
python3 - <<'PY'
import json, sys
c = json.load(open('config.ini'))
errs = []
if 'type' in c and 'open_path' in c:
    errs.append("type 与 open_path 互斥")
if c.get('application_type') != 'deb':
    errs.append("application_type 必须为 deb")
if 'path' in c and '${ip}' not in c['path'] and c['path'].startswith('http'):
    errs.append("外开 path 必须使用 ${ip} 占位，不得硬编码 IP")
if errs:
    print("ERROR: " + "; ".join(errs)); sys.exit(1)
PY

# 前端产物：由 webui/ 生成 webui.bz2（固定文件名，bzip2 的 tar）
if [ -d webui ] && [ ! -f webui.bz2 ]; then
    echo "  生成 webui.bz2 ..."
    tar -cjf webui.bz2 -C webui/ .
fi

if python3 -c "import json,sys;c=json.load(open('config.ini'));sys.exit(0 if ('type' in c or c.get('open_path')) else 1)"; then
    [ -f webui.bz2 ] || { echo "ERROR: WebUI 应用必须提供 webui.bz2"; exit 1; }
fi

# 检查占位符
for d in bin depends; do
    if [ -d "$d" ] && grep -rq "PLACEHOLDER" "$d" 2>/dev/null; then
        echo "ERROR: $d/ 中仍存在 PLACEHOLDER 占位文件，请先放入真实产物。"; exit 1
    fi
done

rm -rf "build/${PLATFORM}" "$OUT"
mkdir -p "${STAGING}/usr/local/${APPID}/bin" "${STAGING}/DEBIAN" "$OUT"

cp config.ini "${APPID}.lang" "${STAGING}/usr/local/${APPID}/"
[ -f "${APPID}.env" ] && cp "${APPID}.env" "${STAGING}/usr/local/${APPID}/"
[ -f webui.bz2 ]      && cp webui.bz2      "${STAGING}/usr/local/${APPID}/"
[ -d images ]         && cp -r images      "${STAGING}/usr/local/${APPID}/"
[ -d init.d ]         && cp -r init.d      "${STAGING}/usr/local/${APPID}/"
[ -d nginx ]          && cp -r nginx       "${STAGING}/usr/local/${APPID}/"
[ -d depends ]        && cp -r depends     "${STAGING}/usr/local/${APPID}/"
if [ -d bin ]; then cp -r bin/* "${STAGING}/usr/local/${APPID}/bin/"; chmod +x "${STAGING}/usr/local/${APPID}/bin/"* 2>/dev/null || true; fi

sed "s/^Architecture:.*$/Architecture: ${DPKG_ARCH}/" DEBIAN/control > "${STAGING}/DEBIAN/control"
cp DEBIAN/postinst DEBIAN/prerm DEBIAN/postrm "${STAGING}/DEBIAN/"
chmod 755 "${STAGING}/DEBIAN/postinst" "${STAGING}/DEBIAN/prerm" "${STAGING}/DEBIAN/postrm"

# 指引 5.9：包文件名不含版本号
dpkg-deb --build "${STAGING}" "${OUT}/${APPID}_${PLATFORM}.deb"
( cd "$OUT" && sha256sum "${APPID}_${PLATFORM}.deb" > "${APPID}_${PLATFORM}.deb.sha256" )

echo ""
echo "=== 完成 ==="
dpkg-deb -I "${OUT}/${APPID}_${PLATFORM}.deb" | head -20
ls -lh "$OUT"
