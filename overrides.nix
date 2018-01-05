{ pkgs }:
rec {

z3-debug = true;

##############################################################################
# Haskell

myHaskellPackageDefs = super:
  with super; let pkg = super.callPackage; in rec {

  # Personal packages
  async-pool       = pkg ~/src/async-pool {};
  bindings-DSL     = pkg ~/oss/bindings-DSL {};
  bytestring-fiat  = pkg ~/src/bytestring/extract {};
  c2hsc            = pkg ~/src/c2hsc {};
  categorical      = pkg ~/src/categorical {};
  commodities      = pkg ~/src/ledger4/commodities {};
  consistent       = pkg ~/src/consistent {};
  coq-haskell      = pkg ~/src/coq-haskell {};
  extract          = pkg ~/src/bytestring/extract {};
  fuzzcheck        = pkg ~/src/fuzzcheck {};
  git-all          = pkg ~/src/git-all {};
  git-du           = pkg ~/src/git-du {};
  git-monitor      = pkg ~/src/gitlib/git-monitor {};
  gitlib           = pkg ~/src/gitlib/gitlib {};
  gitlib-cmdline   = pkg ~/src/gitlib/gitlib-cmdline { git = pkgs.gitAndTools.git; };
  gitlib-hit       = pkg ~/src/gitlib/gitlib-hit {};
  gitlib-libgit2   = pkg ~/src/gitlib/gitlib-libgit2 {};
  gitlib-test      = pkg ~/src/gitlib/gitlib-test {};
  hierarchy        = pkg ~/src/hierarchy {};
  hlibgit2         = pkg ~/src/gitlib/hlibgit2 { git = pkgs.gitAndTools.git; };
  hnix             = pkg ~/src/hnix {};
  hours            = pkg ~/src/hours {};
  ipcvar           = pkg ~/src/ipcvar {};
  linearscan       = pkg ~/src/linearscan {};
  linearscan-hoopl = pkg ~/src/linearscan-hoopl {};
  logging          = pkg ~/src/logging {};
  monad-extras     = pkg ~/src/monad-extras {};
  parsec-free      = pkg ~/src/parsec-free {};
  pipes-async      = pkg ~/src/pipes-async {};
  pipes-files      = pkg ~/src/pipes-files {};
  pushme           = pkg ~/src/pushme {};
  recursors        = pkg ~/src/recursors {};
  runmany          = pkg ~/src/runmany {};
  simple-mirror    = pkg ~/src/hackage-mirror {};
  sitebuilder      = pkg ~/doc/sitebuilder { yuicompressor = pkgs.yuicompressor; };
  sizes            = pkg ~/src/sizes {};
  una              = pkg ~/src/una {};
  z3-api-4_5_0     = pkg ~/src/z3-generate-api/api/4.5.0 { };
  z3-generate-api  = pkg ~/src/z3-generate-api { };
  z3cat            = pkg ~/src/z3cat {};

  putting-lenses-to-work = pkg ~/doc/papers/putting-lenses-to-work {};

  # Open Source
  concat-classes   = pkg ~/oss/concat/classes {};
  concat-examples  = pkg ~/oss/concat/examples {};
  concat-graphics  = pkg ~/oss/concat/graphics {};
  concat-inline    = pkg ~/oss/concat/inline {};
  concat-plugin    = pkg ~/oss/concat/plugin {};
  freer-effects    = pkg ~/oss/freer-effects {};
  hs-to-coq        = pkg ~/oss/hs-to-coq/hs-to-coq {};

  z3 = pkg ~/src/haskell-z3 {
    z3 = if z3-debug
      then pkgs.z3.overrideDerivation (attrs: {
        src = ~/oss/z3;
        configurePhase = ''
          ${pkgs.python2.interpreter} scripts/mk_make.py --prefix=$out \
            --python --pypkgdir=$out/${pkgs.python2.sitePackages} -d
          cd build
        '';
      })
      else pkgs.z3;
  };

  # BAE packages
  comparator          = pkg ~/bae/autofocus-deliverable/xhtml/comparator {};
  generator           = pkg ~/bae/autofocus-deliverable/xhtml/generator {};
  harness             = pkg ~/bae/autofocus-deliverable/rings-dashboard/mitll-harness {};
  rings-dashboard     = pkg ~/bae/autofocus-deliverable/rings-dashboard {};
  rings-dashboard-api = pkg ~/bae/autofocus-deliverable/rings-dashboard/rings-dashboard-api {};
  solver              = pkg ~/bae/concerto/solver {};
};

haskellPackage_8_0_overrides = libProf: mypkgs: self: super:
  with pkgs.haskell.lib; with super; let pkg = callPackage; in mypkgs // rec {

  Agda                      = dontHaddock super.Agda;
  blaze-builder-enumerator  = doJailbreak super.blaze-builder-enumerator;
  Cabal                     = super.Cabal_1_24_2_0;
  cabal-helper              = super.cabal-helper.override {
    cabal-install = cabal-install;
    Cabal = Cabal;
  };
  categorical               = dontCheck mypkgs.categorical;
  commodities               = doJailbreak mypkgs.commodities;
  compressed                = doJailbreak super.compressed;
  concat-classes            = dontHaddock mypkgs.concat-classes;
  concat-examples           = dontHaddock (dontCheck mypkgs.concat-examples);
  concat-graphics           = dontCheck mypkgs.concat-graphics;
  concat-inline             = dontHaddock mypkgs.concat-inline;
  concat-plugin             = dontHaddock mypkgs.concat-plugin;
  concurrent-output         = doJailbreak super.concurrent-output;
  consistent                = dontCheck mypkgs.consistent;
  derive-storable           = dontCheck super.derive-storable;
  diagrams-graphviz         = doJailbreak super.diagrams-graphviz;
  diagrams-rasterific       = doJailbreak super.diagrams-rasterific;
  ghc-compact               = null;
  hakyll                    = doJailbreak super.hakyll;
  heap                      = dontCheck super.heap;
  hierarchy                 = doJailbreak super.hierarchy;
  hlibgit2                  = doJailbreak super.hlibgit2;
  ipcvar                    = dontCheck super.ipcvar;
  linearscan-hoopl          = dontCheck super.linearscan-hoopl;
  liquidhaskell             = doJailbreak super.liquidhaskell;
  pipes-binary              = doJailbreak super.pipes-binary;
  pipes-files               = dontCheck (doJailbreak super.pipes-files);
  pipes-zlib                = dontCheck (doJailbreak super.pipes-zlib);
  recursors                 = doJailbreak super.recursors;
  runmany                   = doJailbreak super.runmany;
  sbvPlugin                 = doJailbreak super.sbvPlugin;
  shelly                    = dontCheck super.shelly;
  text-show                 = dontCheck super.text-show;
  time-recurrence           = doJailbreak super.time-recurrence;
  timeparsers               = doJailbreak (dontCheck (pkg ~/oss/timeparsers {}));
  units                     = super.units.override { th-desugar = th-desugar_1_6; };
  z3cat                     = dontCheck mypkgs.z3cat;

  cabal-install = callPackage
    ({ mkDerivation, array, async, base, base16-bytestring, binary
     , bytestring, Cabal, containers, cryptohash-sha256, directory
     , filepath, hackage-security, hashable, HTTP, mtl, network
     , network-uri, pretty, process, QuickCheck, random, regex-posix
     , stm, tagged, tar, tasty, tasty-hunit, tasty-quickcheck, time
     , unix, zlib
     }:
     mkDerivation {
       pname = "cabal-install";
       version = "1.24.0.2";
       sha256 = "1q0gl3i9cpg854lcsiifxxginnvhp2bpx19wkkzpzrd072983j1a";
       revision = "1";
       editedCabalFile = "0v112hvvppa31sklpzg54vr0hfidy1334kg5p3jc0gbgl8in1n90";
       isLibrary = false;
       isExecutable = true;
       executableHaskellDepends = [
         array async base base16-bytestring binary bytestring Cabal
         containers cryptohash-sha256 directory filepath hackage-security
         hashable HTTP mtl network network-uri pretty process random stm tar
         time unix zlib
       ];
       testHaskellDepends = [
         array async base binary bytestring Cabal containers directory
         filepath hackage-security hashable HTTP mtl network network-uri
         pretty process QuickCheck random regex-posix stm tagged tar tasty
         tasty-hunit tasty-quickcheck time unix zlib
       ];
       doCheck = false;
       postInstall = ''
         mkdir $out/etc
         mv bash-completion $out/etc/bash_completion.d
       '';
       homepage = "http://www.haskell.org/cabal/";
       description = "The command-line interface for Cabal and Hackage";
       license = pkgs.stdenv.lib.licenses.bsd3;
       maintainers = with pkgs.stdenv.lib.maintainers; [ peti ];
     }) { Cabal = Cabal; };

  th-desugar_1_6 = callPackage
    ({ mkDerivation, base, containers, hspec, HUnit, mtl, syb
     , template-haskell, th-expand-syns, th-lift, th-orphans
     }:
     mkDerivation {
       pname = "th-desugar";
       version = "1.6";
       sha256 = "0kv3gxvr7izvg1s86p92b5318bv7pjghig2hx9q21cg9ppifry68";
       revision = "2";
       editedCabalFile = "0rimjzkqky6sq4yba7vqra7hj29903f9xsn2g8rc23abrm35vds3";
       libraryHaskellDepends = [
         base containers mtl syb template-haskell th-expand-syns th-lift
         th-orphans
       ];
       testHaskellDepends = [
         base containers hspec HUnit mtl syb template-haskell th-expand-syns
         th-lift th-orphans
       ];
       homepage = "https://github.com/goldfirere/th-desugar";
       description = "Functions to desugar Template Haskell";
       license = stdenv.lib.licenses.bsd3;
     }) {};

  singletons = dontCheck (doJailbreak (callPackage
    ({ mkDerivation, base, Cabal, containers, directory, filepath, mtl
     , process, syb, tasty, tasty-golden, template-haskell, th-desugar
     }:
     mkDerivation {
       pname = "singletons";
       version = "2.2";
       sha256 = "1bwcsp1x8bivmvkv8a724lsnwyjharhb0x0hl0isp3jgigh0dg9k";
       libraryHaskellDepends = [
         base containers mtl syb template-haskell th-desugar
       ];
       testHaskellDepends = [
         base Cabal directory filepath process tasty tasty-golden
       ];
       homepage = "http://www.github.com/goldfirere/singletons";
       description = "A framework for generating singleton types";
       license = stdenv.lib.licenses.bsd3;
     }) { th-desugar = th-desugar_1_6; }));

  # lens-family 1.2.2 requires GHC 8.2 or higher
  lens-family = callPackage
    ({ mkDerivation, base, containers, lens-family-core, mtl
     , transformers
     }:
     mkDerivation {
       pname = "lens-family";
       version = "1.2.1";
       sha256 = "1dwsrli94i8vs1wzfbxbxh49qhn8jn9hzmxwgd3dqqx07yx8x0s1";
       libraryHaskellDepends = [
         base containers lens-family-core mtl transformers
       ];
       description = "Lens Families";
       license = stdenv.lib.licenses.bsd3;
     }) {};

  lens-family-core = callPackage
    ({ mkDerivation, base, containers, transformers }:
     mkDerivation {
       pname = "lens-family-core";
       version = "1.2.1";
       sha256 = "190r3n25m8x24nd6xjbbk9x0qhs1mw22xlpsbf3cdp3cda3vkqwm";
       libraryHaskellDepends = [ base containers transformers ];
       description = "Haskell 98 Lens Families";
       license = stdenv.lib.licenses.bsd3;
     }) {};

  haskell-src-exts-simple_1_20_0_0 =
    super.haskell-src-exts-simple_1_20_0_0.override {
      haskell-src-exts = super.haskell-src-exts_1_20_1;
    };

  lambdabot-haskell-plugins = doJailbreak (
    super.lambdabot-haskell-plugins.override {
      haskell-src-exts-simple = haskell-src-exts-simple_1_20_0_0;
    });

  ghc-mod = dontCheck (doJailbreak (callPackage
    ({ mkDerivation, base, binary, bytestring, Cabal, cabal-helper
     , containers, criterion, deepseq, directory, djinn-ghc, doctest
     , extra, fclabels, filepath, ghc, ghc-boot, ghc-paths
     , ghc-syb-utils, haskell-src-exts, hlint, hspec, monad-control
     , monad-journal, mtl, old-time, optparse-applicative, pipes
     , process, safe, semigroups, shelltest, split, syb
     , template-haskell, temporary, text, time, transformers
     , transformers-base
     }:
     mkDerivation {
       pname = "ghc-mod";
       version = "5.9.0.0";
       src = pkgs.fetchFromGitHub {
         owner = "DanielG";
         repo = "ghc-mod";
         rev = "0f281bea89edf8f11c82c5359ee2b3ce19888b99";
         sha256 = "0f70nrlqgizsrya1x5kgxib7hxc0ip18b7nh62jclny1fq4r02vm";
       };
       isLibrary = true;
       isExecutable = true;
       enableSeparateDataOutput = true;
       setupHaskellDepends = [
         base Cabal containers directory filepath process template-haskell
         transformers
       ];
       libraryHaskellDepends = [
         base binary bytestring cabal-helper containers deepseq directory
         djinn-ghc extra fclabels filepath ghc ghc-boot ghc-paths
         ghc-syb-utils haskell-src-exts hlint monad-control monad-journal
         mtl old-time optparse-applicative pipes process safe semigroups
         split syb template-haskell temporary text time transformers
         transformers-base
       ];
       executableHaskellDepends = [
         base binary deepseq directory fclabels filepath ghc monad-control
         mtl old-time optparse-applicative process semigroups split time
       ];
       testHaskellDepends = [
         base cabal-helper containers directory doctest fclabels filepath
         ghc ghc-boot hspec monad-journal mtl process split temporary
         transformers
       ];
       testToolDepends = [ shelltest ];
       benchmarkHaskellDepends = [
         base criterion directory filepath temporary
       ];
       homepage = "https://github.com/DanielG/ghc-mod";
       description = "Happy Haskell Hacking";
       license = pkgs.stdenv.lib.licenses.agpl3;
       hydraPlatforms = pkgs.stdenv.lib.platforms.none;
     }) { shelltest = null;
          Cabal = Cabal;
          cabal-helper = cabal-helper; }));

  recurseForDerivations = true;

  mkDerivation = args: super.mkDerivation (args // {
    enableLibraryProfiling = libProf;
    enableExecutableProfiling = false;
  });
};

