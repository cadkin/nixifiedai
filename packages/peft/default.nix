{
  buildPythonPackage,
  fetchFromGitHub,
  lib,

  numpy,
  torch,
  accelerate,
  transformers
}:

buildPythonPackage rec {
  pname = "peft";
  version = "v0.2.0";

  src = fetchFromGitHub {
    owner  = "huggingface";
    repo   = "peft";
    rev    = version;
    sha256 = "sha256-NPpY29HMQe5KT0JdlLAXY9MVycDslbP2i38NSTirB3I=";
  };

  buildInputs = [ numpy torch transformers ];
  propagatedBuildInputs = [
    accelerate
  ];

  # TODO FIXME
  doCheck = false;

  meta = with lib; {
    description = "PEFT: State-of-the-art Parameter-Efficient Fine-Tuning.";
    homepage = "https://github.com/huggingface/peft.git";
  };
}
