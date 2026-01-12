# 只有当文件存在时（通常是 rustup 环境）才加载 Cargo 环境变量
if test -f $HOME/.local/share/cargo/env.fish
    source $HOME/.local/share/cargo/env.fish
else if test -f $HOME/.cargo/env.fish
    source $HOME/.cargo/env.fish
end