haskellPackage_8_2_overrides = libProf: mypkgs: self: super:
  with pkgs.haskell.lib; with super; let pkg = callPackage; in mypkgs // rec {

  Agda                     = dontHaddock super.Agda;
  blaze-builder-enumerator = doJailbreak super.blaze-builder-enumerator;
  compressed               = doJailbreak super.compressed;
  commodities              = doJailbreak mypkgs.commodities;
  consistent               = doJailbreak (dontCheck mypkgs.consistent);
  derive-storable          = dontCheck super.derive-storable;
  diagrams-graphviz        = doJailbreak super.diagrams-graphviz;
  diagrams-rasterific      = doJailbreak super.diagrams-rasterific;
  git-annex                = dontCheck super.git-annex;
  hakyll                   = doJailbreak super.hakyll;
  heap                     = dontCheck super.heap;
  hierarchy                = doJailbreak super.hierarchy;
  ipcvar                   = dontCheck super.ipcvar;
  lattices                 = doJailbreak super.lattices;
  linearscan-hoopl         = dontCheck super.linearscan-hoopl;
  pandoc-citeproc          = pkg ~/oss/pandoc-citeproc {};
  pipes-binary             = doJailbreak super.pipes-binary;
  pipes-files              = dontCheck (doJailbreak super.pipes-files);
  pipes-zlib               = dontCheck (doJailbreak super.pipes-zlib);
  posix-paths              = doJailbreak super.posix-paths;
  recursors                = doJailbreak super.recursors;
  runmany                  = doJailbreak super.runmany;
  shelly                   = dontCheck (doJailbreak super.shelly);
  text-icu                 = dontCheck super.text-icu;
  text-show                = dontCheck super.text-show;
  these                    = doJailbreak super.these;
  time-recurrence          = doJailbreak super.time-recurrence;
  timeparsers              = doJailbreak (dontCheck (pkg ~/oss/timeparsers {}));

  cabal-helper = doJailbreak (callPackage
    ({ mkDerivation, base, bytestring, Cabal, cabal-install, containers
     , directory, extra, filepath, ghc-prim, mtl, process
     , template-haskell, temporary, transformers, unix, utf8-string
     , semigroupoids, unix-compat
     }:
     mkDerivation {
       pname = "cabal-helper";
       version = "4bfc6b";
       src = pkgs.fetchFromGitHub {
         owner = "DanielG";
         repo = "cabal-helper";
         rev = "4bfc6b916fcc696a5d82e7cd35713d6eabcb0533";
         sha256 = "1a8231as0wdvi0q73ha9lc0qrx23kmcwf910qaicvmdar5p2b15m";
       };
       isLibrary = true;
       isExecutable = true;
       setupHaskellDepends = [
         base Cabal containers directory filepath process template-haskell
         transformers semigroupoids unix-compat
       ];
       libraryHaskellDepends = [
         base Cabal directory filepath ghc-prim mtl process transformers
         semigroupoids unix-compat
       ];
       executableHaskellDepends = [
         base bytestring Cabal directory filepath ghc-prim mtl process
         template-haskell temporary transformers utf8-string semigroupoids
         unix-compat
       ];
       testHaskellDepends = [
         base bytestring Cabal directory extra filepath ghc-prim mtl process
         template-haskell temporary transformers unix utf8-string
         semigroupoids unix-compat
       ];
       testToolDepends = [ cabal-install ];
       doCheck = false;
       description = "Simple interface to some of Cabal's configuration state used by ghc-mod";
       license = pkgs.stdenv.lib.licenses.agpl3;
       hydraPlatforms = pkgs.stdenv.lib.platforms.none;
     }) {});

  haskell-src-exts-simple_1_20_0_0 =
    super.haskell-src-exts-simple_1_20_0_0.override {
      haskell-src-exts = super.haskell-src-exts_1_20_1;
    };

  lambdabot-haskell-plugins =
    super.lambdabot-haskell-plugins.override {
      haskell-src-exts-simple = haskell-src-exts-simple_1_20_0_0;
    };

  ghc-mod = dontCheck (doJailbreak (callPackage
    ({ mkDerivation, base, binary, bytestring, Cabal, cabal-helper
     , containers, criterion, deepseq, directory, djinn-ghc, doctest
     , extra, fclabels, filepath, ghc, ghc-boot, ghc-paths
     , ghc-syb-utils, haskell-src-exts, hlint, hspec, monad-control
     , monad-journal, mtl, old-time, optparse-applicative, pipes
     , process, safe, semigroups, shelltest, split, syb
     , template-haskell, temporary, text, time, transformers
     , transformers-base
     }:
     mkDerivation {
       pname = "ghc-mod";
       version = "5.9.0.0";
       src = pkgs.fetchFromGitHub {
         owner = "DanielG";
         repo = "ghc-mod";
         rev = "c3530f75d5c539c91ed0b8d38e90d66cbaa66a35";
         sha256 = "1q7sz50da645x7ysqy8k1m09adidqp62vf8v7zin69yv76fsz9nn";
       };
       isLibrary = true;
       isExecutable = true;
       enableSeparateDataOutput = true;
       setupHaskellDepends = [
         base Cabal containers directory filepath process template-haskell
         transformers cabal-doctest
       ];
       libraryHaskellDepends = [
         base binary bytestring cabal-helper containers deepseq directory
         djinn-ghc extra fclabels filepath ghc ghc-boot ghc-paths
         ghc-syb-utils haskell-src-exts hlint monad-control monad-journal
         mtl old-time optparse-applicative pipes process safe semigroups
         split syb template-haskell temporary text time transformers
         transformers-base
       ];
       executableHaskellDepends = [
         base binary deepseq directory fclabels filepath ghc monad-control
         mtl old-time optparse-applicative process semigroups split time
       ];
       testHaskellDepends = [
         base cabal-helper containers directory doctest fclabels filepath
         ghc ghc-boot hspec monad-journal mtl process split temporary
         transformers
       ];
       testToolDepends = [ shelltest ];
       benchmarkHaskellDepends = [
         base criterion directory filepath temporary
       ];
       homepage = "https://github.com/DanielG/ghc-mod";
       description = "Happy Haskell Hacking";
       license = pkgs.stdenv.lib.licenses.agpl3;
       hydraPlatforms = pkgs.stdenv.lib.platforms.none;
     }) { cabal-helper = cabal-helper;
          shelltest = null; }));

  recurseForDerivations = true;

  mkDerivation = args: super.mkDerivation (args // {
    enableLibraryProfiling = libProf;
    enableExecutableProfiling = false;
  });
};

haskellPackage_HEAD_overrides = libProf: mypkgs: self: super:
  with pkgs.haskell.lib; with super; let pkg = callPackage; in mypkgs // rec {

  Agda                     = dontHaddock super.Agda;
  blaze-builder-enumerator = doJailbreak super.blaze-builder-enumerator;
  compressed               = doJailbreak super.compressed;
  consistent               = doJailbreak (dontCheck mypkgs.consistent);
  derive-storable          = dontCheck super.derive-storable;
  diagrams-graphviz        = doJailbreak super.diagrams-graphviz;
  diagrams-rasterific      = doJailbreak super.diagrams-rasterific;
  hakyll                   = doJailbreak super.hakyll;
  hierarchy                = doJailbreak super.hierarchy;
  ipcvar                   = dontCheck super.ipcvar;
  lattices                 = doJailbreak super.lattices;
  linearscan-hoopl         = dontCheck super.linearscan-hoopl;
  pandoc-citeproc          = pkg ~/oss/pandoc-citeproc {};
  pipes-binary             = doJailbreak super.pipes-binary;
  pipes-files              = dontCheck (doJailbreak super.pipes-files);
  pipes-zlib               = dontCheck (doJailbreak super.pipes-zlib);
  posix-paths              = doJailbreak super.posix-paths;
  recursors                = doJailbreak super.recursors;
  shelly                   = doJailbreak super.shelly;
  text-icu                 = dontCheck super.text-icu;
  these                    = doJailbreak super.these;
  time-recurrence          = doJailbreak super.time-recurrence;
  timeparsers              = doJailbreak (dontCheck (pkg ~/oss/timeparsers {}));

  mkDerivation = args: super.mkDerivation (args // {
    enableLibraryProfiling = libProf;
    enableExecutableProfiling = false;
  });
};

