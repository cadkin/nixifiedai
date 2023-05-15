{ lib
, buildPythonPackage
, fetchPypi
, click
, dataclasses-json
, intervaltree
, libcst
, tabulate
, typing-extensions
, setuptools

, hatchling
, hatch-requirements-txt
, hatch-fancy-pypi-readme
}:

buildPythonPackage rec {
  pname = "pyre-extensions";
  version = "0.0.30";
  #format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-unkjxIbgia+zehBiOo9K6C1zz/QkJtcRxIrwcOW8MbI=";
  };

  #nativeBuildInputs = [
  #  hatchling
  #  hatch-requirements-txt
  #  hatch-fancy-pypi-readme
  #];

  propagatedBuildInputs = [
	click
	dataclasses-json
    intervaltree
	libcst
	tabulate
	typing-extensions
    setuptools
  ];

  meta = with lib; {
    homepage = "https://github.com/facebook/pyre-check";
    description = "Performant type-checking for python";
  };
}
