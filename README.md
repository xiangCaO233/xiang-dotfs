# 我的 Dotfiles 配置

仓库包含在 GNU/Linux 和 macOS 系统上使用的配置文件 (dotfiles)。仓库内提供了一个设置脚本，可以自动将这些配置文件符号链接（软链接）到用户主目录下的正确位置。

## 托管的配置

以下配置文件由本仓库管理。所列路径均为相对于你的用户主目录 (`~`) 的路径。

### 直接位于主目录 (`~/`) 下的文件/目录

-   **`.vimrc`**: Vim 编辑器的配置文件。
-   **`.ideavimrc`**: IdeaVim 插件（JetBrains 系列 IDE 中的 Vim 模拟器）的配置文件。
-   **`.clang-format`**: ClangFormat 用于 C/C++ 代码格式化的用户级默认风格配置。
-   **`.tmux.conf`**: tmux 终端复用器的配置文件。
-   **`.bashrc`**: Bash shell 的配置文件。
-   **`.clangd`**: Clangd 语言服务器的配置文件（例如，用于忽略某些编译器参数）。
-   **`.vim/coc-settings.json`**: Vim 中 CoC (Conquer of Completion) 插件的设置。

### 位于配置目录 (`~/.config/`) 下的文件/目录

-   **`fish/*`**: Fish shell (Friendly Interactive SHell) 的配置文件。
    -   目标位置: `~/.config/fish/`
-   **`wezterm/*`**: WezTerm 终端模拟器的配置文件。
    -   目标位置: `~/.config/wezterm/`
-   **`yazi/*`**: Yazi 终端文件管理器的配置文件。
    -   目标位置: `~/.config/yazi/`
-   **`coc/ultisnips/*`**: Vim 中 CoC 插件的 UltiSnips 集成所使用的多种编程语言的代码片段。
    -   目标位置: `~/.config/coc/ultisnips/`

## 仓库结构

上述所有配置文件和目录都存放在本仓库的根目录下，并保持它们在 `~` 或 `~/.config/` 下应有的相对路径。

例如:

-   你系统中的 `~/.vimrc` 对应本仓库中的 `.vimrc` 文件。
-   你系统中的 `~/.config/fish/config.fish` 对应本仓库中的 `fish/config.fish` 文件。

## 安装与设置

仓库中提供了一个 `setupcfg.sh` 脚本，用于自动将这些文件和目录链接到你用户主目录中的正确位置。这使得在克隆本仓库后，可以一键完成配置。

### 条件

-   **GNU/Linux**: 需要标准的命令行工具 (bash, ln, mv, mkdir, date, readlink)。
-   **macOS**:
    -   需要标准的命令行工具。
    -   **强烈建议**通过 Homebrew 安装 `coreutils` (`brew install coreutils`) 以获得完全兼容性，因为脚本可能会依赖 GNU `readlink` 的特性 (特别是 `greadlink -f`)。脚本在 macOS 上会尝试优先使用 `greadlink` (如果已安装)。

### 步骤

1.  **克隆仓库:**

    ```bash
    git clone <你的仓库URL> ~/my-dotfiles
    cd ~/my-dotfiles
    ```

    (如果你愿意，也可以使用 `my-dotfiles` 以外的目录名。)

2.  **运行设置脚本:**
    `setupcfg.sh` 脚本将会：

    -   备份目标位置任何已存在的文件/目录，通过在其原名后附加时间戳 (例如, `.bashrc_bak_YYYYMMDDHHMMSS`)。
    -   创建从本仓库中的文件到你用户主目录中对应位置的符号链接。

    ```bash
    chmod +x setupcfg.sh updatefiles.sh # 首次运行时确保脚本有执行权限
    ./setupcfg.sh
    ```

## 更新配置

-   **从仓库拉取更新:**
    如果你在一台机器上更新了 dotfiles 并将它们推送到了远程仓库，你可以在另一台机器上拉取这些更改：
    ```bash
    cd ~/my-dotfiles
    git pull
    ./updatefiles.sh # 运行此脚本以确保任何新增文件的链接都已创建
    ```
