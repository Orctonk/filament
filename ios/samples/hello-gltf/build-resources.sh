#/usr/bin/env/bash

set -e

# Compile resources.

# The hello-gltf app requires two resources:
# 1. The IBL image
# 2. The skybox image
# These will be compiled into the final binary via the resgen tool.

resgen_path="../../../out/release/filament/bin/resgen"
cmgen_path="../../../out/release/filament/bin/cmgen"

# Ensure that the required tools are present in the out/ directory.
# These can be built by running ./build.sh -p desktop -i release at Filament's root directory.

if [[ ! -e "${resgen_path}" ]]; then
  echo "No resgen binary could be found in ../../../out/release/filament/bin/."
  echo "Ensure Filament has been built/installed before building this app."
  exit 1
fi

if [[ ! -e "${cmgen_path}" ]]; then
  echo "No cmgen binary could be found in ../../../out/release/filament/bin/."
  echo "Ensure Filament has been built/installed before building this app."
  exit 1
fi

# The resgen tool generates an assembly file, resources.apple.S that gets compiled and linked
# into the final binary. It contains all the resources consumed by the app.
"${resgen_path}" \
    --deploy="${PROJECT_DIR}/generated" \
    "${PROJECT_DIR}/generated/venetian_crossroads_2k/venetian_crossroads_2k_skybox.ktx" \
    "${PROJECT_DIR}/generated/venetian_crossroads_2k/venetian_crossroads_2k_ibl.ktx"

# App.cpp and Resources.S include files generated by resgen.
# Touch them to force Xcode to recompile.
touch "${PROJECT_DIR}/hello-gltf/FilamentView/App.cpp"
touch "${PROJECT_DIR}/hello-gltf/SupportFiles/Resources.S"