myHaskellPackages = haskellPackages: with haskellPackages; [
  # HFuse
  # liquidhaskell
  # threadscope
  Boolean
  HTTP
  HUnit
  IfElse
  MemoTrie
  MissingH
  Network-NineP
  QuickCheck
  abstract-deque
  abstract-par
  adjunctions
  aeson
  alex
  amqp
  async
  async-pool
  attempt
  attoparsec
  attoparsec-conduit
  attoparsec-enumerator
  base
  base-unicode-symbols
  base16-bytestring
  base64-bytestring
  basic-prelude
  bifunctors
  bindings-DSL
  blaze-builder
  blaze-builder-conduit
  blaze-builder-enumerator
  blaze-html
  blaze-markup
  blaze-textual
  bool-extras
  byteable
  byteorder
  bytes
  bytestring
  bytestring-mmap
  bytestring-show
  c2hsc
  cabal-helper
  cabal-install
  case-insensitive
  cassava
  categories
  cereal
  cereal-conduit
  charset
  checkers
  chunked-data
  classy-prelude
  classy-prelude-conduit
  cmdargs
  commodities
  comonad
  comonad-transformers
  composition
  compressed
  cond
  conduit
  conduit-combinators
  conduit-extra
  configurator
  connection
  consistent
  constraints
  containers
  contravariant
  convertible
  cpphs
  criterion
  cryptohash
  css-text
  curl
  data-checked
  data-default
  data-default-class
  data-fix
  derive-storable
  diagrams
  diagrams-builder
  diagrams-core
  diagrams-graphviz
  diagrams-lib
  diagrams-svg
  directory
  distributive
  djinn
  dlist
  dlist-instances
  dns
  doctest
  doctest-prop
  either
  enclosed-exceptions
  errors
  exceptions
  extensible-exceptions
  failure
  fast-logger
  fgl
  file-embed
  filemanip
  filepath
  fingertree
  fmlist
  foldl
  free
  free-vl
  freer-effects
  fsnotify
  fuzzcheck
  generic-lens
  ghc-core
  ghc-mod
  ghc-paths
  gitlib
  gitlib-cmdline
  gitlib-libgit2
  gitlib-sample
  gitlib-test
  graphviz
  groups
  hakyll
  hamlet
  happy
  hashable
  hashtables
  haskell-lexer
  haskell-src
  haskell-src-exts
  hasktags
  hdevtools
  here
  hierarchy
  hlibgit2
  hlint
  hnix
  hpack
  hpack
  hslogger
  hspec
  hspec-expectations
  hspec-megaparsec
  hspec-smallcheck
  hspec-wai
  html
  http-client
  http-client-tls
  http-date
  http-media
  http-types
  interpolate
  io-memoize
  io-storage
  io-streams
  ipcvar
  json
  json-stream
  kan-extensions
  kdt
  keys
  lambdabot
  language-c
  lattices
  lens
  lens-action
  lens-aeson
  lens-datetime
  lens-family
  lens-family-core
  lifted-async
  lifted-base
  linear
  linearscan
  linearscan-hoopl
  list-extras
  list-t
  logging
  logict
  machinecell
  machines
  megaparsec
  mime-mail
  mime-types
  mmorph
  monad-control
  monad-coroutine
  monad-extras
  monad-logger
  monad-loops
  monad-par
  monad-par-extras
  monad-stm
  monadloc
  mono-traversable
  monoid-extras
  mtl
  mueval
  multimap
  network
  network-simple
  newtype
  numbers
  operational
  optparse-applicative
  pandoc
  parallel
  parallel-io
  parsec
  parsers
  pcre-heavy
  pipes
  pipes-async
  pipes-attoparsec
  pipes-binary
  pipes-bytestring
  pipes-concurrency
  pipes-extras
  pipes-files
  pipes-group
  pipes-http
  pipes-network
  pipes-parse
  pipes-safe
  pipes-text
  pipes-zlib
  pointed
  pointfree
  posix-paths
  postgresql-simple
  pretty-show
  process
  process-extras
  profunctors
  quickcheck-instances
  random
  recursors
  reducers
  reflection
  regex-applicative
  regex-base
  regex-compat
  regex-posix
  resourcet
  retry
  safe
  sbv
  sbvPlugin
  scalpel
  scientific
  scotty
  semigroupoids
  semigroups
  semiring-simple
  servant
  servant-blaze
  servant-client
  servant-docs
  servant-foreign
  servant-js
  servant-server
  shake
  shakespeare
  shelly
  silently
  simple-reflect
  smallcheck
  speculation
  split
  spoon
  stm
  stm-chans
  stm-stats
  streaming
  streaming-bytestring
  strict
  stringsearch
  strptime
  stylish-haskell
  syb
  system-fileio
  system-filepath
  tagged
  tar
  tardis
  tasty
  tasty-hspec
  tasty-hunit
  tasty-quickcheck
  tasty-smallcheck
  temporary
  text
  text-format
  text-show
  these
  thyme
  time
  time-recurrence
  timeparsers
  timeplot
  tls
  total
  transformers
  transformers-base
  trifecta
  turtle
  uniplate
  unix-compat
  unordered-containers
  uuid
  vector
  vector-sized
  void
  wai
  warp
  weigh
  x509
  x509-store
  x509-system
  yaml
  z3
  zippers
  zlib
];

haskPkgs = haskellPackages_8_2;
haskellPackages = haskPkgs;

mkHaskellPackages = hpkgs: hoverrides: hpkgs.override {
  overrides = self: super: hoverrides (myHaskellPackageDefs super) self super;
};

haskellPackages_HEAD = mkHaskellPackages pkgs.haskell.packages.ghcHEAD
  (haskellPackage_HEAD_overrides false);
profiledHaskellPackages_HEAD = mkHaskellPackages pkgs.haskell.packages.ghcHEAD
  (haskellPackage_HEAD_overrides true);

haskellPackages_8_2 = mkHaskellPackages pkgs.haskell.packages.ghc822
  (haskellPackage_8_2_overrides false);
profiledHaskellPackages_8_2 = mkHaskellPackages pkgs.haskell.packages.ghc822
  (haskellPackage_8_2_overrides true);

haskellPackages_8_0 = mkHaskellPackages pkgs.haskell.packages.ghc802
  (haskellPackage_8_0_overrides false);
profiledHaskellPackages_8_0 = mkHaskellPackages pkgs.haskell.packages.ghc802
  (haskellPackage_8_0_overrides true);

ghcHEADProfEnv = pkgs.myEnvFun {
  name = "ghcHEADprof";
  buildInputs = with pkgs.haskell.lib; with haskellPackages_HEAD; [
    pkgs.darwin.apple_sdk.frameworks.Cocoa
    (ghcWithHoogle myHaskellPackages)
  ];
};

ghc82Env = pkgs.myEnvFun {
  name = "ghc82";
  buildInputs = with pkgs.haskell.lib; with haskellPackages_8_2; [
    pkgs.darwin.apple_sdk.frameworks.Cocoa
    (ghcWithHoogle myHaskellPackages)
  ];
};

ghc82ProfEnv = pkgs.myEnvFun {
  name = "ghc82prof";
  buildInputs = with pkgs.haskell.lib; with profiledHaskellPackages_8_2; [
    pkgs.darwin.apple_sdk.frameworks.Cocoa
    (ghcWithHoogle myHaskellPackages)
  ];
};

ghc80Env = pkgs.myEnvFun {
  name = "ghc80";
  buildInputs = with pkgs.haskell.lib; with haskellPackages_8_0; [
    pkgs.darwin.apple_sdk.frameworks.Cocoa
    (ghcWithHoogle (pkgs: myHaskellPackages pkgs ++ (with pkgs; [
       Agda
       # idris
       categorical
       concat-inline
       concat-classes
       concat-plugin
       concat-examples
       concat-graphics
       singletons
       units
       z3cat
     ])))

    splot
  ];
};

ghc80ProfEnv = pkgs.myEnvFun {
  name = "ghc80prof";
  buildInputs = with pkgs.haskell.lib; with profiledHaskellPackages_8_0; [
    pkgs.darwin.apple_sdk.frameworks.Cocoa
    (ghcWithHoogle (pkgs: myHaskellPackages pkgs ++ (with pkgs; [
       categorical
       concat-inline
       concat-classes
       concat-plugin
       concat-examples
       concat-graphics
       singletons
       units
       z3cat
     ])))

    splot
  ];
};

haskellFilterSource = paths: src: builtins.filterSource (path: type:
    let baseName = baseNameOf path; in
    !( type == "directory"
       && builtins.elem baseName ([".git" ".cabal-sandbox" "dist"] ++ paths))
    &&
    !( type == "unknown"
       || pkgs.stdenv.lib.hasSuffix ".hdevtools.sock" path
       || pkgs.stdenv.lib.hasSuffix ".sock" path
       || pkgs.stdenv.lib.hasSuffix ".hi" path
       || pkgs.stdenv.lib.hasSuffix ".hi-boot" path
       || pkgs.stdenv.lib.hasSuffix ".o" path
       || pkgs.stdenv.lib.hasSuffix ".o-boot" path
       || pkgs.stdenv.lib.hasSuffix ".dyn_o" path
       || pkgs.stdenv.lib.hasSuffix ".p_o" path))
  src;

##############################################################################
# Coq

myCoqPackages = coqPkgs: with pkgs; [
  ocaml
  ocamlPackages.camlp5_strict
  ocamlPackages.findlib
  ocamlPackages.menhir
  coq2html
  compcert
] ++ (with coqPkgs; [
  QuickChick
  autosubst
  bignums
  coq-ext-lib
  coq-haskell
  # coq-pipes
  coquelicot
  dpdgraph
  flocq
  heq
  interval
  mathcomp
  paco
]);

coq_8_7_override = pkgs.coq_8_7.override {
  ocamlPackages = pkgs.ocaml-ng.ocamlPackages_4_06;
  buildIde = false;
};

coq_HEAD = pkgs.stdenv.lib.overrideDerivation coq_8_7_override (attrs: rec {
  version = "8.8";
  name = "coq-${version}-pre";
  coq-version = "${builtins.substring 0 3 version}";
  src = ~/oss/coq;
  buildInputs = attrs.buildInputs
    ++ [ pkgs.ocaml-ng.ocamlPackages_4_06.num
         texFull pkgs.hevea pkgs.fig2dev pkgs.imagemagick_light ];
  preConfigure = ''
    configureFlagsArray=(
      -with-doc yes
      -coqide no
    )
  '';
});

coqPackages_HEAD = pkgs.mkCoqPackages coq_HEAD;

