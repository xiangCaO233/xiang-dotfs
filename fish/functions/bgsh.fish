# ~/.config/fish/functions/bg-shell.fish

function bgsh --description "Start an interactive shell in a low priority background cgroup"
    # --- 可配置参数 ---
    set -l BG_CPU_WEIGHT 100
    set -l BG_IO_WEIGHT 100

    # systemd-run为交互式shell提供了专门的选项
    systemd-run --user --pty --shell --slice=background.slice \
                --property="CPUWeight=$BG_CPU_WEIGHT" \
                --property="IOWeight=$BG_IO_WEIGHT"
end
