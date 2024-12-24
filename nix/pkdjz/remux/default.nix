{
  src,
  stdenv,
  ffmpeg,
}:
stdenv.mkDerivation {
  name = "remux";

  inherit src;
  version = src.shortRev;

  buildInputs = [ ffmpeg ];

  buildPhase = ''
    make -C src/ffmpeg/src/ -f makefile5
    make -C src/ffmpeg/src/ -f makefile5 clean
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp src/ffmpeg/bin/V5/remux5 $out/bin/remux
  '';
}
