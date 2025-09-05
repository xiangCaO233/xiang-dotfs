# ~/.config/fish/functions/bg-run.fish
function bgrun --description "Run a command in a low priority background cgroup using systemd"
    # --- 可配置参数 ---
    # 定义CPU和I/O权重。数值越低，优先级越低。
    # systemd 默认权重是1024。
    set -l BG_CPU_WEIGHT 100
    set -l BG_IO_WEIGHT 100

    # 检查是否传入了命令
    if test (count $argv) -eq 0
        echo "用法: bgrun <命令> [参数...]"
        return 1
    end
    
    # 使用systemd-run来执行命令，设置低权重
    # --user: 在用户会话下运行，无需root
    # --scope: 创建一个临时的scope单元，任务结束后自动清理
    # --collect: 确保在命令退出后，systemd单元才退出，避免孤儿进程
    systemd-run --user --scope --slice=background.slice \
                --property="CPUWeight=$BG_CPU_WEIGHT" \
                --property="IOWeight=$BG_IO_WEIGHT" \
                $argv # 在fish中，$argv直接展开为所有参数
end