coqHEADEnv = pkgs.myEnvFun {
  name = "coqHEAD";
  buildInputs = [ coq_HEAD ]
    # ++ myCoqPackages coqPackages_HEAD
    # ++ (with coqPackages_HEAD; [
    #    CoLoR
    #    category-theory
    #    equations
    #    math-classes
    #    metalib
    #  ])
     ;
};

coq87Env = pkgs.myEnvFun {
  name = "coq87";
  buildInputs = [ pkgs.coq_8_7 ]
    ++ myCoqPackages pkgs.coqPackages_8_7 ++
    (with pkgs.coqPackages_8_7; [
       CoLoR
       category-theory
       equations
       math-classes
       metalib
     ])
    ++ (with pkgs.coqPackages_8_7.contribs; [
      # aac-tactics
      abp
      additions
      ails
      algebra
      # amm11262
      angles
      area-method
      # atbr
      automata
      axiomatic-abp
      # bdds
      bertrand
      buchberger
      canon-bdds
      # cantor
      cats-in-zfc
      ccs
      cfgv
      checker
      chinese
      circuits
      # classical-realizability
      coalgebras
      coinductive-examples
      # coinductive-reals
      concat
      constructive-geometry
      # containers
      # continuations
      coq-in-coq
      coqoban
      # corn
      # counting
      cours-de-coq
      ctltctl
      dblib
      demos
      dep-map
      # descente-infinie
      dictionaries
      distributed-reference-counting
      domain-theory
      # ergo
      euclidean-geometry
      euler-formula
      exact-real-arithmetic
      exceptions
      fairisle
      fermat4
      finger-tree
      firing-squad
      float
      founify
      free-groups
      fsets
      fssec-model
      functions-in-zfc
      fundamental-arithmetics
      gc
      generic-environments
      # goedel
      graph-basics
      # graphs
      group-theory
      groups
      hardware
      hedges
      # high-school-geometry
      higman-cf
      higman-nw
      higman-s
      historical-examples
      hoare-tut
      huffman
      icharate
      idxassoc
      ieee754
      int-map
      # intuitionistic-nuprl
      ipc
      izf
      jordan-curve-theorem
      # jprover
      karatsuba
      kildall
      lambda
      lambek
      lazy-pcf
      lc
      # legacy-field
      # legacy-ring
      # lemma-overloading
      lesniewski-mereology
      # lin-alg
      ltl
      # maple-mode
      markov
      # math-classes
      maths
      matrices
      micromega
      mini-compiler
      minic
      miniml
      mod-red
      multiplier
      mutual-exclusion
      # nfix
      # orb-stab
      otway-rees
      paco
      paradoxes
      param-pi
      pautomata
      persistent-union-find
      pi-calc
      pocklington
      # presburger
      prfx
      projective-geometry
      propcalc
      pts
      ptsatr
      # ptsf
      qarith
      qarith-stern-brocot
      quicksort-complexity
      railroad-crossing
      ramsey
      random
      # rational
      # recursive-definition
      reflexive-first-order
      regexp
      # relation-algebra
      # relation-extraction
      rem
      rsa
      ruler-compass-geometry
      schroeder
      search-trees
      # semantics
      shuffle
      # smc
      square-matrices
      # stalmarck
      streams
      # string
      subst
      sudoku
      sum-of-two-square
      tait
      tarski-geometry
      three-gap
      # topology
      tortoise-hare-algorithm
      traversable-fincontainer
      # tree-automata
      tree-diameter
      weak-up-to
      zchinese
      zf
      zfc
      zorns-lemma
      zsearch-trees
    ]);
};

coq86Env = pkgs.myEnvFun {
  name = "coq86";
  buildInputs = [ pkgs.coq_8_6 ]
    ++ myCoqPackages pkgs.coqPackages_8_6 ++
    (with pkgs.coqPackages_8_6; [
       category-theory
       equations
       ssreflect
     ])
    ++ (with pkgs.coqPackages_8_6.contribs; [
      # aac-tactics
      abp
      additions
      # ails
      algebra
      amm11262
      angles
      area-method
      # atbr
      automata
      axiomatic-abp
      # bdds
      # bertrand
      buchberger
      canon-bdds
      cantor
      cats-in-zfc
      ccs
      cfgv
      checker
      chinese
      circuits
      classical-realizability
      coalgebras
      coinductive-examples
      # coinductive-reals
      concat
      constructive-geometry
      # containers
      # continuations
      coq-in-coq
      coqoban
      # corn
      # counting
      cours-de-coq
      ctltctl
      dblib
      demos
      dep-map
      # descente-infinie
      dictionaries
      distributed-reference-counting
      domain-theory
      # ergo
      euclidean-geometry
      euler-formula
      exact-real-arithmetic
      exceptions
      fairisle
      # fermat4
      finger-tree
      firing-squad
      # float
      founify
      free-groups
      fsets
      fssec-model
      functions-in-zfc
      fundamental-arithmetics
      gc
      generic-environments
      # goedel
      graph-basics
      # graphs
      group-theory
      groups
      hardware
      hedges
      high-school-geometry
      higman-cf
      higman-nw
      higman-s
      historical-examples
      hoare-tut
      huffman
      icharate
      idxassoc
      ieee754
      int-map
      # intuitionistic-nuprl
      ipc
      izf
      jordan-curve-theorem
      # jprover
      karatsuba
      kildall
      lambda
      lambek
      lazy-pcf
      lc
      # legacy-field
      # legacy-ring
      # lemma-overloading
      lesniewski-mereology
      # lin-alg
      ltl
      # maple-mode
      # markov
      math-classes
      maths
      matrices
      micromega
      mini-compiler
      minic
      miniml
      mod-red
      multiplier
      mutual-exclusion
      # nfix
      # orb-stab
      otway-rees
      paco
      paradoxes
      param-pi
      pautomata
      persistent-union-find
      pi-calc
      pocklington
      # presburger
      prfx
      projective-geometry
      propcalc
      pts
      ptsatr
      # ptsf
      qarith
      # qarith-stern-brocot
      quicksort-complexity
      railroad-crossing
      ramsey
      random
      # rational
      # recursive-definition
      reflexive-first-order
      regexp
      # relation-algebra
      # relation-extraction
      rem
      rsa
      ruler-compass-geometry
      schroeder
      search-trees
      # semantics
      shuffle
      # smc
      square-matrices
      # stalmarck
      streams
      # string
      subst
      sudoku
      sum-of-two-square
      tait
      tarski-geometry
      three-gap
      # topology
      tortoise-hare-algorithm
      # traversable-fincontainer
      # tree-automata
      tree-diameter
      weak-up-to
      zchinese
      zf
      zfc
      zorns-lemma
      zsearch-trees
    ]);
};

coq85Env = pkgs.myEnvFun {
  name = "coq85";
  buildInputs = [ pkgs.coq_8_5 ]
    ++ myCoqPackages pkgs.coqPackages_8_5
    ++ (with pkgs.coqPackages_8_5.contribs; [
      # aac-tactics
      abp
      # additions
      # ails
      algebra
      amm11262
      angles
      area-method
      # atbr
      automata
      axiomatic-abp
      # bdds
      # bertrand
      # buchberger
      # canon-bdds
      cantor
      cats-in-zfc
      ccs
      cfgv
      checker
      # chinese
      circuits
      # classical-realizability
      coalgebras
      coinductive-examples
      # coinductive-reals
      concat
      constructive-geometry
      # containers
      # continuations
      # coq-in-coq
      coqoban
      # corn
      # counting
      cours-de-coq
      ctltctl
      dblib
      demos
      dep-map
      # descente-infinie
      dictionaries
      distributed-reference-counting
      domain-theory
      # ergo
      # euclidean-geometry
      euler-formula
      exact-real-arithmetic
      # exceptions
      fairisle
      # fermat4
      finger-tree
      # firing-squad
      # float
      # founify
      free-groups
      # fsets
      fssec-model
      functions-in-zfc
      fundamental-arithmetics
      gc
      generic-environments
      # goedel
      graph-basics
      # graphs
      group-theory
      groups
      # hardware
      hedges
      # high-school-geometry
      # higman-cf
      # higman-nw
      higman-s
      historical-examples
      hoare-tut
      # huffman
      icharate
      idxassoc
      # ieee754
      int-map
      # intuitionistic-nuprl
      # ipc
      izf
      jordan-curve-theorem
      # jprover
      karatsuba
      kildall
      lambda
      lambek
      lazy-pcf
      lc
      # legacy-field
      # legacy-ring
      # lemma-overloading
      lesniewski-mereology
      # lin-alg
      ltl
      # maple-mode
      # markov
      # math-classes
      maths
      matrices
      micromega
      mini-compiler
      # minic
      miniml
      mod-red
      # multiplier
      # mutual-exclusion
      # nfix
      # orb-stab
      otway-rees
      paco
      # paradoxes
      param-pi
      # pautomata
      persistent-union-find
      pi-calc
      pocklington
      # presburger
      prfx
      # projective-geometry
      propcalc
      # pts
      ptsatr
      # ptsf
      # qarith
      # qarith-stern-brocot
      # quicksort-complexity
      railroad-crossing
      ramsey
      random
      # rational
      # recursive-definition
      reflexive-first-order
      regexp
      # relation-algebra
      # relation-extraction
      rem
      rsa
      # ruler-compass-geometry
      schroeder
      # search-trees
      # semantics
      shuffle
      # smc
      # square-matrices
      # stalmarck
      streams
      # string
      subst
      # sudoku
      sum-of-two-square
      # tait
      tarski-geometry
      three-gap
      # topology
      tortoise-hare-algorithm
      # traversable-fincontainer
      # tree-automata
      tree-diameter
      weak-up-to
      # zchinese
      zf
      zfc
      zorns-lemma
      # zsearch-trees
    ]);
};

coqPackages_8_4 = pkgs.mkCoqPackages pkgs.coq_8_4;

coq84Env = pkgs.myEnvFun {
  name = "coq84";
  buildInputs = [ pkgs.coq_8_4 ];
};

##############################################################################
# Emacs

emacs = emacs26;

emacsFromUrl = pkgname: pkgsrc: pkgdeps: with pkgs; stdenv.mkDerivation rec {
  name = pkgname;
  src = pkgsrc;
  unpackCmd = ''
    test -f "${src}" && mkdir el && cp -p ${src} el/${pkgname}
  '';
  buildInputs = [ emacs ] ++ pkgdeps;
  buildPhase = ''
    ARGS=$(find ${pkgs.stdenv.lib.concatStrings
                  (builtins.map (arg: arg + "/share/emacs/site-lisp ") pkgdeps)} \
                 -type d -exec echo -L {} \;)
    ${emacs}/bin/emacs -Q -nw -L . $ARGS --batch -f batch-byte-compile *.el
  '';
  installPhase = ''
    mkdir -p $out/share/emacs/site-lisp
    install *.el* $out/share/emacs/site-lisp
  '';
  meta = {
    description = "Emacs file from the Internet";
    homepage = http://www.emacswiki.org;
    platforms = stdenv.lib.platforms.all;
  };
};

