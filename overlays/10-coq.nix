self: pkgs:

let
  extendAttrs = base: f: with pkgs; lib.fix (lib.extends f (self: base));

  filtered = drv: drv // { inherit (self.coqFilterSource [] drv) src; };

  coqPackage = self: path:
    let drv = self.callPackage path {}; in
    if builtins.pathExists (path + "/default.nix")
    then filtered drv
    else drv;

  myCoqPackages = self: super:
    let pkg = coqPackage self; in {
      QuickChick      = pkg ./coq/QuickChick.nix;
      fiat_HEAD       = pkg ./coq/fiat.nix;
      category-theory = pkg ./coq/category-theory.nix;
      procrastination = pkg ./coq/procrastination.nix;
      equations       = pkg ./coq/equations.nix;
    };

in {

coqFilterSource = paths: src: pkgs.lib.cleanSourceWith {
  inherit src;
  filter = path: type:
    let baseName = baseNameOf path; in
    !( type == "directory"
       && builtins.elem baseName ([".git"] ++ paths))
    &&
    !( type == "unknown"
       || baseName == ".coq-version"
       || baseName == "CoqMakefile.conf"
       || baseName == "Makefile.coq"
       || baseName == "Makefile.coq-old.conf"
       || baseName == "result"
       || pkgs.stdenv.lib.hasSuffix ".a" path
       || pkgs.stdenv.lib.hasSuffix ".o" path
       || pkgs.stdenv.lib.hasSuffix ".cmi" path
       || pkgs.stdenv.lib.hasSuffix ".cmo" path
       || pkgs.stdenv.lib.hasSuffix ".cmx" path
       || pkgs.stdenv.lib.hasSuffix ".cmxa" path
       || pkgs.stdenv.lib.hasSuffix ".cmxs" path
       || pkgs.stdenv.lib.hasSuffix ".ml.d" path
       || pkgs.stdenv.lib.hasSuffix ".ml4" path
       || pkgs.stdenv.lib.hasSuffix ".ml4.d" path
       || pkgs.stdenv.lib.hasSuffix ".mllib.d" path
       || pkgs.stdenv.lib.hasSuffix ".aux" path
       || pkgs.stdenv.lib.hasSuffix ".glob" path
       || pkgs.stdenv.lib.hasSuffix ".v.d" path
       || pkgs.stdenv.lib.hasSuffix ".vo" path);
};

coq_8_9_override = pkgs.coq_8_9.override {
  ocamlPackages = self.ocaml-ng.ocamlPackages_4_06;
  buildIde = true;
};

coq_HEAD = with pkgs; stdenv.lib.overrideDerivation self.coq_8_9_override (attrs: rec {
  version = "HEAD";
  name = "coq-${version}-pre";
  coq-version = "${version}";

  src = ~/src/coq;

  buildInputs = attrs.buildInputs
    ++ (with pkgs; [ ocaml-ng.ocamlPackages_4_06.num
                     texFull hevea fig2dev imagemagick_light ]);

  setupHook = writeText "setupHook.sh" ''
    addCoqPath () {
      if test -d "''$1/lib/coq/${coq-version}/user-contrib"; then
        export COQPATH="''${COQPATH}''${COQPATH:+:}''$1/lib/coq/${coq-version}/user-contrib/"
      fi
    }

    addEnvHooks "$targetOffset" addCoqPath
  '';

  preConfigure = ''
    configureFlagsArray=(
      -with-doc no
      -coqide no
    )
  '';
});

coqPackages_HEAD = extendAttrs (self.mkCoqPackages self.coq_HEAD) myCoqPackages;
coqPackages_8_9  = extendAttrs (self.mkCoqPackages self.coq_8_9) myCoqPackages;
coqPackages_8_8  = extendAttrs (self.mkCoqPackages self.coq_8_8) myCoqPackages;
coqPackages_8_7  = extendAttrs (self.mkCoqPackages self.coq_8_7) myCoqPackages;
coqPackages_8_6  = extendAttrs (self.mkCoqPackages self.coq_8_6) myCoqPackages;
coqPackages_8_5  = self.mkCoqPackages self.coq_8_5;
coqPackages_8_4  = self.mkCoqPackages self.coq_8_4;

}
