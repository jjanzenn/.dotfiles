 (defvar elpaca-installer-version 0.10)
 (defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
 (defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
 (defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
 (defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                               :ref nil :depth 1 :inherit ignore
                               :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                               :build (:not elpaca--activate-package)))
 (let* ((repo  (expand-file-name "elpaca/" elpaca-repos-directory))
        (build (expand-file-name "elpaca/" elpaca-builds-directory))
        (order (cdr elpaca-order))
        (default-directory repo))
   (add-to-list 'load-path (if (file-exists-p build) build repo))
   (unless (file-exists-p repo)
     (make-directory repo t)
     (when (<= emacs-major-version 28) (require 'subr-x))
     (condition-case-unless-debug err
         (if-let* ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                   ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                   ,@(when-let* ((depth (plist-get order :depth)))
                                                       (list (format "--depth=%d" depth) "--no-single-branch"))
                                                   ,(plist-get order :repo) ,repo))))
                   ((zerop (call-process "git" nil buffer t "checkout"
                                         (or (plist-get order :ref) "--"))))
                   (emacs (concat invocation-directory invocation-name))
                   ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                         "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                   ((require 'elpaca))
                   ((elpaca-generate-autoloads "elpaca" repo)))
             (progn (message "%s" (buffer-string)) (kill-buffer buffer))
           (error "%s" (with-current-buffer buffer (buffer-string))))
       ((error) (warn "%s"
                      err) (delete-directory repo 'recursive))))
   (unless (require 'elpaca-autoloads nil t)
     (require 'elpaca)
     (elpaca-generate-autoloads "elpaca" repo)
     (load "./elpaca-autoloads")))
 (add-hook 'after-init-hook #'elpaca-process-queues)
 (elpaca `(,@elpaca-order))
 (setq use-package-always-ensure t)
 (elpaca elpaca-use-package
   (elpaca-use-package-mode))
(column-number-mode 1)
(display-time-mode)
(use-package auto-dark
  :custom
  (auto-dark-themes '((modus-vivendi) (modus-operandi)))
  :init
  (when (memq window-system '(mac ns x))
    (auto-dark-mode)))
(use-package diredfl
  :init
  (diredfl-global-mode 1))
(use-package rainbow-delimiters
  :hook
  (prog-mode . rainbow-delimiters-mode))
(use-package comment-tags
  :init
  (setq comment-tags-keyword-faces
        `(("TODO" . ,(list :weight 'bold :foreground "#28ABE3"))
          ("FIXME" . ,(list :weight 'bold :foreground "#DB3340"))
          ("BUG" . ,(list :weight 'bold :foreground "#DB3340"))
          ("HACK" . ,(list :weight 'bold :foreground "#E8B71A"))
          ("KLUDGE" . ,(list :weight 'bold :foreground "#E8B71A"))
          ("XXX" . ,(list :weight 'bold :foreground "#F7EAC8"))
          ("INFO" . ,(list :weight 'bold :foreground "#F7EAC8"))
          ("DONE" . ,(list :weight 'bold :foreground "#1FDA9A"))))
  (setq comment-tags-comment-start-only t
        comment-tags-require-colon t
        comment-tags-case-sensitive t
        comment-tags-show-faces t
        comment-tags-lighter t)
  :hook
  (prog-mode . comment-tags-mode))
(use-package ns-auto-titlebar
  :init
  (when (memq window-system '(mac ns x))
    (ns-auto-titlebar-mode)))
(global-display-line-numbers-mode 1)
(defun jj/run-visual-line-mode ()
  "run visual-line-mode"
  (visual-line-mode)
  (visual-fill-column-mode))
(use-package visual-fill-column
  :hook
  (org-mode . jj/run-visual-line-mode)
  (markdown-mode . jj/run-visual-line-mode)
  :config
  (setq-default visual-fill-column-width 128
        visual-fill-column-center-text t))
(use-package exec-path-from-shell
  :init
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))
(setq dired-use-ls-dired nil)
(setq-default indent-tabs-mode nil)
(setq tab-width 4
      c-basic-offset tab-width)
(add-hook 'before-save-hook
          (lambda ()
            (unless (eql (with-current-buffer (current-buffer) major-mode)
                         'markdown-mode)
              (delete-trailing-whitespace))))
 (keymap-global-set "C-c w h" 'windmove-left)
 (keymap-global-set "C-c w j" 'windmove-down)
 (keymap-global-set "C-c w k" 'windmove-up)
 (keymap-global-set "C-c w l" 'windmove-right)
 (keymap-global-set "C-c C-w h" 'windmove-swap-states-left)
 (keymap-global-set "C-c C-w j" 'windmove-swap-states-down)
 (keymap-global-set "C-c C-w k" 'windmove-swap-states-up)
 (keymap-global-set "C-c C-w l" 'windmove-swap-states-right)
(use-package zoom
 :init
 (zoom-mode)
 :config
 (setq zoom-size '(0.618 . 0.618)))
(global-unset-key (kbd "<C-wheel-up>"))
(global-unset-key (kbd "<C-wheel-down>"))
(setq ring-bell-function 'ignore)
(setq confirm-kill-emacs 'yes-or-no-p)
(add-to-list 'find-file-not-found-functions
             (lambda ()
               (let ((parent-directory (file-name-directory buffer-file-name)))
                 (when (and (not (file-exists-p parent-directory))
                            (y-or-n-p (format "Directory `%s' does not exist! Create it?" parent-directory)))
                   (make-directory parent-directory t)))))
(setq make-backup-files nil)
(use-package saveplace-pdf-view
  :config
  (save-place-mode 1))
(tooltip-mode -1)
(use-package ultra-scroll
 :ensure (ultra-scroll :host github :repo "jdtsmith/ultra-scroll")
 :init
 (setq scroll-conservatively 101
   scroll-margin 0)
 :config
 (ultra-scroll-mode 1))
 (use-package consult
   :bind
   (
        ("C-c M-x" . consult-mode-command)
        ("C-c h" . consult-history)
        ("C-c k" . consult-kmacro)
        ("C-c m" . consult-man)
        ("C-c i" . consult-info)
        ([remap Info-search] . consult-info)
        ("C-x M-:" . consult-complex-command)
        ("C-x b" . consult-buffer)
        ("C-x 4 b" . consult-buffer-other-window)
        ("C-x 5 b" . consult-buffer-other-frame)
        ("C-x t b" . consult-buffer-other-tab)
        ("C-x r b" . consult-bookmark)
        ("C-x p b" . consult-project-buffer)
        ("M-#" . consult-register-load)
        ("M-'" . consult-register-store)
        ("C-M-#" . consult-register)
        ("M-y" . consult-yank-pop)
        ("M-g e" . consult-compile-error)
        ("M-g f" . consult-flymake)
        ("M-g g" . consult-goto-line)
        ("M-g M-g" . consult-goto-line)
        ("M-g o" . consult-outline)
        ("M-g m" . consult-mark)
        ("M-g k" . consult-global-mark)
        ("M-g i" . consult-imenu)
        ("M-g I" . consult-imenu-multi)
        ("M-s d" . consult-find)
        ("M-s c" . consult-locate)
        ("M-s g" . consult-grep)
        ("M-s G" . consult-git-grep)
        ("M-s r" . consult-ripgrep)
        ("M-s l" . consult-line)
        ("M-s L" . consult-line-multi)
        ("M-s k" . consult-keep-lines)
        ("M-s u" . consult-focus-lines)
        ("M-s e" . consult-isearch-history)
        :map isearch-mode-map
        ("M-e" . consult-isearch-history)
        ("M-s e" . consult-isearch-history)
        ("M-s l" . consult-line)
        ("M-s L" . consult-line-multi)
        :map minibuffer-local-map
        ("M-s" . consult-history)
        ("M-r" . consult-history))
   :hook
   (completion-list-mode . consult-preview-at-point-mode)
   :init
   (advice-add #'register-preview :override #'consult-register-window)
   (setq register-preview-delay 0.5)
   (setq xref-show-xrefs-function #'consult-xref
         xref-show-definitions-function #'consult-xref)
   (setq consult-man-args "/usr/bin/man -k")
   :config
   (consult-customize
    consult-theme :preview-key '(:debounce 0.2 any)
    consult-ripgrep consult-git-grep consult-grep consult-man
    consult-bookmark consult-recent-file consult-xref
    consult--source-bookmark consult--source-file-register
    consult--source-recent-file consult--source-project-recent-file
    :preview-key '(:debounce 0.4 any))
   (setq consult-narrow-key "<"))
(use-package dumb-jump
  :init
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate))
(use-package transient)
(use-package magit)
(use-package rg)
(use-package projectile
  :init
  (projectile-mode)
  (setq projectile-project-search-path '("~/projects"))
  :bind
  (:map projectile-mode-map ("C-c p" . projectile-command-map)))
;; Overwrite a default function that makes the prompt editable for some reason
(eval-after-load "em-prompt" '(defun eshell-emit-prompt ()
                               "Emit a prompt if eshell is being used interactively."
                               (when (boundp 'ansi-color-context-region)
                                 (setq ansi-color-context-region nil))
                               (run-hooks 'eshell-before-prompt-hook)
                               (if (not eshell-prompt-function)
                                   (set-marker eshell-last-output-end (point))
                                 (let ((prompt (funcall eshell-prompt-function)))
                                   (add-text-properties
                                    0 (length prompt)
                                    (if eshell-highlight-prompt
                                        '( read-only t
                                           field prompt
                                           font-lock-face eshell-prompt
                                           front-sticky (read-only field font-lock-face)
                                           rear-nonsticky (read-only field font-lock-face))
                                      '( read-only t
                                         field prompt
                                         front-sticky (read-only field font-lock-face)
                                         rear-nonsticky (read-only field font-lock-face)))
                                    prompt)
                                   (eshell-interactive-filter nil prompt)))
                               (run-hooks 'eshell-after-prompt-hook)))
(defun eshell/manage-configs (arg)
 "run the argument through make at the root of my dotfiles repository"
 (let ((dir (eshell/pwd)))
  (eshell/cd "~/.dotfiles")
  (compile (concat "make " arg))
  (eshell/cd dir)))
(defun eshell/yt-2-rss (url)
 "convert a youtube channel link into an rss link"
 (if (not (libxml-available-p))
   (message "libxml is not available")
   (browse-url-emacs url t)
   (let* ((dom (libxml-parse-html-region))
          (rss (dom-elements dom 'title "RSS"))
          (href (dom-attr rss 'href)))
     (kill-buffer)
     href)))
 (defun jj/shorten-path-str (path)
  (let* ((components (split-string (replace-regexp-in-string (getenv "HOME") "~" path) "/"))
         (head-items (butlast components 2))
         (shortened-head (mapcar (lambda (element)
                                   (if (= (length element) 0)
                                       ""
                                     (substring element 0 1)))
                                 head-items))
         (tail-items (last components 2))
         (new-components (append shortened-head tail-items)))
    (propertize (string-join new-components "/") 'font-lock-face '(:foreground "dark green"))))
 (defun jj/curr-dir-git-branch (path)
  (when (and (not (file-remote-p path))
             (eshell-search-path "git")
             (locate-dominating-file path ".git"))
    (let* ((git-branch (when (string-match "On branch \\(.*\\)$" (shell-command-to-string "git status"))
                         (match-string 1 (shell-command-to-string "git status"))))
           (git-status (s-trim (shell-command-to-string "git status")))
           (outofsync (if (string-match-p "use \"git push\" to publish your local commits" git-status)
                          (concat " " (propertize "" 'font-lock-face '(:family "Symbols Nerd Font Mono" :foreground "dark green")))
                        ""))
           (staged (if (string-match-p "Changes to be committed:" git-status)
                       (concat " " (propertize "" 'font-lock-face '(:family "Symbols Nerd Font Mono" :foreground "orange")))
                     ""))
           (unstaged (if (string-match-p "Changes not staged for commit:" git-status)
                         (concat " " (propertize "" 'font-lock-face '(:family "Symbols Nerd Font Mono" :foreground "magenta")))
                       ""))
           (untracked (if (string-match-p "Untracked files:"git-status)
                          (concat " " (propertize "" 'font-lock-face '(:family "Symbols Nerd Font Mono" :foreground "dark red")))
                        "")))
      (concat " "
              (propertize "" 'font-lock-face '(:family "Symbols Nerd Font Mono" :foreground "blue"))
              (propertize git-branch 'font-lock-face '(:foreground "blue"))
              outofsync
              staged
              unstaged
              untracked))))
 (use-package eat
   :init
   (setopt eat-kill-buffer-on-exit t)
   (eat-eshell-mode)
   (defun jj/eshell-quit-or-delete-char (arg)
     "Close the terminal if I hit C-d on an empty line"
     (interactive "p")
     (if (and (eolp) (looking-back eshell-prompt-regexp))
         (eshell-life-is-too-much)
       (delete-forward-char arg)))
   (setq eshell-highlight-prompt nil)
   (setq eshell-prompt-function (lambda ()
                                  (concat (jj/shorten-path-str (eshell/pwd))
                                          (jj/curr-dir-git-branch (eshell/pwd))
                                          (unless (eshell-exit-success-p)
                                            (propertize (format " [%d]" eshell-last-command-status) 'font-lock-face '(:foreground "dark red")))
                                          (if (= (file-user-uid) 0) " # " " $ "))))
   :config
   (setq eshell-visual-commands '())
   :hook
   (eat-mode . (lambda () (display-line-numbers-mode -1)))
   (eshell-mode . (lambda ()
                    (display-line-numbers-mode -1)
                    (eshell/alias "ll" "ls -alF $@*")
                    (eshell/alias "la" "ls -a $@*")
                    (eshell/alias "l" "ls -F $@*")
                    (eshell/alias "ff" "find-file $@*")
                    (eshell/alias "clear" "clear-scrollback")))
   :bind
   ("C-c v" . eshell)
   (:map eshell-mode-map ("C-d" . jj/eshell-quit-or-delete-char)))
(use-package corfu
  :custom
  (corfu-cycle t)
  (corfu-auto t)
  :init
  (global-corfu-mode))
(use-package vertico
  :custom
  (vertico-cycle t)
  (vertico-mode 1))
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))
(use-package marginalia
  :bind
  (:map minibuffer-local-map
        ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode 1))
(use-package flycheck
  :config
  (add-hook 'after-init-hook #'global-flycheck-mode))
(require 'flyspell)
(add-hook 'text-mode-hook #'flyspell-mode)
(use-package flyspell-correct
  :after flyspell
  :bind
  (:map flyspell-mode-map ("C-;" . flyspell-correct-wrapper)))
(use-package esup
  :config
  (setq esup-depth 0))
(use-package dired-preview
  :init
  (setq dired-preview-delay 0.7
        dired-preview-max-size (expt 2 20)
        dired-preview-ignored-extensions-regexp (concat
                                                 "\\."
                                                 "\\(gz\\|"
                                                 "zst\\|"
                                                 "tar\\|"
                                                 "xz\\|"
                                                 "rar\\|"
                                                 "zip\\|"
                                                 "iso\\|"
                                                 "epub"
                                                 "\\)"))
  (dired-preview-global-mode 1))
(use-package multiple-cursors
  :bind
  ("C->" . mc/mark-next-like-this)
  ("C-<" . mc/unmark-next-like-this))
(use-package which-key
  :ensure t
  :config
  (which-key-mode))
(use-package pdf-tools
  :hook
  (doc-view-mode . (lambda () (pdf-tools-install))) ;; install on first pdf opened instead of startup
  (pdf-view-mode . (lambda ()
                     (display-line-numbers-mode -1)
                     (pdf-view-themed-minor-mode)))
  :init
  (add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer)
  :config
  (setq TeX-view-program-selection '((output-pdf "PDF Tools"))
        TeX-view-program-list '(("PDF Tools" TeX-pdf-tools-sync-view))
        TeX-source-correlate-start-server t))
(use-package yasnippet
  :init
  (yas-global-mode 1)
  :bind
  ("C-c s" . yas-insert-snippet))
(use-package yasnippet-snippets)
(use-package apheleia
  :init (apheleia-global-mode 1))
(load-file "~/.config/emacs/feed.el")
(setq newsticker-url-list-defaults nil)
(global-set-key (kbd "C-c f") 'newsticker-show-news)
(with-eval-after-load 'newsticker
  (newsticker-start))
(use-package pomodoro-mode
  :ensure (pomodoro-mode :url "https://git.jjanzen.ca/jjanzen/pomodoro-mode"))
(use-package emms
  :init
  (emms-all)
  (setq emms-player-list '(emms-player-mpv)
        emms-info-functions '(emms-info-native)
        emms-browser-covers #'emms-browser-cache-thumbnail-async
        emms-browser-thumbnail-small-size 64
        emms-browser-thumbnail-medium-size 128
        emms-browser-thumbnail-large-size 256)
  :hook
  (emms-browser-mode . (lambda ()
                         (if (not emms-librefm-scrobbler-session-id)
                          (emms-librefm-scrobbler-enable))))
  (emms-playlist-mode . (lambda ()
                          (if (not emms-librefm-scrobbler-session-id)
                           (emms-librefm-scrobbler-enable)))))
(use-package casual)
(with-eval-after-load 'calc
  (define-key calc-mode-map (kbd "C-o") 'casual-calc-tmenu))
 (use-package org
   :hook
   (org-mode . (lambda ()
                 (variable-pitch-mode)
                 (display-line-numbers-mode -1)))
   :bind
   (
    ("C-c l" . org-store-link)
    ("C-c a" . org-agenda)
    ("C-c c" . org-capture))
   :config
   (org-crypt-use-before-save-magic)
   (setq org-directory "~/org"
         org-agenda-files (list org-directory)
         org-agenda-file-regexp "\\`[^.].*\\.org\\\(\\.gpg\\\)?\\'"
         org-todo-keywords '((sequence "TODO(t)" "PLANNING(p)" "IN-PROGRESS(i@/!)" "VERIFYING(v!)" "BLOCKED(b@)"  "|" "DONE(d!)" "WONT-DO(w@/!)"))
         org-todo-keyword-faces '(
                                  ("TODO" . (:foreground "GoldenRod" :weight bold))
                                  ("PLANNING" . (:foreground "DeepPink" :weight bold))
                                  ("IN-PROGRESS" . (:foreground "DarkCyan" :weight bold))
                                  ("VERIFYING" . (:foreground "DarkOrange" :weight bold))
                                  ("BLOCKED" . (:foreground "Red" :weight bold))
                                  ("DONE" . (:foreground "LimeGreen" :weight bold))
                                  ("OBE" . (:foreground "LimeGreen" :weight bold))
                                  ("WONT-DO" . (:foreground "LimeGreen" :weight bold)))
         org-log-done 'time
         org-hide-emphasis-markers t
         org-format-latex-options (plist-put org-format-latex-options :scale 1.0)
         org-return-follows-link t
         org-tags-exclude-from-inheritance '("crypt")
         org-crypt-key nil
         auto-save-default nil)
   (setq org-capture-templates
       '(
         ("n" "Note"
          entry (file+headline "~/org/notes.org.gpg" "Random Notes")
          "** %?"
          :empty-lines 0)
         ("g" "General To-Do"
          entry (file+headline "~/org/todos.org.gpg" "General Tasks")
          "* TODO [#B] %?\n:Created: %T\n "
          :empty-lines 0)
         ("d" "To-Do with Deadline"
          entry (file+headline "~/org/todos.org.gpg" "Time Dependent Tasks")
          "* TODO [#B] %?\n:Created: %T\n:Deadline: %^t\n"
          :empty-lines 0)))
   (font-lock-add-keywords 'org-mode
                           '(("^ *\\([-]\\) "
                              (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))
   :custom-face
   (org-block ((t :font ,jj/mono-font)))
   (org-code ((t :font ,jj/mono-font (:inherit (shadow)))))
   (org-document-info-keyword ((t :font ,jj/mono-font (:inherit (shadow)))))
   (org-meta-line ((t :font ,jj/mono-font (:inherit (font-lock-comment-face)))))
   (org-verbatim ((t :font ,jj/mono-font (:inherit (shadow)))))
   (org-table ((t :font ,jj/mono-font (:inherit (shadow)))))
   (org-document-title ((t (:inherit title :height 2.0 :underline nil))))
   (org-level-1 ((t (:inherit outline-1 :weight bold :height 1.75))))
   (org-level-2 ((t (:inherit outline-2 :weight bold :height 1.5))))
   (org-level-3 ((t (:inherit outline-3 :weight bold :height 1.25))))
   (org-level-4 ((t (:inherit outline-4 :weight bold :height 1.1))))
   (org-level-5 ((t (:inherit outline-5 :height 1.1))))
   (org-level-6 ((t (:inherit outline-6)))))
(use-package bison-mode)
(use-package cmake-mode)
(use-package go-mode)
(use-package go-eldoc
  :hook
  (go-mode . go-eldoc-setup))
(use-package go-gen-test)
(use-package go-guru
  :hook
  (go-mode . go-guru-hl-identifier-mode))
(use-package haskell-mode)
(use-package auctex
  :hook
  (LaTeX-mode . (lambda () (put 'LaTeX-mode 'eglot-language-id "latex"))))
(use-package cdlatex
  :hook
  (LaTeX-mode . turn-on-cdlatex))
(use-package parinfer-rust-mode
  :hook
  (emacs-lisp-mode . parinfer-rust-mode)
  :init
  (setq parinfer-rust-auto-download t))
(use-package lua-mode)
(use-package markdown-mode
  :hook
  (markdown-mode . (lambda ()
                     (variable-pitch-mode)
                     (display-line-numbers-mode -1)
                     (eglot-ensure)))
  :config
  (setq markdown-hide-markup t)
  :custom-face
  (markdown-header-face ((t :font ,jj/var-font :weight bold)))
  (markdown-header-face-1 ((t (:inherit markdown-header-face :height 2.0))))
  (markdown-header-face-2 ((t (:inherit markdown-header-face :height 1.75))))
  (markdown-header-face-3 ((t (:inherit markdown-header-face :height 1.5))))
  (markdown-header-face-4 ((t (:inherit markdown-header-face :height 1.25))))
  (markdown-header-face-5 ((t (:inherit markdown-header-face :height 1.1))))
  (markdown-header-face-6 ((t (:inherit markdown-header-face :height 1.1))))
  (markdown-blockquote-face ((t :font ,jj/var-font)))
  (markdown-code-face ((t :font ,jj/mono-font)))
  (markdown-html-attr-name-face ((t :font ,jj/mono-font)))
  (markdown-html-attr-value-face ((t :font ,jj/mono-font)))
  (markdown-html-entity-face ((t :font ,jj/mono-font)))
  (markdown-html-tag-delimiter-face ((t :font ,jj/mono-font)))
  (markdown-html-tag-name-face ((t :font ,jj/mono-font)))
  (markdown-html-comment-face ((t :font ,jj/mono-font)))
  (markdown-header-delimiter-face ((t :font ,jj/mono-font)))
  (markdown-hr-face ((t :font ,jj/mono-font)))
  (markdown-inline-code-face ((t :font ,jj/mono-font)))
  (markdown-language-info-face ((t :font ,jj/mono-font)))
  (markdown-language-keyword-face ((t :font ,jj/mono-font)))
  (markdown-link-face ((t :font ,jj/mono-font)))
  (markdown-markup-face ((t :font ,jj/mono-font)))
  (markdown-math-face ((t :font ,jj/mono-font)))
  (markdown-metadata-key-face ((t :font ,jj/mono-font)))
  (markdown-metadata-value-face ((t :font ,jj/mono-font)))
  (markdown-missing-link-face ((t :font ,jj/mono-font)))
  (markdown-plain-url-face ((t :font ,jj/mono-font)))
  (markdown-reference-face ((t :font ,jj/mono-font)))
  (markdown-table-face ((t :font ,jj/mono-font)))
  (markdown-url-face ((t :font ,jj/mono-font))))
(use-package nix-mode
  :mode
  "\\.nix\\'")
(use-package pet
  :config
  (add-hook 'python-base-mode-hook 'pet-mode -10))
(use-package yaml-mode)
(use-package zig-mode)
(global-set-key (kbd "C-c r") 'eglot-rename)
(use-package tree-sitter)
(use-package tree-sitter-langs)
(defun jj/enable-extras ()
  (eglot-ensure)
  (tree-sitter-mode 1)
  (tree-sitter-hl-mode 1))
(dolist (lang-hook '(sh-mode-hook
                     c-mode-hook
                     c++-mode-hook
                     cc-mode-hook
                     cmake-mode-hook
                     haskell-mode-hook
                     html-mode-hook
                     css-mode-hook
                     js-mode-hook
                     python-mode-hook
                     go-mode-hook
                     lua-mode-hook
                     tex-mode-hook
                     LaTeX-mode-hook
                     yaml-mode-hook
                     nix-mode-hook
                     zig-mode-hook))
  (add-hook lang-hook #'jj/enable-extras))
