function fish_greeting
    set -l ciallo_image "$HOME/Pictures/ciallo.jpg"

    if isatty stdout; and test -r "$ciallo_image"
        set -l is_ghostty false
        set -l through_tmux false

        if set -q TERM_PROGRAM; and test "$TERM_PROGRAM" = ghostty
            set is_ghostty true
        else if set -q TMUX; and command -q tmux
            if command tmux show-environment TERM_PROGRAM 2>/dev/null \
                    | string match --quiet 'TERM_PROGRAM=ghostty'
                set is_ghostty true
                set through_tmux true
            end
        end

        if test "$is_ghostty" = true
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

                # Ghostty implements Kitty's graphics protocol. Supplying only
                # the width lets Ghostty preserve the image's aspect ratio.
                if test "$through_tmux" = true
                    # tmux does not account for passthrough graphics in its
                    # virtual cursor position. Work out the 1440x900 image's
                    # exact cell height, keep Ghostty's cursor fixed, then move
                    # tmux's cursor by that many real terminal lines below.
                    set -l image_rows 15
                    set -l cell_size (string split ':' -- \
                        (command tmux display-message -p \
                            '#{client_cell_width}:#{client_cell_height}' 2>/dev/null))

                    if test (count $cell_size) -eq 2 \
                            && string match --quiet --regex '^[1-9][0-9]*$' "$cell_size[1]" \
                            && string match --quiet --regex '^[1-9][0-9]*$' "$cell_size[2]"
                        set image_rows (math --scale=0 \
                            "ceil($image_columns * $cell_size[1] * 5 / (8 * $cell_size[2]))")
                    end

                    # tmux passthrough DCS; escape bytes inside it are doubled.
                    printf '\ePtmux;\e\e_Ga=T,f=100,t=f,c=%s,r=%s,C=1,q=2;%s' \
                        "$image_columns" "$image_rows" "$encoded_path"
                    printf '\e\e\\'
                    printf '\e\\'

                    for unused in (seq "$image_rows")
                        printf '\r\n'
                    end
                else
                    printf '\e_Ga=T,f=100,t=f,c=%s,q=2;%s' \
                        "$image_columns" "$encoded_path"
                    printf '\e\\'

                    # Direct Ghostty knows the placement height itself; move
                    # one more line so text starts outside the final image row.
                    printf '\r\n'
                end
            end
        else if command -q chafa
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
