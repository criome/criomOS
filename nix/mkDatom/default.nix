{ kor, lib }:

{
  name,
  typeModule,
  typeModuleExtraArgs ? { },
  methods ? { },
  extraModuleArgs ? { },
}@spec:

input:

let
  inherit (kor) mkLamdyz;
  inherit (lib) evalModules mkOption;
  inherit (lib.types) submoduleWith;

  argsModule = {
    _module.args = extraModuleArgs // {
      inherit lib;
    };
  };

  typeModuleArgs = {
    _module.args = typeModuleExtraArgs // {
      inherit name kor;
    };
  };

  typeSubmodule = submoduleWith {
    shorthandOnlyDefinesConfig = true;
    modules = [
      spec.typeModule
      typeModuleArgs
    ];
  };

  typeCheckingModule =
    { lib, ... }:
    with lib;
    {
      options.self = mkOption { type = typeSubmodule; };
    };

  typeCheckingEvaluation = evalModules {
    modules = [
      argsModule
      typeCheckingModule
      { self = input; }
    ];
  };

  # self = typeCheckingEvaluation.config.self;
  inherit (typeCheckingEvaluation.config) self;

  closure = methods // {
    inherit self kor lib;
  };

  methods = mkLamdyz {
    klozyr = closure;
    lamdyz = spec.methods;
  };

  type = name + "Datom";

in
methods // { inherit type self; }
