{
  programs.bash = {
    enable = true;
    # https://github.com/spaceship-prompt/spaceship-prompt/issues/462#issuecomment-1564754315
    bashrcExtra = ''
      show_newline() {
        if [ -z "$NEW_LINE_BEFORE_PROMPT" ]; then
          NEW_LINE_BEFORE_PROMPT=1
        elif [ "$NEW_LINE_BEFORE_PROMPT" -eq 1 ]; then
          echo ""
        fi
      }
      PROMPT_COMMAND="show_newline"
      eval "$(starship init bash)"
    '';
  };
  programs.starship = {
    enable = true;
    settings = {
      format = "[](red)$os$username[](bg:orange fg:red)$directory[](bg:yellow fg:orange)$git_branch$git_status[](fg:yellow bg:green)$c$rust$golang$nodejs$php$java$kotlin$haskell$python[](fg:green bg:blue)$conda[](fg:blue bg:magenta)$time[ ](fg:magenta)$cmd_duration$line_break$character";

      os = {
        disabled = false;
        style = "bg:red fg:black";
        symbols = {
          Windows = "";
          Ubuntu = "󰕈";
          SUSE = "";
          Raspbian = "󰐿";
          Mint = "󰣭";
          Macos = "󰀵";
          Manjaro = "";
          Linux = "󰌽";
          Gentoo = "󰣨";
          Fedora = "󰣛";
          Alpine = "";
          Amazon = "";
          Android = "";
          AOSC = "";
          Arch = "󰣇";
          Artix = "󰣇";
          EndeavourOS = "";
          CentOS = "";
          Debian = "󰣚";
          Redhat = "󱄛";
          RedHatEnterprise = "󱄛";
          Pop = "";
          NixOS = "";
        };
      };

      username = {
        show_always = true;
        style_user = "bg:red fg:black";
        style_root = "bg:red fg:black";
        format = "[ $user]($style)";
      };

      directory = {
        style = "bg:orange fg:black";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
        substitutions = {
          Documents = "󰈙 ";
          Downloads = " ";
          Music = "󰝚 ";
          Pictures = " ";
          Developer = "󰲋 ";
        };
      };

      git_branch = {
        symbol = "";
        style = "bg:yellow";
        format = "[[ $symbol $branch ](fg:black bg:yellow)]($style)";
      };

      git_status = {
        style = "bg:yellow";
        format = "[[($all_status$ahead_behind )](fg:black bg:yellow)]($style)";
      };

      nodejs = {
        symbol = "";
        style = "bg:green";
        format = "[[ $symbol( $version) ](fg:black bg:green)]($style)";
      };

      c = {
        symbol = " ";
        style = "bg:green";
        format = "[[ $symbol( $version) ](fg:black bg:green)]($style)";
      };

      rust = {
        symbol = "";
        style = "bg:green";
        format = "[[ $symbol( $version) ](fg:black bg:green)]($style)";
      };

      golang = {
        symbol = "";
        style = "bg:green";
        format = "[[ $symbol( $version) ](fg:black bg:green)]($style)";
      };

      php = {
        symbol = "";
        style = "bg:green";
        format = "[[ $symbol( $version) ](fg:black bg:green)]($style)";
      };

      java = {
        symbol = " ";
        style = "bg:green";
        format = "[[ $symbol( $version) ](fg:black bg:green)]($style)";
      };

      kotlin = {
        symbol = "";
        style = "bg:green";
        format = "[[ $symbol( $version) ](fg:black bg:green)]($style)";
      };

      haskell = {
        symbol = "";
        style = "bg:green";
        format = "[[ $symbol( $version) ](fg:black bg:green)]($style)";
      };

      python = {
        symbol = "";
        style = "bg:green";
        format = "[[ $symbol( $version)((#$virtualenv)) ](fg:black bg:green)]($style)";
      };

      conda = {
        symbol = " ";
        style = "bg:green";
        format = "[ $symbol$environment ]($style)";
        ignore_base = false;
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:magenta";
        format = "[[  $time ](fg:black bg:magenta)]($style)";
      };

      line_break.disabled = false;
      add_newline = false;

      character = {
        disabled = false;
        success_symbol = "[](bold fg:green)";
        error_symbol = "[](bold fg:red)";
        vimcmd_symbol = "[](bold fg:green)";
        vimcmd_replace_one_symbol = "[](bold fg:magenta)";
        vimcmd_replace_symbol = "[](bold fg:magenta)";
        vimcmd_visual_symbol = "[](bold fg:yellow)";
      };

      cmd_duration = {
        show_milliseconds = true;
        format = " in $duration ";
        style = "bg:magenta";
        disabled = false;
        show_notifications = true;
        min_time_to_notify = 45000;
      };
    };
  };
}
