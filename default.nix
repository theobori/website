{
  lib,
  stdenv,
  nodejs,
  npmHooks,
  fetchNpmDeps,
  my-website-carbon-badges-pkg,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "theobori-cafe";
  version = "0.0.1";

  src = ./.;

  npmDeps = fetchNpmDeps {
    src = "${finalAttrs.src}";
    hash = "sha256-YHmI+Q4vP9drqmSmiYRtBkp4mK9RBm62dcZeIjWVmBc=";
  };

  npmBuildScript = "build";

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
    npmHooks.npmBuildHook
  ];

  installPhase = ''
    runHook preInstall

    mv _site $out
    cp ${my-website-carbon-badges-pkg}/* $out/

    runHook postInstall
  '';

  meta = {
    description = "My personal website and blog";
    license = lib.licenses.mit;
  };
})
