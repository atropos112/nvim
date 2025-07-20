{inputs, ...}: {
  devenv.warnOnNewVersion = false;

  git-hooks.hooks = {
    inherit (inputs.atrolib.lib.devenv.git-hooks.hooks) gitleaks markdownlint;
    check-merge-conflicts.enable = true;
    check-added-large-files.enable = true;
    editorconfig-checker.enable = true;
    check-yaml.enable = true;
    yamllint.enable = true;
    shellcheck.enable = true;
  };
}
