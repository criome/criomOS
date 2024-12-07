{ lib, config, kor, metastrizSpiciz, Metastriz, ... }:
let
  inherit (builtins) filter concatStringsSep listToAttrs hasAttr attrNames concatMap elem;
  inherit (kor) louestOf nameValuePair filterAttrs spiciDatum optional
    mapAttrsToList optionalAttrs optionalString arkSistymMap unique;
  inherit (config) metastraNeim astraNeim spiciz;
  inherit (metastrizSpiciz) metastriNeimz astriSpiciz;

  inputMetastra = Metastriz.${metastraNeim};
  inputAstriz = inputMetastra.astriz;
  inputAstra = inputAstriz.${astraNeim};

  astriNeimz = attrNames inputMetastra.astriz;
  userNeimz = attrNames inputMetastra.users;

  neksysCriomOSNeim = concatStringsSep "."
    [ metastraNeim "criome" ];

  metaTrost = inputMetastra.trost.metastra;

  mkTrost = yrei: louestOf (yrei ++ [ metaTrost ]);

  mkEseseitcString = preCriome:
    if (preCriome == null) then "" else
    concatStringsSep " " [ "ssh-ed25519" preCriome ];

  mkAstri = astriNeim:
    let
      # (TODO typecheck)
      inputAstri = inputAstriz.${astriNeim};
      inherit (inputAstri) saiz spici;
      inherit (inputAstri.preCriomes) yggdrasil;

      filteredMycin = spiciDatum {
        datum = inputAstri.mycin;
        spek = {
          metyl = [ "ark" "mothyrBord" "modyl" ];
          pod = [ "ark" "ubyrAstri" "ubyrUser" ];
        };
      };

      rytyrnArkFromMothyrBord = mb: abort "Missing mothyrBord table";

      tcekdArk =
        if (filteredMycin.ark != null)
        then filteredMycin.ark
        else if (filteredMycin.spici == "pod")
        then astriz.${filteredMycin.ubyrAstri}.mycin.ark
        else if (filteredMycin.mothyrBord != null)
        then (rytyrnArkFromMothyrBord filteredMycin.mothyrBord)
        else abort "Missing mycin ark";

      mycin = filteredMycin // { ark = tcekdArk; };

      mkLinkLocalIP = linkLocalIP: with linkLocalIP;
        let
          interface =
            if (spici == "ethernet") then "enp0s25"
            else "wlp3s0";
        in
        "fe80::${suffix}%${interface}";

      neksysIp = inputAstri.neksysIp or null;
      wireguardPreCriome = inputAstri.wireguardPreCriome or null;

      mkTypeIsFromTypeName = name:
        let isOfThisType = name == spici; in
        nameValuePair name isOfThisType;

      astri = {
        inherit saiz spici;

        neim = astriNeim;
        inherit mycin wireguardPreCriome neksysIp;

        linkLocalIPs =
          if (hasAttr "linkLocalIPs" inputAstri)
          then (map mkLinkLocalIP inputAstri.linkLocalIPs)
          else [ ];

        trost = mkTrost
          [ inputAstri.trost inputMetastra.trost.astriz.${astriNeim} ];

        eseseitc = mkEseseitcString inputAstri.preCriomes.eseseitc;

        yggPreCriome = yggdrasil.preCriome;
        yggAddress = yggdrasil.address;
        yggSubnet = yggdrasil.subnet;

        inherit (inputAstri.preCriomes) niksPreCriome;

        criomOSNeim = concatStringsSep "."
          [ astriNeim neksysCriomOSNeim ];

        sistym = arkSistymMap.${mycin.ark};

        nbOfBildKorz = 1; #TODO

        typeIs = listToAttrs
          (map mkTypeIsFromTypeName astriSpiciz);
      };

      spinyrz =
        let
          inherit (astri) spici trost saiz niksPreCriome
            yggAddress criomOSNeim typeIs;

        in
        rec {
          izFullyTrusted = trost == 3;
          saizAtList = kor.mkSaizAtList saiz;
          izBildyr = !typeIs.edj && izFullyTrusted && (saizAtList.med || typeIs.sentyr) && izCriodaizd;
          izDispatcyr = !typeIs.sentyr && izFullyTrusted && saizAtList.min;
          izNiksKac = typeIs.sentyr && saizAtList.min && izCriodaizd;
          izNiksCriodaizd = niksPreCriome != null && niksPreCriome != "";
          izYggCriodaizd = yggAddress != null && yggAddress != "";
          izNeksisCriodaizd = izYggCriodaizd;
          izEseseitcCriodaizd = hasAttr "eseseitc" inputAstri.preCriomes;
          hazWireguardPreCriome = wireguardPreCriome != null;

          izCriodaizd = izNiksCriodaizd && izYggCriodaizd && izEseseitcCriodaizd;

          eseseitcPreCriome =
            if !izEseseitcCriodaizd then ""
            else mkEseseitcString inputAstri.preCriomes.eseseitc;

          nixPreCriome = optionalString izNiksCriodaizd
            (concatStringsSep ":" [ criomOSNeim niksPreCriome ]);

          nixCacheDomain = if izNiksKac then ("nix." + criomOSNeim) else null;
          nixUrl = if izNiksKac then ("http://" + nixCacheDomain) else null;


        };

    in
    astri // { inherit spinyrz; };

  exAstriNeimz = attrNames exAstriz;
  bildyrz = filter (n: astriz.${n}.spinyrz.izBildyr) exAstriNeimz;
  kacyz = filter (n: astriz.${n}.spinyrz.izNiksKac) exAstriNeimz;
  dispatcyrz = filter (n: astriz.${n}.spinyrz.izDispatcyr) exAstriNeimz;

  adminUserNeimz = filter (n: users.${n}.trost == 3) userNeimz;

  astraSpinyrz =
    let
      mkBildyr = n:
        let astri = exAstriz.${n};
        in {
          hostName = astri.criomOSNeim;
          sshUser = "nixBuilder";
          sshKey = "/etc/ssh/ssh_host_ed25519_key";
          supportedFeatures = optional (!astri.typeIs.edj) "big-parallel";
          system = astri.sistym;
          systems = lib.optional (astri.sistym == "x86_64-linux") "i686-linux";
          maxJobs = astri.nbOfBildKorz;
        };

      mkAdminUserPreCriomes = adminUserNeim:
        let
          adminUser = users.${adminUserNeim};
          preCriomeAstriNeimz = attrNames adminUser.preCriomes;
          izAstriFulyTrostyd = n: astriz.${n}.spinyrz.izFullyTrusted;
          fulyTrostydPreCriomeNeimz = filter izAstriFulyTrostyd preCriomeAstriNeimz;
          getEseseitcString = n:
            if (adminUser.preCriomes.${n}.eseseitc == null)
            then "" else (mkEseseitcString adminUser.preCriomes.${n}.eseseitc);
        in
        map getEseseitcString fulyTrostydPreCriomeNeimz;

      inherit (astra.mycin) modyl;
      thinkpadModylz = [ "ThinkPadX240" "ThinkPadX230" ];
      impozdHTModylz = [ "ThinkPadX240" ];

      computerModylz = thinkpadModylz ++ [ "rpi3B" ];

      computerIsNotMap = listToAttrs
        (map (n: nameValuePair n false) computerModylz);

    in
    {
      bildyrKonfigz = map mkBildyr bildyrz;

      kacURLz =
        let
          mkKacURL = n: exAstriz.${n}.spinyrz.nixUrl;
        in
        map mkKacURL kacyz;

      exAstrizEseseitcPreCriomes = map
        (n:
          exAstriz.${n}.eseseitc
        )
        exAstriNeimz;

      dispatcyrzEseseitcKiz = map
        (n:
          exAstriz.${n}.eseseitc
        )
        dispatcyrz;

      adminEseseitcPreCriomes = unique
        (concatMap mkAdminUserPreCriomes adminUserNeimz);

      tcipIzIntel = elem astra.mycin.ark [ "x86-64" "i686" ]; # TODO

      modylIzThinkpad = elem astra.mycin.modyl thinkpadModylz;

      impozyzHaipyrThreding = elem astra.mycin.modyl impozdHTModylz;

      iuzColemak = astra.io.kibord == "colemak";

      computerIs = computerIsNotMap //
        (optionalAttrs (modyl != null)
          { "${modyl}" = true; });

      wireguardUntrustedProxies = astra.wireguardUntrustedProxies or [ ];
    };

  mkUser = userNeim:
    let
      inputUser = inputMetastra.users.${userNeim};

      tcekPreCriome = astriNeim: preCriome:
        hasAttr astriNeim astriz;

      user = {
        neim = userNeim;

        inherit (inputUser) stail spici kibord;

        saiz = louestOf [ inputUser.saiz astra.saiz ];

        trost = inputMetastra.trost.users.${userNeim};

        preCriomes = filterAttrs tcekPreCriome inputUser.preCriomes;

        githubId =
          if (inputUser.githubId == null)
          then userNeim else inputUser.githubId;

      };

      hazPreCriome = hasAttr astra.neim user.preCriomes;

      spinyrz = {
        inherit hazPreCriome;

        saizAtList = kor.mkSaizAtList user.saiz;

        emailAddress = "${user.neim}@${metastra.neim}.criome.me";
        matrixID = "@${user.neim}:${metastra.neim}.criome.me";

        gitSigningKey =
          if hazPreCriome then
            ("&" + user.preCriomes.${astra.neim}.keygrip)
          else null;

        iuzColemak = user.kibord == "colemak";

        izSemaDev = elem user.spici [ "Sema" "Onlimityd" ];
        izNiksDev = elem user.spici [ "Niks" "Onlimityd" ];

        eseseitcyz = mapAttrsToList (n: pk: mkEseseitcString pk.eseseitc)
          user.preCriomes;

      } // (kor.optionalAttrs hazPreCriome {
        eseseitc = mkEseseitcString user.preCriomes.${astra.neim}.eseseitc;
      });

    in
    user // { inherit spinyrz; };

  astriz = listToAttrs (map
    (y: nameValuePair y.neim y)
    (filter (x: x.trost != 0)
      (map (n: mkAstri n) astriNeimz)));

  metastra = {
    neim = metastraNeim;

    spinyrz = {
      trostydBildPreCriomes = map (n: exAstriz.${n}.spinyrz.nixPreCriome) bildyrz
        ++ (optional astra.spinyrz.izNiksCriodaizd astra.spinyrz.nixPreCriome);
    };
  };

  exAstriz = kor.filterAttrs (n: v: n != astraNeim) astriz;

  astra =
    let
      astri = astriz.${astraNeim};
    in
    astri // {
      inherit (inputAstra) io;
      spinyrz = astri.spinyrz // astraSpinyrz;
    };

  users = listToAttrs (map
    (y: nameValuePair y.neim y)
    (filter (x: x.trost != 0)
      (map (n: mkUser n) userNeimz)));

in
{
  hyraizyn = {
    inherit metastra astra exAstriz users;
  };
}