myEmacsPackages = super: with super; rec {
  org = with pkgs; stdenv.mkDerivation (rec {
    name = "emacs-org-${version}";
    version = "20160421";

    src = fetchgit {
      url = git://github.com/jwiegley/org-mode.git;
      rev = "db5257389231bd49e92e2bc66713ac71b0435eec";
      sha256 = "0v8i49c3yqfz7d92fx6paxw1ad565k918cricjg12zcl73r7rigk";
    };

    preInstall = ''
      perl -i -pe "s%/usr/share%$out%;" local.mk
    '';

    buildInputs = [ emacs texinfo perl which ];

    meta = {
      homepage = "https://elpa.gnu.org/packages/org.html";
      license = pkgs.stdenv.lib.licenses.free;
    };
  });

  ascii = emacsFromUrl "ascii.el" (pkgs.fetchurl {
    url = https://www.emacswiki.org/emacs/download/ascii.el;
    sha256 = "05fjsj5nmc05cmsi0qj914dqdwk8rll1d4dwhn0crw36p2ivql75";
  }) [];

  backup-each-save = emacsFromUrl "backup-each-save.el" (pkgs.fetchurl {
    url = https://www.emacswiki.org/emacs/download/backup-each-save.el;
    sha256 = "0b9vvi2m0fdv36wj8mvawl951gjmg3pypg08a8n6rzn3rwg0fwz7";
  }) [];

  browse-kill-ring-plus = emacsFromUrl "browse-kill-ring+.el" (pkgs.fetchurl {
    url = https://www.emacswiki.org/emacs/download/browse-kill-ring+.el;
    sha256 = "1s32f70lc1gnllqqfw8zqr5n743rf0yfifqljsl210vnb5zg4zkj";
  }) [browse-kill-ring];

  bytecomp-simplify = emacsFromUrl "bytecomp-simplify.el" (pkgs.fetchurl {
    url = https://download.tuxfamily.org/user42/bytecomp-simplify.el;
    sha256 = "13cg5nrh0zfyb8rymwlc1lj8mlns27nmj2p7jycl8krwln36g6jr";
  }) [];

  cldoc = emacsFromUrl "cldoc.el" (pkgs.fetchurl {
    url = http://homepage1.nifty.com/bmonkey/emacs/elisp/cldoc.el;
    sha256 = "0svv1k7fr4a1syplp0fdfn1as7am0d7g5z8hhl4qhmd5b0hl1pad";
  }) [];

  cmake-mode = emacsFromUrl "cmake-mode.el" (pkgs.fetchurl {
    url = https://raw.githubusercontent.com/Kitware/CMake/master/Auxiliary/cmake-mode.el;
    sha256 = "0nkyb5i8j7j064iaanvmjrb5lsz2ajf26hg32rrlxlqwfm768mp5";
  }) [];

  col-highlight = emacsFromUrl "col-highlight.el" (pkgs.fetchurl {
    url = https://www.emacswiki.org/emacs/download/col-highlight.el;
    sha256 = "0na8aimv5j66pzqi4hk2jw5kk00ki99zkxiykwcmjiy3h1r9311k";
  }) [ vline ];

  crosshairs = emacsFromUrl "crosshairs.el" (pkgs.fetchurl {
    url = https://www.emacswiki.org/emacs/download/crosshairs.el;
    sha256 = "0032v3ry043wzvbacm16liykc362pza1bc46x37b307bvbv12qlg";
  }) [ hl-line-plus col-highlight vline ];

  cursor-chg = emacsFromUrl "cursor-chg.el" (pkgs.fetchurl {
    url = https://www.emacswiki.org/emacs/download/cursor-chg.el;
    sha256 = "1zmwh0z4g6khb04lbgga263pqa51mfvs0wfj3y85j7b08f2lqnqn";
  }) [];

  dedicated = emacsFromUrl "dedicated.el" (pkgs.fetchurl {
    url = https://raw.githubusercontent.com/emacsmirror/dedicated/master/dedicated.el;
    sha256 = "03ky8hvj10q96w38qb9y0b5nqyp52nrq828570gx93rh1607zk8p";
  }) [];

  el-mock = emacsFromUrl "el-mock.el" (pkgs.fetchurl {
    url = https://www.emacswiki.org/emacs/download/el-mock.el;
    sha256 = "0afdsm26azl8n1kzhpaxy2hhk3whidsnsvc5sa9p9m5dgk5n5d7j";
  }) [];

  elisp-depend = emacsFromUrl "elisp-depend.el" (pkgs.fetchurl {
    url = https://www.emacswiki.org/emacs/download/elisp-depend.el;
    sha256 = "0khc3gacw27aw9pkfrnla9844lqbspgm0hrz7q0h5nr73d9pnc02";
  }) [];

  erc-highlight-nicknames = emacsFromUrl "erc-highlight-nicknames.el" (pkgs.fetchurl {
    url = https://www.emacswiki.org/emacs/download/erc-highlight-nicknames.el;
    sha256 = "01r184q86aha4gs55r2vy3rygq1qnxh1bj9qmlz97b2yh8y17m50";
  }) [];

  eval-expr = emacsFromUrl "eval-expr.el" (pkgs.fetchurl {
    url = http://www.splode.com/~friedman/software/emacs-lisp/src/eval-expr.el;
    sha256 = "1g55kzi7c7jcjkw5ajcdk2k6na3gdiyfj4lvrflapy03a1bgvkl1";
  }) [];

  fetchmail-mode = emacsFromUrl "fetchmail-mode.el" (pkgs.fetchurl {
    url = https://www.emacswiki.org/emacs/download/fetchmail-mode.el;
    sha256 = "19lqkc35kgzm07xjpb9nrcayg69qyijn159lak0mg45fhnybf4a6";
  }) [];

  gnus-alias = emacsFromUrl "gnus-alias.el" (pkgs.fetchurl {
    url = https://www.emacswiki.org/emacs/download/gnus-alias.el;
    sha256 = "16xbac5zdl6i0ny358mg36fgzcqyy4mqqdr2sd5sqs6s97vv02sw";
  }) [];

  goto-last-change = emacsFromUrl "goto-last-change.el" (pkgs.fetchurl {
    url = https://www.emacswiki.org/emacs/download/goto-last-change.el;
    sha256 = "0fpav3r1j1ff9iks38zg3p3v8m81p79imcqsdf0n2fciw4ib8x3i";
  }) [];

  highlight-cl = emacsFromUrl "highlight-cl.el" (pkgs.fetchurl {
    url = https://www.emacswiki.org/emacs/download/highlight-cl.el;
    sha256 = "0r3kzs2fsi3kl5gqmsv75dc7lgfl4imrrqhg09ij6kq1ri8gjxjw";
  }) [];

  highlight = emacsFromUrl "highlight.el" (pkgs.fetchurl {
    url = https://www.emacswiki.org/emacs/download/highlight.el;
    sha256 = "1f0lz7giv7f80hi4wvhjc688912pjrhwgm4fc16rqyk8rklywxp9";
  }) [];

  hl-line-plus = emacsFromUrl "hl-line+.el" (pkgs.fetchurl {
    url = "https://www.emacswiki.org/emacs/download/hl-line+.el";
    sha256 = "0crkmjah8i61z6c15sgn2cbpbj8xqfx0py1y84pxkcjh1cj7hx7q";
  }) [];

  initsplit = emacsFromUrl "initsplit.el" (pkgs.fetchFromGitHub {
    owner = "jwiegley";
    repo = "initsplit";
    rev = "e488e8f95661a8daf9c66241ce58bb6650d91751";
     sha256 = "1qvkxpxdv0n9qlzigvi25iw485824pgbpb10lwhh8bs2074dvrgq";
  }) [];

  key-chord = emacsFromUrl "key-chord.el" (pkgs.fetchurl {
    url = https://www.emacswiki.org/emacs/download/key-chord.el;
    sha256 = "03m44pqggfrd53nh9dvpdjgm0rvca34qxmd30hr33hzprzjambxg";
  }) [];

  llvm-mode = emacsFromUrl "llvm-mode.el" (pkgs.fetchurl {
    url = https://raw.githubusercontent.com/Microsoft/llvm/master/utils/emacs/llvm-mode.el;
    sha256 = "0v4jq3xj0dyakhy8v9r03ck2gahjzgr656l3qs2hy200sfbmzg6j";
  }) [];

  message-x = emacsFromUrl "message-x.el" (pkgs.fetchurl {
    url = https://www.emacswiki.org/emacs/download/message-x.el;
    sha256 = "05ic97plsysh4nqwdrsl5m9f24m11w24bahj8bxzfdawfima2bkf";
  }) [];

  mic-paren = emacsFromUrl "mic-paren.el" (pkgs.fetchurl {
    url = https://www.emacswiki.org/emacs/download/mic-paren.el;
    sha256 = "1ibim60fx0srmvchwbb2s04dmcc7mv7zyg1vqavas24ya2gmixc5";
  }) [];

  mu = emacsFromUrl "mudel" (pkgs.fetchurl {
    url = https://www.emacswiki.org/emacs/download/mudel.el;
    sha256 = "0z6giw5i3qflxll29k6nbmy71nkadbjjkh465fcqbs2v22643fr9";
  }) [];

  nf-procmail-mode = emacsFromUrl "nf-procmail-mode.el" (pkgs.fetchurl {
    url = http://www.splode.com/~friedman/software/emacs-lisp/src/nf-procmail-mode.el;
    sha256 = "1a7byym62g2rjh2grrqh1g51p05cibp6k83581xyn7fai5f4hxx3";
  }) [];

  org-parser = emacsFromUrl "org-parser.el" (pkgs.fetchurl {
    url = https://bitbucket.org/zck/org-parser.el/raw/105050acee08cbb7159ca2e277a597af023a4e57/org-parser.el;
    sha256 = "0x3ycisxj1sfi94ra5d4dzcdyf5pfzzznpay75mzc045nd3w3xgz";
  }) [ dash ht ];

  po-mode = emacsFromUrl "po-mode.el" (pkgs.fetchurl {
    url = http://git.savannah.gnu.org/cgit/gettext.git/plain/gettext-tools/misc/po-mode.el;
    sha256 = "0nxh5hzv60mq9k3x750l7n06drgpn8wavklw7m81x61rmhyjm54w";
  }) [];

  popup-pos-tip = emacsFromUrl "popup-pos-tip.el" (pkgs.fetchurl {
    url = https://www.emacswiki.org/emacs/download/popup-pos-tip.el;
    sha256 = "0dhyzfsl01y61m53iz38a1vcvclr98wamsh0nishw0by1dnlb17x";
  }) [ popup pos-tip ];

  popup-ruler = emacsFromUrl "popup-ruler.el" (pkgs.fetchurl {
    url = https://www.emacswiki.org/emacs/download/popup-ruler.el;
    sha256 = "0fszl969savcibmksfkanaq11d047xbnrfxd84shf9z9z2i3dr43";
  }) [];

  pos-tip = emacsFromUrl "pos-tip.el" (pkgs.fetchurl {
    url = https://www.emacswiki.org/emacs/download/pos-tip.el;
    sha256 = "1c14693h903mbgapks9zgxl6l3pkipc5r7n4ik0szjl4hsghc4z3";
  }) [];

  pp-c-l = emacsFromUrl "pp-c-l.el" (pkgs.fetchurl {
    url = https://www.emacswiki.org/emacs/download/pp-c-l.el;
    sha256 = "03mhd8lja71163jg6fj4d4hy2dwb1c5j46sn9yq6m9wz413a4pmd";
  }) [];

  rs-gnus-summary = emacsFromUrl "rs-gnus-summary.el" (pkgs.fetchurl {
    url = https://raw.githubusercontent.com/jwiegley/dot-emacs/master/site-lisp/rs-gnus-summary.el;
    sha256 = "1wh7nbx83cmsx9wmia8c7kl168lc2iv4l4x4bxz1y4417l0sa095";
  }) [];

  supercite = emacsFromUrl "supercite.el" (pkgs.fetchurl {
    url = https://raw.githubusercontent.com/jwiegley/dot-emacs/master/site-lisp/supercite.el;
    sha256 = "0hq1s543qqaalzgjzlnzf9nh4v4xq9pd0cyzq7y4k86nm0phr1f6";
  }) [];

  tablegen-mode = emacsFromUrl "tablegen-mode.el" (pkgs.fetchurl {
    url = https://raw.githubusercontent.com/llvm-mirror/llvm/master/utils/emacs/tablegen-mode.el;
    sha256 = "0vinzlin17ghp2xg0mzxw58jp08fg0jxmq228rd6n017j48b89ck";
  }) [];

  tidy = emacsFromUrl "tidy.el" (pkgs.fetchurl {
    url = https://www.emacswiki.org/emacs/download/tidy.el;
    sha256 = "0psci55a3angwv45z9i8wz8jw634rxg1xawkrb57m878zcxxddwa";
  }) [];

  vline = emacsFromUrl "vline.el" (pkgs.fetchurl {
    url = https://www.emacswiki.org/emacs/download/vline.el;
    sha256 = "1ys6928fgk8mswa4gv10cxggir8acck27g78cw1z3pdz5gakbgnj";
  }) [];

  xml-rpc = emacsFromUrl "xml-rpc.el" (pkgs.fetchurl {
    url = https://www.emacswiki.org/emacs/download/xml-rpc.el;
    sha256 = "0a9n3mj39icfkbsqpcpg9q1d5yz6h3jhay70ngiwsa4264ha4ipa";
  }) [];

  xray = emacsFromUrl "xray.el" (pkgs.fetchurl {
    url = https://www.emacswiki.org/emacs/download/xray.el;
    sha256 = "12pzik5plywil0rz95rqb5qdqwdawkbwhmqab346yizhlp6i4fq6";
  }) [];

  yaoddmuse = emacsFromUrl "yaoddmuse.el" (pkgs.fetchurl {
    url = https://www.emacswiki.org/emacs/download/yaoddmuse.el;
    sha256 = "0vlllq3xmnlni0ws226pqxj68nshclbl5rgqv6y11i3yvzgiazr6";
  }) [];

  sunrise-commander = emacsFromUrl "sunrise-commander" (pkgs.fetchgit {
    url = https://github.com/escherdragon/sunrise-commander.git;
    rev = "855ed752affd98ee49cd13c3be1c2fa68142fbb8";
    sha256 = "1zaa7gqrx2pal9habza75s2l8azl9bn7vfi1n0kylbaa48n4wrar";
  }) [];

  python-mode = melpaBuild {
    pname = "python-mode";
    version = "20171214.1406";
    src = pkgs.fetchFromGitLab {
      owner = "python-mode-devs";
      repo = "python-mode";
      rev = "65a55eadfc6fe9030a8065ba3b8839473622879c";
      sha256 = "0dn7r88qzn2yjagjqz0xi0fbn8qvgk4n6yr2d6lb6nd960ck0gk4";
    };
    recipeFile = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/milkypostman/melpa/82861e1ab114451af5e1106d53195afd3605448a/recipes/python-mode";
      sha256 = "1m7c6c97xpr5mrbyzhcl2cy7ykdz5yjj90mrakd4lknnsbcq205k";
      name = "python-mode";
    };
    packageRequires = [];
    meta = {
      homepage = "https://melpa.org/#/python-mode";
      license = stdenv.lib.licenses.free;
    };
  };

  cmake-font-lock = emacsFromUrl "cmake-font-lock" (pkgs.fetchgit {
    url = git://github.com/Lindydancer/cmake-font-lock.git;
    rev = "8be491b4b13338078e524e2fe6213c93e18a101e";
    sha256 = "0h96c670gki6csqfrhlnjxkpzx0m92l6pcsdhx93l3qbh23imcmm";
  }) [];

  asoc = emacsFromUrl "word-count-mode" (pkgs.fetchgit {
    url = git://github.com/troyp/asoc.el.git;
    rev = "4a3309a9f250656da6f4a9d34feedf4f5666b17a";
    sha256 = "1ls4j4fqx33wd2y2fwdh6bagpp04zqhc35p2wy77axmkz9lv5qpv";
  }) [];

  bookmark-plus = emacsFromUrl "bookmark-plus" (pkgs.fetchgit {
    url = git://github.com/emacsmirror/bookmark-plus.git;
    rev = "d2e0baa9fa60d08a956e1db679d81a64181f9be6";
    sha256 = "1b4qvzbwai5rjgrba4z55a2k73m0hqv2nknzi32jsrns3gsvlry4";
  }) [];

  doxymacs = with pkgs; stdenv.mkDerivation (rec {
    name = "emacs-doxymacs-${version}";
    version = "2017-12-10";

    src = fetchgit {
      url = git://git.code.sf.net/p/doxymacs/code.git;
      rev = "914d5cc98129d224e15bd68c39ec8836830b08a2";
      sha256 = "1xqjga5pphcfgqzj9lxfkm50sc1qag1idf54lpa23z81wrxq9dy3";
    };

    buildInputs = [ emacs texinfo perl which ];

    meta = {
      description = "Doxymacs is Doxygen + {X}Emacs";
      longDescription = ''
        The purpose of the doxymacs project is to create a LISP package that
        will make using Doxygen from within {X}Emacs easier.
      '';
      homepage = http://doxymacs.sourceforge.net/;
      license = stdenv.lib.licenses.gpl2Plus;
      platforms = stdenv.lib.platforms.unix;
    };
  });

  erc-yank = emacsFromUrl "erc-yank" (pkgs.fetchgit {
    url = git://github.com/jwiegley/erc-yank.git;
    rev = "d4dfcf3a0386c3a4a28f8d4de4ae664f253e817c";
    sha256 = "0sa1qx549wlswa3xnmmpb8a3imny0q8mfvqw8iki5l3sh60rfax9";
  }) [];

  fence-edit = emacsFromUrl "fence-edit" (pkgs.fetchgit {
    url = git://github.com/aaronbieber/fence-edit.el.git;
    rev = "93ebdc31d550b0944f6e2d5e6d5e0983d757278e";
    sha256 = "0l07swd1qzn03l22kzl7cl22r3bikfw9i4hsq6xf4kb68zkikfk6";
  }) [];

  git-modes = emacsFromUrl "git-modes" (pkgs.fetchgit {
    url = git://github.com/magit/git-modes.git;
    rev = "9f18eca514d242816a4969e86c4cfd2cf4dfe401";
    sha256 = "0k380f9ff15gg724c2spfd9qml97k24bhn3h9ipv1c7rn9qvhdhc";
  }) [];

  git-undo = emacsFromUrl "git-undo" (pkgs.fetchgit {
    url = git://github.com/jwiegley/git-undo-el.git;
    rev = "852824ab7cb30f5a57361d3e567d78e7864655b1";
    sha256 = "1pc8aaax5qmbl6khb1ixfmr4dhb5dad4qwpd902liqi2fpiy64gl";
  }) [];

  gnus-harvest = emacsFromUrl "gnus-harvest" (pkgs.fetchgit {
    url = git://github.com/jwiegley/gnus-harvest.git;
    rev = "181ac4a1c2d2b697dd90a1c615bc511e0f196f5d";
    sha256 = "1ilwk8yc2834mxfc37l2qrvljbzjgvcb8ricnd8sa52mvql9dh3r";
  }) [];

  indent-shift = emacsFromUrl "indent-shift" (pkgs.fetchgit {
    url = git://github.com/ryuslash/indent-shift.git;
    rev = "292993d61d88d80c4a4429aa97856f612e0402b2";
    sha256 = "13shcwpx52cgbh68zqw4yzxccdds532mmkffiz24jc34aridax5z";
  }) [];

  info-lookmore = emacsFromUrl "info-lookmore" (pkgs.fetchgit {
    url = git://github.com/emacsmirror/info-lookmore.git;
    rev = "5e2e62feea2b5149a82365be5580f9e328dd36cc";
    sha256 = "1gfsblgwxszmnx1pf29czvik92ywprvryb57g89zwf31486gjb21";
  }) [];

  makefile-runner = emacsFromUrl "makefile-runner" (pkgs.fetchgit {
    url = git://github.com/danamlund/emacs-makefile-runner.git;
    rev = "300ba3820aa0536ef4622f78d67ff1730f7e8521";
    sha256 = "14ncli24x6g25krgjhx46bp1hc0x2hgavcl5ssgj2k2mn8zimkmf";
  }) [];

  moccur-edit = emacsFromUrl "moccur-edit" (pkgs.fetchgit {
    url = git://github.com/myuhe/moccur-edit.el.git;
    rev = "026f5dd4159bd1b68c430ab385757157ba01a361";
    sha256 = "1qikrqs69zqzjpz8bchjrg96bzhj7cbcwkvgsrrx113p420k90zx";
  }) [ color-moccur ];

  mudel = emacsFromUrl "mudel.el" (pkgs.fetchurl {
    url = https://www.emacswiki.org/emacs/download/mudel.el;
    sha256 = "0z6giw5i3qflxll29k6nbmy71nkadbjjkh465fcqbs2v22643fr9";
  }) [];

  org-opml = emacsFromUrl "org-opml" (pkgs.fetchgit {
    url = git://github.com/edavis/org-opml.git;
    rev = "d9019be8653a4406eacf15a06afb8b162d2625a6";
    sha256 = "1nj0ccjyj4yn5b77m9p1asgx41fpgpypsxfnqwhqwgxywhap00w1";
  }) [];

  orgaggregate = emacsFromUrl "orgaggregate" (pkgs.fetchgit {
    url = git://github.com/tbanel/orgaggregate.git;
    rev = "a33a02ba70639cadaef5f6ea028c2fe73f76cf14";
    sha256 = "0zh8n8jb479ilmz88kj0q5wx8a9zqkfqds0rr8jbk2rqmj6j72v3";
  }) [];

  orgit = emacsFromUrl "orgit" (pkgs.fetchgit {
    url = git://github.com/magit/orgit.git;
    rev = "022687eb02f0bf0d0151d0ad917b165bfef2d663";
    sha256 = "1cddyns82a06ydbw8rhxzghkjav5vxmmc671pdnai50mql3cx9kf";
  }) [ dash magit with-editor git-commit pkgs.git ];

  ox-texinfo-plus = emacsFromUrl "ox-texinfo-plus" (pkgs.fetchgit {
    url = git://github.com/tarsius/ox-texinfo-plus.git;
    rev = "d3c57f2d60283aa1667d93785fd66765c3769189";
    sha256 = "13brkf7gqcyg7imb92naa8205m0c3wvrv2pssbmbzw9gy7yi421q";
  }) [];

  per-window-point = emacsFromUrl "per-window-point" (pkgs.fetchgit {
    url = git://github.com/alpaker/Per-Window-Point.git;
    rev = "bd780d0e76814280bc055560e04bc6e606afa69a";
    sha256 = "1kkm957a89fszbikjm1w6dwwnklxn2vwzk3jk9bqzhkpacsqcr16";
  }) [];

  peval = emacsFromUrl "peval" (pkgs.fetchgit {
    url = git://github.com/Wilfred/peval.git;
    rev = "410b5e3dee08b7c3356feb3bda3f07589af2dcd6";
    sha256 = "1dz83c139qb3mp6fh8nd5pvqq1ahkc837xajhqkd4x2yi43sf9l4";
  }) [ dash ];

  proof-general = with pkgs;
    let enableDoc = false;
        texinfo = texinfo4 ;
        texLive = texlive.combine {
          inherit (texlive) scheme-basic cm-super ec;
        }; in
    stdenv.mkDerivation (rec {
    name = "emacs-proof-general-${version}";
    version = "2017-12-10";

    src = fetchFromGitHub {
      owner = "ProofGeneral";
      repo = "PG";
      rev = "08f4a234a669a2398be37c7fdab41ee9d3dcd6cd";
      sha256 = "161h1kfi32fpf8b1dq6xbf1ls74220b6cychbmcvixbvjqx522bd";
    };

    buildInputs = [ emacs texinfo perl which ]
      ++ stdenv.lib.optional enableDoc texLive;

    prePatch =
      '' sed -i "Makefile" \
             -e "s|^\(\(DEST_\)\?PREFIX\)=.*$|\1=$out|g ; \
                 s|/sbin/install-info|install-info|g"
         sed -i '94d' doc/PG-adapting.texi
         sed -i '96d' doc/ProofGeneral.texi
      '';

    preBuild = ''
      make clean;
    '';

    installPhase =
      if enableDoc
      then ''
        cp -v "${automake}/share/"automake-*/texinfo.tex doc
        make install install-doc
      ''
      else "make install";

    meta = {
      description = "Proof General, an Emacs front-end for proof assistants";
      longDescription = ''
        Proof General is a generic front-end for proof assistants (also known as
        interactive theorem provers), based on the customizable text editor Emacs.
      '';
      homepage = http://proofgeneral.inf.ed.ac.uk;
      license = stdenv.lib.licenses.gpl2Plus;
      platforms = stdenv.lib.platforms.unix;
    };
  });

  purpose = emacsFromUrl "purpose" (pkgs.fetchgit {
    url = git://github.com/bmag/emacs-purpose.git;
    rev = "2655bbe3399f00d3297ded58f92e7be22876148a";
    sha256 = "1yn9ha7qly4fw70ifdlvvi2hm3c6svkpy9q9nqxgzbg8j51gqzql";
  }) [ imenu-list ];

  stopwatch = emacsFromUrl "stopwatch" (pkgs.fetchgit {
    url = git://github.com/lalopmak/stopwatch.git;
    rev = "107bdbafdc11128112169b41cf001384a203408a";
    sha256 = "05k16z4w552rspdngjs5c74ng010zmdiwqjn0iahk05l5apx6wd8";
  }) [];

  word-count-mode = emacsFromUrl "word-count-mode" (pkgs.fetchgit {
    url = git://github.com/tomaszskutnik/word-count-mode.git;
    rev = "6267c98e0d9a3951e667da9bace5aaf5033f4906";
    sha256 = "1pvwy6dm6pwm0d8dd4l1d5rqk31w39h5n4wxqmq2ipwnxrlxp0nh";
  }) [];

  counsel-projectile = callPackage ({ counsel, fetchFromGitHub, fetchurl, lib, melpaBuild, projectile }:
  melpaBuild {
      pname = "counsel-projectile";
      version = "20171201.1224";
      src = fetchFromGitHub {
        owner = "ericdanan";
        repo = "counsel-projectile";
        rev = "162cdc2655c58a75bb51e939f3688b1a4dd7632a";
        sha256 = "1vncznis89hqrg8yb26d0sxwdjp5c32p1ynwg5vni55cxc5cznv3";
      };
      recipeFile = fetchurl {
        url = "https://raw.githubusercontent.com/milkypostman/melpa/389f16f886a385b02f466540f042a16eea8ba792/recipes/counsel-projectile";
        sha256 = "1gshphxaa902kq878rnizn3k1zycakwqkciz92z3xxb3bdyy0hnl";
        name = "counsel-projectile";
      };
      packageRequires = [ counsel projectile ];
      meta = {
        homepage = "https://melpa.org/#/counsel-projectile";
        license = lib.licenses.free;
      };
    }) {};
};

