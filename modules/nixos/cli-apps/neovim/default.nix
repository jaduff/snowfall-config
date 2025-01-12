inputs@{
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.cli-apps.neovim;
in
{
  options.${namespace}.cli-apps.neovim = with types; {
    enable = mkBoolOpt false "Whether or not to enable neovim.";
  };

  config = mkIf cfg.enable {
	programs.neovim = {
	  enable = true;
	  defaultEditor = true;
	  viAlias = true;
	  vimAlias = true;
	  configure = {
	    customRC = ''
	      set number
	      set cc=80
	      set list
	      set listchars=tab:→\ ,space:·,nbsp:␣,trail:•,eol:¶,precedes:«,extends:»
	      if &diff
		colorscheme blue
	      endif
	    '';
	    packages.myVimPackage= with pkgs.vimPlugins; {
	      start = [ ctrlp telescope-nvim ];
	    };
	  };
	};
    environment.systemPackages = with pkgs; [
      # FIXME: As of today (2022-12-09), `page` no longer works with my Neovim
      # configuration. Either something in my configuration is breaking it or `page` is busted.
      # page
    ];

    environment.variables = {
      # PAGER = "page";
      # MANPAGER =
      #   "page -C -e 'au User PageDisconnect sleep 100m|%y p|enew! |bd! #|pu p|set ft=man'";
      PAGER = "less";
      MANPAGER = "less";
      NPM_CONFIG_PREFIX = "$HOME/.npm-global";
      EDITOR = "nvim";
    };

    plusultra.home = {
      configFile = {
        "dashboard-nvim/.keep".text = "";
      };

      extraOptions = {
        # Use Neovim for Git diffs.
        programs.zsh.shellAliases.vimdiff = "nvim -d";
        programs.bash.shellAliases.vimdiff = "nvim -d";
        programs.fish.shellAliases.vimdiff = "nvim -d";
      };
    };
  };
}
