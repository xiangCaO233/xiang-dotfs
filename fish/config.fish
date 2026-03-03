if status is-interactive
    # Commands to run in interactive sessions can go here
    # set -gx VK_ICD_FILENAMES "/opt/homebrew/Cellar/molten-vk/1.3.0/etc/vulkan/icd.d/MoltenVK_icd.json"
    set -gx MAKEFLAGS -j24
    set -gx FORCE_VAAPI 1
    set -gx PATH \
        "$HOME/.local/bin" \
        "$HOME/Android/Sdk/emulator" \
        /usr/lib/qt6/bin \
        "~/.cargo/bin/" \
        "/Users/2333xiang/Library/Python/3.9/bin" \
        "$HOME/.npm-global/bin/" \
        /home/xiang/Documents/coding/csharp/AiConsole/builds \
        $PATH
    alias ninja='ninja -j24'
    alias si="fastfetch"
    alias t="tmux"
    alias tls="tmux ls"
    alias ls="eza -l"
    alias lal="eza -lha"
    # 后台低优先级make
    alias bgmake='bgrun make'
    # 后台低优先级bgemerge
    alias bgemerge='bgrun sudo emerge'
    alias updategrub='sudo grub-mkconfig -o /boot/grub/grub.cfg'
    alias emerge-update='sudo emerge --jobs=4 --load-average=32 --sync && bgemerge --jobs=4 --load-average=32 -avuDN @world'

    if not set -q SSH_AUTH_SOCK
        eval (ssh-agent -c) >/dev/null
        ssh-add ~/.ssh/id_ed25519 2>/dev/null
    end

    # 不同模式下的光标样式
    set fish_cursor_default block # Normal 模式：块状光标
    set fish_cursor_insert line # Insert 模式：线状光标
    set fish_cursor_replace underscore # Replace 模式：下划线光标

    function fish_user_key_bindings
        fish_vi_key_bindings # 启用 Vi 模式

        # jk 退出插入模式
        bind -M insert jk "if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f backward-char force-repaint; end"
        # q 跳到上一个单词的末尾
        # bind -M default q 'commandline -f backward-word; commandline -f forward-char'
        bind -M default '^' beginning-of-line
        bind -M default '$' end-of-line
        bind -M default H beginning-of-line
        bind -M default L end-of-line
        bind -M default J 'commandline -f down-line; commandline -f down-line; commandline -f down-line; commandline -f down-line; commandline -f down-line'
        bind -M default K 'commandline -f up-line; commandline -f up-line; commandline -f up-line; commandline -f up-line; commandline -f up-line'

    end
    fish_user_key_bindings

end
