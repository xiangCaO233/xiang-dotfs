#!/bin/bash

# 脚本功能：将仓库中的配置文件软链接到用户的主目录和.config目录中。
#             如果目标位置已存在文件或目录，会先备份原有的，然后创建新的链接。
# 使用方法：进入仓库目录后，直接运行此脚本 ./setupcfgs.sh

# --- 配置段 ---
# SCRIPT_DIR: 获取脚本文件所在的绝对路径，确保无论从哪里执行，都能正确找到仓库内的文件。
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# BACKUP_SUFFIX: 定义备份文件/目录时使用的后缀，包含日期和时间戳，以避免覆盖。
BACKUP_SUFFIX="_bak_$(date +%Y%m%d%H%M%S)"

# USER_HOME: 用户的主目录路径 (通常是 /home/username)。
USER_HOME="$HOME"
# USER_CONFIG_DIR: 用户的 .config 目录路径 (通常是 ~/.config)。
USER_CONFIG_DIR="$USER_HOME/.config"

# --- 脚本主逻辑 ---
echo "Dotfiles Repository: $SCRIPT_DIR"
echo "User Home: $USER_HOME"
echo "User Config Dir: $USER_CONFIG_DIR"
echo "--------------------------------------------------"
echo "Starting setup process..."

# 预先创建目标链接可能需要的父目录，避免后续 ln 命令因父目录不存在而失败。
# 例如，为 .vim/coc-settings.json 创建 .vim 目录。
# 为 ~/.config/coc/ultisnips 创建 ~/.config/coc 目录。
echo "[INFO] Ensuring base directories exist for target links..."
mkdir -p "$USER_HOME/.vim"        # 为 .vim/coc-settings.json 准备
mkdir -p "$USER_CONFIG_DIR"       # ~/.config 目录本身
mkdir -p "$USER_CONFIG_DIR/coc"   # 为 coc/ultisnips 准备

# 定义要创建链接的文件和目录列表。
# 每一项的格式是："仓库内的相对路径" "目标绝对路径"
# 左边是仓库中文件的路径（相对于脚本所在目录），右边是希望它链接到的系统中的绝对路径。
links=(
    # --- 直接位于 $HOME 下的文件/目录 ---
    ".vimrc                      $USER_HOME/.vimrc"
    ".ideavimrc                  $USER_HOME/.ideavimrc"
    ".clang-format               $USER_HOME/.clang-format"
    ".tmux.conf                  $USER_HOME/.tmux.conf"
    ".bashrc                     $USER_HOME/.bashrc"
    ".clangd                     $USER_HOME/.clangd"
    ".vim/coc-settings.json      $USER_HOME/.vim/coc-settings.json" # 文件，其父目录 .vim 已确保存在

    # --- 位于 $HOME/.config 下的目录 ---
    # 对于目录，我们会链接整个目录。仓库中此目录下的所有内容都会通过链接在目标位置可见。
    "fish                        $USER_CONFIG_DIR/fish"
    "mpv                         $USER_CONFIG_DIR/mpv"
    "wezterm                     $USER_CONFIG_DIR/wezterm"
    "yazi                        $USER_CONFIG_DIR/yazi"
    "coc/ultisnips               $USER_CONFIG_DIR/coc/ultisnips" # coc 目录下的 ultisnips 子目录
)

