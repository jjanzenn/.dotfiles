(setq custom-file (concat user-emacs-directory "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

(org-babel-load-file "~/.config/emacs/config.org")
