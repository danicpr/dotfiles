#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PATCH_DIR="${SCRIPT_DIR}/patches"
HYPRGLASS_PLUGIN_DIR="${HOME:?}/.local/share/hypr/plugins"
CAELESTIA_QML_OVERLAY="${HOME:?}/.local/share/caelestia-qml/Caelestia"
SHELL_SRC_DIR="${HOME:?}/shell"
HYPRGLASS_BUILD_DIR="/tmp/hyprglass-build"

echo "==> [1/3] Compilando e instalando HyprGlass (hyprland-0.56 + parche de bordes)..."
mkdir -p "${HYPRGLASS_PLUGIN_DIR}"
rm -rf "${HYPRGLASS_BUILD_DIR}"
git clone --depth=1 -b hyprland-0.56 https://github.com/hyprnux/hyprglass.git "${HYPRGLASS_BUILD_DIR}"
git -C "${HYPRGLASS_BUILD_DIR}" apply "${PATCH_DIR}/hyprglass-edge-clamp.patch"
make -C "${HYPRGLASS_BUILD_DIR}" -j"$(nproc)"
cp -f "${HYPRGLASS_BUILD_DIR}/hyprglass.so" "${HYPRGLASS_PLUGIN_DIR}/hyprglass.so"

echo "==> [2/3] Compilando Caelestia.Blobs con shader SDF Liquid Glass..."
if [[ ! -d "${SHELL_SRC_DIR}/.git" ]]; then
    git clone https://github.com/caelestia-dots/shell.git "${SHELL_SRC_DIR}"
fi
cp -f "${SCRIPT_DIR}/blob.frag" "${SHELL_SRC_DIR}/plugin/src/Caelestia/Blobs/shaders/blob.frag"
cmake -S "${SHELL_SRC_DIR}" -B "${SHELL_SRC_DIR}/build" -G Ninja -DENABLE_MODULES=plugin
ninja -C "${SHELL_SRC_DIR}/build" caelestia-blobs caelestia-blobsplugin

echo "==> [3/3] Configurando overlay QML2_IMPORT_PATH en ${CAELESTIA_QML_OVERLAY}..."
mkdir -p "${CAELESTIA_QML_OVERLAY}/lib"
for mod in /usr/lib/qt6/qml/Caelestia/*; do
    name="$(basename "${mod}")"
    [[ "${name}" == "Blobs" || "${name}" == "lib" ]] && continue
    ln -sfn "${mod}" "${CAELESTIA_QML_OVERLAY}/${name}"
done
for lib in /usr/lib/qt6/qml/Caelestia/lib/*; do
    name="$(basename "${lib}")"
    [[ "${name}" == "libcaelestia-blobs.so" ]] && continue
    ln -sfn "${lib}" "${CAELESTIA_QML_OVERLAY}/lib/${name}"
done
ln -sfn "${SHELL_SRC_DIR}/build/qml/Caelestia/Blobs" "${CAELESTIA_QML_OVERLAY}/Blobs"
ln -sfn "${SHELL_SRC_DIR}/build/plugin/src/Caelestia/Blobs/libcaelestia-blobs.so" "${CAELESTIA_QML_OVERLAY}/lib/libcaelestia-blobs.so"

echo "==> Liquid Glass instalado correctamente."