# 函数：create_symlink
# 参数1: source_path (源文件/目录在仓库中的绝对路径)
# 参数2: target_path (目标链接在系统中的绝对路径)
# 功能: 检查目标路径，如果存在则备份，然后创建从源到目标的软链接。
create_symlink() {
    local source_path="$1" # 仓库中的源文件/目录路径
    local target_path="$2" # 系统中目标链接的路径

    echo "" # 添加空行以分隔每个条目的处理信息
    echo "[INFO] Processing target: $target_path"

    # 检查源文件/目录是否存在于仓库中
    # 使用 -e 检查是否存在（文件或目录），-L 检查是否是符号链接（主要用于源本身也是链接的情况，虽然本场景下源是实体文件/目录）
    if [ ! -e "$source_path" ] && [ ! -L "$source_path" ]; then
        echo "  [WARNING] Source '$source_path' does not exist in the repository. Skipping."
        return 1 # 返回非零表示有警告或错误
    fi

    # 检查目标路径是否已存在（无论是文件、目录还是符号链接）
    # -L 用于捕获即使是损坏的符号链接
    if [ -e "$target_path" ] || [ -L "$target_path" ]; then
        echo "  [INFO] Target '$target_path' already exists."
        local backup_path="${target_path}${BACKUP_SUFFIX}"
        echo "  [ACTION] Backing up existing '$target_path' to '$backup_path'..."
        # 使用 mv 命令进行备份，如果成功，原目标就被移走了
        if mv "$target_path" "$backup_path"; then
            echo "  [SUCCESS] Backup of '$target_path' complete. Original has been moved."
        else
            echo "  [ERROR] Failed to backup '$target_path'. Please check permissions. Skipping link creation for this item."
            return 1 # 返回非零表示有错误
        fi
    fi

    # 创建目标路径的父目录 (如果它还不存在的话)
    # 例如，如果 target_path 是 /home/user/.config/foo/bar.conf，而 /home/user/.config/foo 不存在，则创建它。
    local target_parent_dir
    target_parent_dir=$(dirname "$target_path") # 获取目标路径的父目录
    if [ ! -d "$target_parent_dir" ]; then
        echo "  [INFO] Parent directory '$target_parent_dir' for target does not exist. Creating it..."
        if mkdir -p "$target_parent_dir"; then
            echo "  [SUCCESS] Created parent directory '$target_parent_dir'."
        else
            echo "  [ERROR] Failed to create parent directory '$target_parent_dir'. Skipping link creation for '$target_path'."
            return 1 # 返回非零表示有错误
        fi
    fi

    # 创建软链接
    # ln -sfn:
    #   -s: 创建符号链接 (symbolic link)。
    #   -f: (--force) 如果目标文件已存在，则强制执行。由于我们已经通过mv备份移除了原目标，
    #       -f 主要确保如果目标是一个目录的符号链接，它会替换该符号链接而不是在其内部创建。
    #   -n: (--no-dereference 或 --no-target-directory) 当链接目标是一个目录的符号链接时，将目标视为普通文件。
    #       这对于确保你链接的是目录本身而不是其内容非常重要。
    echo "  [ACTION] Linking '$source_path' -> '$target_path'..."
    if ln -sfn "$source_path" "$target_path"; then
        echo "  [SUCCESS] Link created: '$target_path' now points to '$source_path'."
    else
        echo "  [ERROR] Failed to create link from '$source_path' to '$target_path'."
        return 1 # 返回非零表示有错误
    fi
    return 0 # 返回零表示成功
}

# --- 循环处理链接 ---
# 遍历上面定义的 links 数组，为每一对源和目标调用 create_symlink 函数。
has_errors=0 # 标记在处理过程中是否发生了错误
for link_pair_str in "${links[@]}"; do
    # 使用Bash的read命令从字符串中安全地分割路径
    # <<< "$link_pair_str" 是一个 here string，将字符串内容作为read的输入
    read -r repo_relative_path target_abs_path <<< "$link_pair_str"

    # 构建源文件的绝对路径 (仓库中的文件)
    source_abs_path="$SCRIPT_DIR/$repo_relative_path"

    # 调用函数创建链接
    if ! create_symlink "$source_abs_path" "$target_abs_path"; then
        has_errors=1 # 如果任何链接创建失败，则标记
    fi
done

echo "--------------------------------------------------"
if [ "$has_errors" -eq 1 ]; then
    echo "[WARNING] Setup process completed with one or more errors. Please review the output above."
else
    echo "[SUCCESS] Setup process completed successfully."
fi
