(setq package-enable-at-startup nil)

(setq custom-file (concat user-emacs-directory "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

(setq inhibit-startup-screen t
      initial-scratch-message nil)

(add-to-list 'default-frame-alist '(vertical-scroll-bars . nil))
(push '(tool-bar-lines . 0) default-frame-alist)
(menu-bar-mode -1)
(setq frame-resize-pixelwise t)

(defvar jj/mono-font "Atkinson Hyperlegible Mono-14:weight=thin")
(defvar jj/var-font "Atkinson Hyperlegible Next-14")
(add-to-list 'default-frame-alist
             `(font . ,jj/mono-font))
(custom-set-faces
 `(variable-pitch ((t :font ,jj/var-font)))
 `(fixed-pitch ((t :font ,jj/mono-font))))