emacs26PackagesNg = pkgs.emacsPackagesNgGen emacs26;

emacsHEAD = with pkgs; pkgs.stdenv.lib.overrideDerivation
  (pkgs.emacs25.override { srcRepo = true; }) (attrs: rec {
  name = "emacs-${version}${versionModifier}";
  version = "27.0";
  versionModifier = ".50";

  appName = "ERC";
  bundleName = "nextstep/ERC.app";
  iconFile = ~/src/nix/emacs/Chat.icns;

  buildInputs = pkgs.emacs25.buildInputs ++ [ git ];

  patches = lib.optional stdenv.isDarwin ./emacs/at-fdcwd.patch;

  CFLAGS = "-O0 -g3";

  configureFlags = [ "--with-modules" ] ++
   [ "--with-ns" "--disable-ns-self-contained"
     "--enable-checking=yes,glyphs"
     "--enable-check-lisp-object-type" ];

  src = builtins.filterSource (path: type:
      type != "directory" || baseNameOf path != ".git")
    ~/.emacs.d/master;

  postPatch = ''
    sed -i 's|/usr/share/locale|${gettext}/share/locale|g' \
      lisp/international/mule-cmds.el
    sed -i 's|nextstep/Emacs\.app|${bundleName}|' configure.ac
    sed -i 's|>Emacs<|>${appName}<|' nextstep/templates/Info.plist.in
    sed -i 's|Emacs\.app|${appName}.app|' nextstep/templates/Info.plist.in
    sed -i 's|org\.gnu\.Emacs|org.gnu.${appName}|' nextstep/templates/Info.plist.in
    sed -i 's|Emacs @version@|${appName} @version@|' nextstep/templates/Info.plist.in
    sed -i 's|EmacsApp|${appName}App|' nextstep/templates/Info.plist.in
    if [ -n "${iconFile}" ]; then
      sed -i 's|Emacs\.icns|${appName}.icns|' nextstep/templates/Info.plist.in
    fi
    sed -i 's|Name=Emacs|Name=${appName}|' nextstep/templates/Emacs.desktop.in
    sed -i 's|Emacs\.app|${appName}.app|' nextstep/templates/Emacs.desktop.in
    sed -i 's|"Emacs|"${appName}|' nextstep/templates/InfoPlist.strings.in
    rm -fr .git
    sh autogen.sh
  '';

  postInstall = ''
    mkdir -p $out/share/emacs/site-lisp
    cp ${./emacs/site-start.el} $out/share/emacs/site-lisp/site-start.el
    $out/bin/emacs --batch -f batch-byte-compile $out/share/emacs/site-lisp/site-start.el

    rm -rf $out/var
    rm -rf $out/share/emacs/${version}/site-lisp

    for srcdir in src lisp lwlib ; do
      dstdir=$out/share/emacs/${version}/$srcdir
      mkdir -p $dstdir
      find $srcdir -name "*.[chm]" -exec cp {} $dstdir \;
      cp $srcdir/TAGS $dstdir
      echo '((nil . ((tags-file-name . "TAGS"))))' > $dstdir/.dir-locals.el
    done

    mkdir -p $out/Applications
    if [ "${appName}" != "Emacs" ]; then
        mv ${bundleName}/Contents/MacOS/Emacs ${bundleName}/Contents/MacOS/${appName}
    fi
    if [ -n "${iconFile}" ]; then
      cp "${iconFile}" ${bundleName}/Contents/Resources/${appName}.icns
    fi
    mv ${bundleName} $out/Applications
  '';
});

