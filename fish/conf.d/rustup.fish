if test -f /etc/os-release
    # 读取 /etc/os-release 文件的所有内容
    set os_release_content (cat /etc/os-release)

    # 找到包含 'ID=' 的那一行
    set id_line (string match -r '^ID=.*' $os_release_content)

    if test -n "$id_line"
        # 从 ID 行中提取出发行版的 ID，处理有无双引号的情况
        set distro_id (string replace -r '^ID="?([^"]*)"?$' '$1' $id_line)
        if test "$distro_id" = "gentoo"
            # 如果是 Gentoo，你可以在这里添加任何特定的命令或操作
        else
            source "$HOME/.cargo/env.fish"
        end
    else
        echo "在 /etc/os-release 文件中没有找到 'ID' 字段。"
    end
else
    echo "未找到 /etc/os-release 文件。这可能不是标准的 Linux 系统，或者是一个非常旧的版本。"
end
