set -gx RUST_WRAPPER sccache
set -gx JUPYTERLAB_DIR $HOME/.local/share/jupyter/lab
set -gx SKIM_DEFAULT_OPTIONS "--ansi --regex"

fish_add_path ~/.local/bin ~/.local/share ~/.local/bin/scripts ~/.cargo/bin