emacsHEADEnv = pkgs.myEnvFun {
  name = "emacsHEAD";
  buildInputs = with pkgs.emacsPackagesNgGen emacsHEAD; [
    emacsHEAD
  ];
};

emacs26 = with pkgs; pkgs.stdenv.lib.overrideDerivation
  (pkgs.emacs25.override { srcRepo = true; }) (attrs: rec {
  name = "emacs-${version}${versionModifier}";
  version = "26.0";
  versionModifier = ".90";

  buildInputs = pkgs.emacs25.buildInputs ++ [ git ];

  patches = lib.optional stdenv.isDarwin ./emacs/at-fdcwd.patch;

  CFLAGS = "-Ofast -momit-leaf-frame-pointer";

  src = builtins.filterSource (path: type:
      type != "directory" || baseNameOf path != ".git")
    ~/.emacs.d/release;

  postPatch = ''
    rm -fr .git
  '';

  postInstall = ''
    mkdir -p $out/share/emacs/site-lisp
    cp ${./emacs/site-start.el} $out/share/emacs/site-lisp/site-start.el
    $out/bin/emacs --batch -f batch-byte-compile $out/share/emacs/site-lisp/site-start.el

    rm -rf $out/var
    rm -rf $out/share/emacs/${version}/site-lisp

    for srcdir in src lisp lwlib ; do
      dstdir=$out/share/emacs/${version}/$srcdir
      mkdir -p $dstdir
      find $srcdir -name "*.[chm]" -exec cp {} $dstdir \;
      cp $srcdir/TAGS $dstdir
      echo '((nil . ((tags-file-name . "TAGS"))))' > $dstdir/.dir-locals.el
    done
  '' + lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    mv nextstep/Emacs.app $out/Applications
  '';
});

emacs26Env = pkgs.myEnvFun {
  name = "emacs26";
  buildInputs = with emacs26PackagesNg; [ emacs26 ghc-mod ];
};

