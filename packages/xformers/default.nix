{ lib
, pkgs
, buildPythonPackage
, fetchFromGitHub
, torch
, numpy
, which
, pyre-extensions
, pythonRelaxDepsHook
, cudaPackages
, gpuTargets ? [ ]
}:

let
  cudatoolkit_joined = pkgs.symlinkJoin {
    name = "${cudaPackages.cudatoolkit.name}-unsplit";
    # nccl is here purely for semantic grouping it could be moved to nativeBuildInputs
    paths = [ cudaPackages.cudatoolkit.out cudaPackages.cudatoolkit.lib ];
  };

  # https://github.com/pytorch/pytorch/blob/v1.13.1/torch/utils/cpp_extension.py#L1751
  supportedTorchCudaCapabilities =
    let
      real = ["3.5" "3.7" "5.0" "5.2" "5.3" "6.0" "6.1" "6.2" "7.0" "7.2" "7.5" "8.0" "8.6"];
      ptx = lib.lists.map (x: "${x}+PTX") real;
    in
    real ++ ptx;

  # NOTE: The lists.subtractLists function is perhaps a bit unintuitive. It subtracts the elements
  #   of the first list *from* the second list. That means:
  #   lists.subtractLists a b = b - a

  # For CUDA
  supportedCudaCapabilities = lib.lists.intersectLists cudaPackages.cudaFlags.cudaCapabilities supportedTorchCudaCapabilities;
  unsupportedCudaCapabilities = lib.lists.subtractLists supportedCudaCapabilities cudaPackages.cudaFlags.cudaCapabilities;

  # Use trivial.warnIf to print a warning if any unsupported GPU targets are specified.
  gpuArchWarner = supported: unsupported:
    lib.trivial.throwIf (supported == [ ])
      (
        "No supported GPU targets specified. Requested GPU targets: "
        + lib.strings.concatStringsSep ", " unsupported
      )
      supported;
in
buildPythonPackage rec {
  pname = "xformers";
  version = "0.0.19";

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = "xformers";
    rev = "v${version}";
    sha256 = "sha256-g+5GbUDmHbieyYlO6eDyFfj8l5fGXO+rmt6cBAweqN4=";
    fetchSubmodules = true;
  };

  BUILD_VERSION = version;
  FORCE_CUDA=1;

  gpuTargetString = lib.strings.concatStringsSep ";" (
    if gpuTargets != [ ] then
    # If gpuTargets is specified, it always takes priority.
      gpuTargets
    else
      gpuArchWarner supportedCudaCapabilities unsupportedCudaCapabilities
  );

  preConfigure = ''
    export CC=${cudaPackages.cudatoolkit.cc}/bin/gcc CXX=${cudaPackages.cudatoolkit.cc}/bin/g++
    export TORCH_CUDA_ARCH_LIST="${gpuTargetString}"
  '';

  pythonRelaxDeps = [ "pyre-extensions" ];

  nativeBuildInputs = [
    which
    pythonRelaxDepsHook
    cudaPackages.autoAddOpenGLRunpathHook
    cudatoolkit_joined
  ];

  propagatedBuildInputs = [
    torch
    numpy
    pyre-extensions
  ];

  # TODO FIXME
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/facebookresearch/xformers";
    description = "Hackable and optimized Transformers building blocks, supporting a composable construction.";
  };
}
