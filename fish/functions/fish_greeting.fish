function fish_greeting
    set -l ciallo_image "$HOME/Pictures/ciallo.jpg"

    if isatty stdout; and test -r "$ciallo_image"
        set -l is_ghostty false

        if set -q TERM_PROGRAM; and test "$TERM_PROGRAM" = ghostty
            set is_ghostty true
        end

        if not set -q TMUX; and test "$is_ghostty" = true
            set -l cache_home "$HOME/.cache"
            if set -q XDG_CACHE_HOME; and test -n "$XDG_CACHE_HOME"
                set cache_home "$XDG_CACHE_HOME"
            end

            set -l cache_dir "$cache_home/fish-greeting"
            set -l ciallo_png "$cache_dir/ciallo.png"

            if command -q magick
                if not test -r "$ciallo_png"; or test "$ciallo_image" -nt "$ciallo_png"
                    command mkdir -p "$cache_dir"
                    set -l temporary_png "$cache_dir/ciallo.$fish_pid.png"

                    if command magick "$ciallo_image" -auto-orient -strip "png:$temporary_png"
                        command mv -f "$temporary_png" "$ciallo_png"
                    else
                        command rm -f "$temporary_png"
                    end
                end
            end

            if test -r "$ciallo_png"; and command -q base64
                set -l encoded_path (printf '%s' "$ciallo_png" | command base64 --wrap=0)
                set -l image_columns 48

                # Ghostty 直连时使用 Kitty 图片协议，并让终端保持图片宽高比。
                printf '\e_Ga=T,f=100,t=f,c=%s,q=2;%s' \
                    "$image_columns" "$encoded_path"
                printf '\e\\'
                printf '\r\n'
            end
        else if not set -q TMUX; and command -q chafa
            chafa \
                --format symbols \
                --colors full \
                --size 48x18 \
                --animate off \
                --probe off \
                "$ciallo_image"
        end
    end

    printf 'Ciallo～'
    set_color --bold
    printf '(∠・ω< )⌒★'
    set_color normal
    printf '\n'
end
