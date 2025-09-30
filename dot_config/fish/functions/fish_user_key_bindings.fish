function fish_user_key_bindings
  fish_vi_key_bindings
  bind -M insert --sets-mode default jk backward-char repaint
end