emacs26FullEnv = pkgs.buildEnv {
  name = "emacs26full";
  paths = [
   (let customEmacsPackages =
      emacs26PackagesNg.overrideScope (super: self: {
        emacs = emacs26;
      } // myEmacsPackages emacs26PackagesNg);
    in customEmacsPackages.emacsWithPackages (super: with super; [
    ace-link
    ace-window
    agda2-mode
    aggressive-indent
    alert
    anaphora
    apiwrap
    ascii
    asoc
    async
    auctex
    auth-password-store
    auto-compile
    auto-yasnippet
    avy
    avy-zap
    back-button
    backup-each-save
    beacon
    biblio
    bm
    bookmark-plus
    browse-at-remote
    browse-kill-ring
    browse-kill-ring-plus
    button-lock
    bytecomp-simplify
    calfw
    change-inner
    chess
    circe
    cldoc
    clipmon
    cmake-font-lock
    cmake-mode
    col-highlight
    color-moccur
    command-log-mode
    company
    company-auctex
    company-coq
    company-ghc
    company-math
    company-quickhelp
    copy-as-format
    counsel
    counsel-gtags
    counsel-projectile
    crosshairs
    crux
    csv-mode
    ctable
    cursor-chg
    dash # dash-el
    dash-at-point
    debbugs
    dedicated
    deferred
    deft
    diff-hl
    difflib
    diffview
    diminish
    dired-hacks-utils
    dired-ranger
    dired-toggle
    discover
    discover-my-major
    docker
    docker-compose-mode
    docker-tramp
    dockerfile-mode
    doxymacs
    dumb-jump
    easy-kill
    ebdb
    edit-indirect
    el-mock
    elisp-depend
    elisp-docstring-mode
    elisp-refs
    elisp-slime-nav
    elmacro
    emojify
    enh-ruby-mode
    epc
    epl
    erc-highlight-nicknames
    erc-yank
    erefactor
    esh-buf-stack
    esh-help
    eshell-autojump
    eshell-bookmark
    eshell-up
    eshell-z
    esxml
    eval-expr
    eval-in-repl
    evil
    expand-region
    eyebrowse
    f
    fancy-narrow
    fence-edit
    flycheck
    flycheck-haskell
    flycheck-hdevtools
    flycheck-package
    fn
    focus
    font-lock-studio
    free-keys
    fringe-helper
    fullframe
    fuzzy
    ggtags
    gh
    ghc
    ghub
    ghub-plus
    git-link
    git-modes
    git-timemachine
    git-undo
    github-pullrequest
    gitpatch
    gnus-alias
    gnus-harvest
    google-this
    goto-last-change
    graphviz-dot-mode
    haskell-mode
    helm
    helm-bibtex
    helm-dash
    helm-descbinds
    helm-describe-modes
    helm-firefox
    helm-google
    helm-navi
    helm-pass
    helpful
    highlight
    highlight-cl
    highlight-defined
    highlight-numbers
    hl-line-plus
    ht
    hydra
    hyperbole
    iedit
    iflipb
    imenu-list
    indent-shift
    inf-ruby
    info-lookmore
    initsplit
    ipcalc
    ivy
    ivy-hydra
    ivy-pass
    ivy-rich
    jq-mode
    js2-mode
    js3-mode
    json-mode
    json-reformat
    json-snatcher
    key-chord
    know-your-http-well
    kv
    ledger-mode
    lentic
    lispy
    list-utils
    llvm-mode
    logito
    loop
    lsp-haskell
    lsp-mode
    lua-mode
    lusty-explorer
    m-buffer
    macrostep
    magit
    magit-imerge
    magithub
    makefile-runner
    makey
    malyon
    markdown-mode
    markdown-preview-mode
    marshal
    math-symbol-lists
    mc-extras
    mediawiki
    memory-usage
    message-x
    mic-paren
    minimap
    moccur-edit
    monitor
    mudel
    multi-compile
    multi-term
    multifiles
    multiple-cursors
    muse
    names
    navi-mode
    nf-procmail-mode
    nginx-mode
    nix-buffer
    nix-mode
    noflet
    nov
    oauth2
    ob-restclient
    olivetti
    org
    org-bookmark-heading
    orgit
    org-opml
    # jww (2017-12-15): This fails to byte-compile during build, although it
    # does byte-compile if you load it first.
    # org-parser
    org-ref
    org-super-agenda
    org-web-tools
    orgaggregate
    origami
    outorg
    outshine
    ov
    ox-texinfo-plus
    package-lint
    packed
    pandoc-mode
    paradox
    paredit
    parent-mode
    parinfer
    parsebib
    parsec
    parsec
    pass
    password-store
    pcache
    pcre2el
    pdf-tools
    per-window-point
    persistent-scratch
    peval
    pfuture
    phi-search
    phi-search-mc
    pkg-info
    po-mode
    popup
    popup-pos-tip
    popup-ruler
    popwin
    pos-tip
    pp-c-l
    prodigy
    projectile
    proof-general
    purpose
    python-mode
    rainbow-delimiters
    rainbow-mode
    redshank
    regex-tool
    repl-toggle
    request
    restclient
    reveal-in-osx-finder
    rich-minority
    riscv-mode
    rs-gnus-summary
    s
    selected
    shackle
    shift-number
    slime
    smart-jump
    smart-mode-line
    smart-newline
    smartparens
    smartscan
    smex
    sort-words
    sos
    spinner
    springboard
    sql-indent
    stopwatch
    string-edit
    string-inflection
    super-save
    supercite
    sunrise-commander
    swiper
    tablegen-mode
    tablist
    tagedit
    tidy
    transpose-mark
    treemacs
    tuareg
    typo
    undo-tree
    use-package
    uuidgen # uuidgen-el
    vdiff
    vimish-fold
    visual-fill-column
    visual-regexp
    visual-regexp-steroids
    vline
    w3m # emacs-w3m
    web
    web-mode
    web-server
    websocket
    wgrep
    which-key
    whitespace-cleanup-mode
    with-editor
    word-count-mode
    worf
    ws-butler
    xml-rpc
    xray
    yaml-mode
    yaoddmuse
    yasnippet
    z3-mode
    zencoding-mode
    zoom
    zoutline
    ztree
  ])) ];
};

emacs26debug = pkgs.stdenv.lib.overrideDerivation emacs26 (attrs: rec {
  name = "emacs-26.0.90-debug";
  doCheck = true;
  CFLAGS = "-O0 -g3";
  configureFlags = [ "--with-modules" ] ++
   [ "--with-ns" "--disable-ns-self-contained"
     "--enable-checking=yes,glyphs"
     "--enable-check-lisp-object-type" ];
});

emacs26DebugEnv = pkgs.myEnvFun {
  name = "emacs26debug";
  buildInputs = with pkgs.emacsPackagesNgGen emacs26debug; [
    emacs26debug
  ];
};

emacs25Env = pkgs.myEnvFun {
  name = "emacs25";
  buildInputs = with pkgs.emacsPackagesNgGen pkgs.emacs25; [ emacs ];
};

##############################################################################
# Ledger

ledger_HEAD = pkgs.callPackage ~/src/ledger {};

boost_with_python3 = pkgs.boost160.override {
  python = pkgs.python3;
};

ledger_HEAD_python3 = pkgs.callPackage ~/src/ledger {
  boost = pkgs.boost_with_python3;
};

ledgerPy3Env = pkgs.myEnvFun {
  name = "ledger-py3";
  buildInputs = with pkgs; [
    cmake boost_with_python3 gmp mpfr libedit python texinfo gnused ninja
    clang doxygen
  ];
};

ledgerPy2Env = pkgs.myEnvFun {
  name = "ledger-py2";
  buildInputs = with pkgs; [
    cmake boost gmp mpfr libedit python texinfo gnused ninja clang doxygen
  ];
};

##############################################################################
# System

backblaze-b2 = pkgs.callPackage ./backblaze.nix {};

johnw-home = with pkgs; stdenv.mkDerivation {
  name = "johnw-home";

  src = builtins.filterSource (path: type:
      type != "directory" || baseNameOf path != ".git")
    ~/src/home;

  buildInputs = [];

  installPhase = ''
    mkdir -p $out/etc
    cp -pR etc/* $out/etc

    mkdir -p $out/dot-files
    cp -pR dot-files/* $out/dot-files

    mkdir -p $out/Library
    cp -pR Library/* $out/Library
  '';

  meta = with stdenv.lib; {
    description = "John Wiegley's various scripts";
    homepage = https://github.com/jwiegley;
    license = licenses.mit;
    maintainers = with maintainers; [ jwiegley ];
    platforms = platforms.darwin;
  };
};

johnw-scripts = with pkgs; stdenv.mkDerivation {
  name = "johnw-scripts";

  src = builtins.filterSource (path: type:
      type != "directory" || baseNameOf path != ".git")
    ~/src/scripts;

  buildInputs = [];

  installPhase = ''
    mkdir -p $out/bin
    find . -maxdepth 1 \( -type f -o -type l \) -executable \
        -exec cp -pL {} $out/bin \;
  '';

  meta = with stdenv.lib; {
    description = "John Wiegley's various scripts";
    homepage = https://github.com/jwiegley;
    license = licenses.mit;
    maintainers = with maintainers; [ jwiegley ];
    platforms = platforms.darwin;
  };
};

git-scripts = with pkgs; stdenv.mkDerivation {
  name = "git-scripts";

  src = builtins.filterSource (path: type:
      type != "directory" || baseNameOf path != ".git")
    ~/src/git-scripts;

  buildInputs = [];

  installPhase = ''
    mkdir -p $out/bin
    find . -maxdepth 1 \( -type f -o -type l \) -executable \
        -exec cp -pL {} $out/bin \;
  '';

  meta = with stdenv.lib; {
    description = "John Wiegley's various scripts";
    homepage = https://github.com/jwiegley;
    license = licenses.mit;
    maintainers = with maintainers; [ jwiegley ];
    platforms = platforms.darwin;
  };
};

nix-scripts = with pkgs; stdenv.mkDerivation {
  name = "nix-scripts";

  src = ./bin;

  buildInputs = [];

  installPhase = ''
    mkdir -p $out/bin
    find . -maxdepth 1 \( -type f -o -type l \) -executable \
        -exec cp -pL {} $out/bin \;
  '';

  meta = with stdenv.lib; {
    description = "John Wiegley's various scripts";
    homepage = https://github.com/jwiegley;
    license = licenses.mit;
    maintainers = with maintainers; [ jwiegley ];
    platforms = platforms.darwin;
  };
};

dovecot-plugins = with pkgs; stdenv.mkDerivation {
  name = "dovecot-plugins";

  buildInputs = [ dovecot dovecot_pigeonhole ];

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/etc/dovecot/modules
    ln -s ${pkgs.dovecot}/lib/dovecot/lib*_plugin.* $out/etc/dovecot/modules
    ln -s ${pkgs.dovecot_pigeonhole}/lib/dovecot/lib*_plugin.* $out/etc/dovecot/modules
  '';
};

ghi = with pkgs; buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "ghi";
  version = "1.2.0";
  sha256 = "05cirb2ndhh0i8laqrfwijprqy63gmxmd8agqkayvqpjs26gdbwi";
  buildInputs = [bundler];
};

gist = with pkgs; buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "gist";
  version = "4.5.0";
  sha256 = "0k9bgjdmnr14whmjx6c8d5ak1dpazirj96hk5ds69rl5d9issw0l";
  buildInputs = [bundler];
};

pdf-tools-server = pkgs.callPackage ./emacs/pdf-tools.nix {};

texFull = with pkgs; texlive.combine {
  inherit (texlive) scheme-full texdoc latex2e-help-texinfo;
  pkgFilter = pkg:
     pkg.tlType == "run"
  || pkg.tlType == "bin"
  || pkg.pname == "latex2e-help-texinfo";
};

}