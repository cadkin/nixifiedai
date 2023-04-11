{ buildPythonPackage, fetchPypi, lib, packaging, psutil, pyyaml, fastapi }:

buildPythonPackage rec {
  pname = "fastapi-events";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-I4DNw+MNyJjWtyHWI8V1xvWwXuNaPuBa3wuQsSue0fk=";
  };

  propagatedBuildInputs = [ packaging psutil pyyaml fastapi ];

  # TODO FIXME
  doCheck = false;

  meta = with lib; {
    description = "Event dispatching library for FastAPI";
    homepage = "https://pypi.org/project/fastapi-events/";
  };
}
