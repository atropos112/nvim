{
  pkgs,
  lib,
  config,
  ...
}: {
  enterShell = ''
    echo
    echo 🦾 Useful project scripts:
    echo 🦾
    ${pkgs.gnused}/bin/sed -e 's| |••|g' -e 's|=| |' <<EOF | ${pkgs.util-linuxMinimal}/bin/column -t | ${pkgs.gnused}/bin/sed -e 's|^|🦾 |' -e 's|••| |g'
    ${lib.generators.toKeyValue {} (lib.mapAttrs (_: value: value.description) config.scripts)}
    EOF
    echo
  '';

  packages = with pkgs; [
    gitleaks
  ];

  pre-commit.hooks = {
    shellcheck.enable = true;
    markdownlint = {
      enable = true;
      settings.configuration = {
        MD045 = false; # no-alt-line
        MD033 = {
          allowed_elements = [
            "p"
            "img"
          ];
        };
        MD013 = {
          line_length = 360;
        };
      };
    };
    gitleaks = {
      enable = true;
      name = "gitleaks";
      entry = "${pkgs.gitleaks}/bin/gitleaks protect --verbose --redact --staged";
    };
  };
}
