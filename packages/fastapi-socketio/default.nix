{ buildPythonPackage, fetchPypi, lib, packaging, psutil, pyyaml, fastapi, python-socketio }:

buildPythonPackage rec {
  pname = "fastapi-socketio";
  version = "0.0.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-jHOqlP4b8cmWT/iSM6a6Uu7uw6yLneACTZ2CsR5GveU=";
  };

  propagatedBuildInputs = [ packaging psutil pyyaml fastapi python-socketio ];

  # TODO FIXME
  doCheck = false;

  meta = with lib; {
    description = "Easily integrate socket.io with your FastAPI app.";
    homepage = "https://pypi.org/project/fastapi-socketio/";
  };
}
