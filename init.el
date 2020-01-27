;; Autogenerated stuff
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#454545" "#cd5542" "#6aaf50" "#baba36" "#5180b3" "#ab75c3" "#68a5e9" "#bdbdb3"])
 '(cursor-type 'bar)
 '(custom-enabled-themes nil)
 '(custom-safe-themes
   '("c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" default))
 '(ediff-window-setup-function 'ediff-setup-windows-plain)
 '(package-selected-packages
   '(use-package-ensure-system-package verb forge undo-tree company-emoji lsp-sourcekit swift-helpful swift-mode graphviz-dot-mode kaolin-themes highlight-indentation cider counsel dap-mode json-mode markdown-mode smartparens eyebrowse hercules php-mode clojure-mode git-gutter dash-at-point elpy smart-mode-line yasnippet yasnippet-snippets company-go groovy-mode use-package rjsx-mode web-mode lsp-ui company-lsp lsp-java lsp-mode flycheck company-quickhelp dart-mode flutter yaml-mode rainbow-mode jade-mode company-php prettier-js add-node-modules-path nodejs-repl cargo racer rust-mode go-guru go-mode go-projectile go-scratch docker-compose-mode docker dockerfile-mode exec-path-from-shell rainbow-delimiters expand-region fireplace ample-theme which-key ace-window projectile avy multiple-cursors magit company super-save swiper ivy))
 '(pos-tip-background-color "#073642")
 '(pos-tip-foreground-color "#93a1a1"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
)

;; Un-disabled builtins
(put 'upcase-region 'disabled nil)

;; Setup MELPA repo
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives '("gnu" . (concat proto "://elpa.gnu.org/packages/")))))

(package-initialize)


;; Setup use-package
(eval-when-compile
  (require 'use-package))
(require 'bind-key)
(require 'use-package-ensure)
(setq use-package-always-ensure t)
;;(setq use-package-verbose t)
(use-package use-package-ensure-system-package)


;; Make sure exec-path gets loaded right
(use-package exec-path-from-shell
  :demand t
  :config
  (exec-path-from-shell-initialize))


;; Load non-public setings/configs
(setq auth-sources '("~/.authinfo.gpg" "~/.authinfo" "~/.netrc"))
(load "~/.emacs.d/mysecrets.el" t)


;; Generic global keybindings
(global-set-key (kbd "<escape>") #'keyboard-quit)
(global-set-key (kbd "M-p") #'backward-paragraph)
(global-set-key (kbd "M-n") #'forward-paragraph)
(global-set-key (kbd "H-u") #'upcase-char)
(global-set-key (kbd "H-d") #'downcase-dwim)
(global-set-key (kbd "s-s") #'sort-lines)
(global-set-key (kbd "s-%") #'query-replace-regexp)
(global-set-key (kbd "M-j") (lambda () (interactive)
			      (exchange-point-and-mark)
			      (keyboard-quit)))
(global-set-key (kbd "C-x C-p") #'list-processes)


;; Save and restore desktop configuration on emacs quit/launch
;;(desktop-save-mode t)
;; Turns out I didn't this all that helpful, and it slowed down init a good bit.


;; Super Save, ON! ...or not.. 😬
(use-package super-save
  :disabled
  ;; Here's why:
  ;;  - lsp-mode added function signature docs which use lv
  ;;  - lv momentarily moves focus away from the buffer which triggers super-save
  ;;  - prettier-js-mode makes saves trigger prettier which edits the current line
  ;;  - edits to the current line by prettier move point to beginning of line
  ;;  - point is now at beginning of line so I can't type args in the function I just typed
  ;;
  ;; this is infuriating, but lsp signatures are (1) cool and (2) almost impossible to disable,
  ;; therefore I'm just disabling super-save for now until lsp-mode/lv/super-save work out their problems
  ;; See also https://github.com/emacs-lsp/lsp-mode/issues/1322
  :config
  (super-save-mode t))


;; Asthetic alterations & theming
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(global-hl-line-mode t)
(show-paren-mode t)
(column-number-mode)
(global-eldoc-mode)
(add-to-list 'default-frame-alist
	     '(font . "Fira Code-12"))

(use-package ample-theme
  :demand t
  :config
  (load-theme 'ample t t)
  (load-theme 'myample-dark t t))

(use-package kaolin-themes
  :demand t
  :config
  (setq kaolin-themes-italic-comments t)
  (setq kaolin-themes-distinct-fringe t)
  (setq kaolin-themes-distinct-company-scrollbar t)
  (load-theme 'kaolin-breeze t t)
  (load-theme 'mykaolin-light t t))

(use-package smart-mode-line
  :after (ample-theme kaolin-themes)
  :demand t
  :config
  (defun godark ()
    (interactive)
    (disable-theme 'mykaolin-light)
    (disable-theme 'kaolin-breeze)
    (enable-theme 'ample)
    (enable-theme 'myample-dark)
    (sml/setup))
  (defun golight ()
    (interactive)
    (disable-theme 'myample-dark)
    (disable-theme 'ample)
    (enable-theme 'kaolin-breeze)
    (enable-theme 'mykaolin-light)
    (sml/setup))
  (setq rm-blacklist (format "^ \\(%s\\)$"
			     (mapconcat #'identity
					'("Git.*" "Projectile.*" "ARev" "company" "h-i-g" "counsel" "ivy" "yas" "SP" "WK" "super-save" "ElDoc" "Rbow" "Undo-Tree" ",")
					"\\|")))
  (setup-sml-secrets)
  ;; The below sets the default to light, but iTerm's hook for switching between dark/light
  ;; will also switch Emacs themes if the Emacs server is running!
  ;; FIXME: Need to call both in this order because... of a glitch somewhere... I guess
  (godark)
  (golight))

(use-package fira-code-mode
  :ensure nil
  :load-path "git-lisp/fira-code-mode"
  :custom (fira-code-mode-disabled-ligatures '("www" "[]" "#{" "#(" "#_" "#_(" "x"))
  :hook prog-mode)

(use-package rainbow-mode
  :hook (prog-mode text-mode))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package highlight-indentation
  :after smart-mode-line
  :hook (yaml-mode . highlight-indentation-mode)
  :config
  (highlight-indentation-current-column-mode))

(use-package fireplace
  :commands fireplace)


;; Binding and app-control related packages
(use-package which-key
  :config
  (which-key-mode))

(use-package hercules
  :after which-key)

(use-package dash-at-point
  :if (eq system-type 'darwin)
  :ensure-system-package ("/Applications/Dash.app" . "brew cask install dash")
  :config
  (let ((docsets (concat (alist-get 'python-mode dash-at-point-mode-alist) ",boto3,fnc,pyrsistent,toolz")))
    (add-to-list 'dash-at-point-mode-alist `(python-mode . ,docsets)))
  (add-to-list 'dash-at-point-mode-alist '(rjsx-mode . "javascript,nodejs,lodash,moment,jest,react,awsjs,css"))
  (global-set-key (kbd "s-c") nil)
  (global-set-key (kbd "s-c s-d") #'dash-at-point))

(use-package spotify
  :load-path "git-lisp/spotify.el/"
  :custom
  (spotify-transport (if (eq system-type 'darwin) 'apple 'connect))
  (spotify-player-status-format "[%p %a | %t]")
  (spotify-player-status-playing-text "▶")
  (spotify-player-status-paused-text "▌▌")
  (spotify-player-status-stopped-text "■")
  :init (require 'cl)
  :bind-keymap ("M-m" . spotify-command-map)
  :config
  (global-spotify-remote-mode))


;; Region/selection
(use-package expand-region
  :bind ("C-=" . er/expand-region))

(delete-selection-mode)


;; Undo and Kill enhancements
(use-package undo-tree
  :demand t
  :bind ("s-/" . undo-tree-visualize)
  :config
  (global-undo-tree-mode))


;; Movement enhancements & multiple cursors
(global-subword-mode)

(use-package avy
  :custom
  (avy-single-candidate-jump nil)
  (avy-timeout-seconds 0.37)
  :bind (("M-l" . avy-goto-line)
	 ("M-c" . avy-goto-word-1)
	 ("M-s" . avy-goto-char-timer)))


(defvar mc-place (lambda () (message "Entering multiple-cursors placement state")))
(use-package multiple-cursors
  :demand t
  :bind (("s-p" . mc/mark-previous-like-this)
	 ("s-n" . mc/mark-next-like-this)
	 ("s-l" . mc/skip-to-previous-like-this)
	 ("s-m" . mc/skip-to-next-like-this)
	 ("s-d" . mc/mark-next-word-like-this)
	 ("s-r" . mc/mark-all-dwim)
	 (:map mc/keymap
          ("<return>" . nil)
	  ("s-s" . mc/sort-regions)))
  :config
  (defvar mc-placement-map (make-sparse-keymap))
  (defvar mc-place-stop (lambda ()))
  (bind-keys :map mc-placement-map
	     ("p" . mc/mark-previous-like-this)
	     ("n" . mc/mark-next-like-this)
	     ("P" . mc/skip-to-previous-like-this)
	     ("N" . mc/skip-to-next-like-this)
	     ("d" . mc/mark-next-word-like-this)
	     ("D" . mc/mark-previous-word-like-this)
	     ("r" . mc/mark-all-dwim)
	     ("=" . er/expand-region)
	     ("<return>" . mc-place-stop))
  (hercules-def
   :toggle-funs #'mc-place
   :hide-funs #'mc-place-stop
   :keymap 'mc-placement-map
   :transient t)
  (global-set-key (kbd "H-m") #'mc-place))


;; Org mode
(use-package org
  :custom
  (org-export-backends '(ascii html icalendar latex odt md))
  (org-pretty-entities t)
  (org-capture-templates '(("c" "Simple code link template" entry
			    (file "~/Documents/notes.org")
			    "** %f: %a" :immediate-finish t)))
  (org-default-notes-file "~/Documents/notes.org")
  :config
  (global-set-key (kbd "H-o H-c") #'org-capture))


;; Verb & HTTP request helpers
(use-package verb
  :after org
  :config (define-key org-mode-map (kbd "C-c C-r") verb-mode-prefix-map))


;; Smartparens
(use-package smartparens
  :demand t
  :custom (sp-ignore-modes-list '(minibuffer-inactive-mode))
  :bind (:map smartparens-mode-map
	 ("C-k" . sp-kill-hybrid-sexp)
	 ("M-[" . sp-backward-slurp-sexp)
	 ("s-[" . sp-backward-barf-sexp)
	 ("M-]" . sp-slurp-hybrid-sexp)
	 ("s-]" . sp-forward-barf-sexp)
	 ("C-M-w" . sp-copy-sexp)
	 ("C-M-u" . sp-backward-up-sexp)
	 ("C-M-d" . sp-down-sexp)
	 ("C-M-f". sp-forward-sexp)
	 ("C-M-b". sp-backward-sexp)
	 ("C-M-<backspace>" . sp-backward-kill-sexp)
	 ("C-M-t" . sp-transpose-sexp)
	 ("C-M-r" . sp-rewrap-sexp)
	 :map emacs-lisp-mode-map
	 ("M-i" . sp-indent-defun))
  :config
  (require 'smartparens-config)
  (smartparens-global-mode t)
;;  (sp-local-pair 'web-mode "{" nil :actions '(:rem insert))
  )


;; Snippets
(use-package yasnippet
  :hook (prog-mode . yas-global-mode))

(use-package yasnippet-snippets
  :after yasnippet)


;; Company (autocomplete)
(use-package company
  :demand t
  :bind ("TAB" . company-indent-or-complete-common)
  :config
  (setq company-tooltip-align-annotations t)
  (global-company-mode t))

(use-package company-quickhelp
  :after company
  :config
  (company-quickhelp-mode))

(use-package company-emoji
  :after company
  :config
  (add-to-list 'company-backends 'company-emoji))


;; Ivy, Swiper, and Counsel
(use-package ivy
  :demand t
  :bind (:map ivy-minibuffer-map
         ("M-o" . nil)
         ("M-h" . ivy-dispatching-done))
  :config
  (ivy-mode t)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t))

(use-package swiper
  :after ivy
  :bind ("C-s" . swiper))

(use-package counsel
  :after ivy
  :demand t
  :custom (counsel-grep-base-command "rg -i -M 120 --no-heading --line-number '%s' %s")
  :bind (("C-s" . counsel-grep-or-swiper)
	 ("s-g" . counsel-rg))
  :config
  (counsel-mode t))


;; Projectile
(use-package projectile
  :bind ("s-f" . projectile-commander)
  :config
  (projectile-mode 1)
  (setq projectile-completion-system 'ivy)
  (add-to-list 'projectile-project-root-files-bottom-up "pubspec.yaml")
  (add-to-list 'projectile-project-root-files-bottom-up "BUILD"))


;; Git, Magit, and Forge
(use-package magit
  :custom (magit-diff-use-overlays nil)
  :bind ("C-x g" . magit-status))

(use-package forge
  :after magit)

(use-package git-gutter
  :custom
  (git-gutter:ask-p nil)
  :config
  (global-git-gutter-mode +1)
  (defvar git-gutter-map (make-sparse-keymap))
  (defvar git-gutter-stop (lambda ()))
  (bind-keys :map git-gutter-map
	     ("n" . git-gutter:next-hunk)
	     ("p" . git-gutter:previous-hunk)
	     ("s" . git-gutter:stage-hunk)
	     ("v" . git-gutter:revert-hunk)
	     ("d" . git-gutter:popup-hunk)
	     ("SPC" . git-gutter:mark-hunk)
	     ("q" . git-gutter-stop))
  (hercules-def
   :show-funs #'git-gutter:statistic
   :hide-funs #'git-gutter-stop
   :keymap 'git-gutter-map)
  (global-set-key (kbd "H-g") #'git-gutter:statistic))


;; Syntax checking + LSP
(use-package flycheck
  :hook ((prog-mode . flycheck-mode)
	 (json-mode . (lambda () (flycheck-mode -1))))
  :config
  (hercules-def
   :show-funs #'flycheck-list-errors
   :keymap 'flycheck-command-map
   :blacklist-funs '(flycheck-version flycheck-manual)
   :transient t)
  (global-set-key (kbd "H-c") (lambda () (interactive)
				    (flycheck-list-errors)
				    (enlarge-window 10))))

(use-package lsp-mode
  :commands lsp
  :hook ((shell-script-mode css-mode html-mode java-mode ruby-mode go-mode dart-mode rust-mode rjsx-mode swift-mode) . lsp)
  :custom
  (lsp-auto-guess-root t)
  (lsp-clients-flow-server (let* ((root
				   (locate-dominating-file
				    (or (buffer-file-name) default-directory)
				    "node_modules"))
				  (flow
				   (and root (expand-file-name "node_modules/.bin/flow" root))))
			     (if (and flow (file-executable-p flow))
				 flow "flow")))
  (lsp-clients-go-format-tool "gofmt")
  (lsp-enable-snippet nil)
  (lsp-keep-workspace-alive nil)
  (lsp-prefer-flymake nil))

(use-package company-lsp
  :after (lsp-mode company)
  :custom (company-lsp-enable-snippet nil)
  :config
  (push 'company-lsp company-backends))

(use-package lsp-java
  :after lsp-mode)

(use-package lsp-sourcekit
  :disabled ;; Not writing Swift at the moment, haven't gotten around to installing the toolchain again
  :after lsp-mode
  :config
  (setq lsp-sourcekit-executable
	(expand-file-name "/Library/Developer/Toolchains/swift-latest.xctoolchain/usr/bin/sourcekit-lsp")))

(use-package lsp-ui
  :hook lsp-mode-hook
  :commands lsp-ui-mode
  :custom
  (lsp-ui-doc-enable nil)
  (lsp-ui-flycheck-enable t)
  (lsp-ui-flycheck-live-reporting nil)
  (lsp-ui-peek-enable nil)
  (lsp-ui-sideline-enable t)
  (lsp-ui-sideline-ignore-duplicate t)
  (lsp-ui-sideline-show-code-actions nil)
  (lsp-ui-sideline-show-diagnostics t)
  (lsp-ui-sideline-show-hover nil)
  (lsp-ui-sideline-show-symbol nil)
  :custom-face
  (lsp-ui-sideline-global ((t nil))))


;; DAP & Debugging
(use-package dap-mode
  :hook ((lsp-mode . dap-mode)
	 (python-mode . (lambda () (require 'dap-python) (register-dap-templates-python)))
	 (go-mode . (lambda () (require 'dap-go) (dap-go-setup)))
	 (rjsx-mode . (lambda () (require 'dap-node) (dap-node-setup) (register-dap-templates-node))))
  :config
  (dap-ui-mode)
  (let (quit)
    (defvar my-dap-map (make-sparse-keymap))
    (bind-keys :map my-dap-map
	       ("C-w b" . dap-ui-breakpoints-list)
	       ("C-w i" . dap-ui-inspect)
	       ("C-w l" . dap-ui-locals)
	       ("C-w s" . dap-ui-sessions)
	       ("D" . dap-disconnect)
	       ("b" . dap-breakpoint-toggle)
	       ("c" . dap-continue)
	       ("e" . dap-eval)
	       ("i" . dap-step-in)
	       ("l" . dap-go-to-output-buffer)
	       ("n" . dap-next)
	       ("o" . dap-step-out)
	       ("q" . quit)
	       ("r" . dap-restart-frame)
	       ("s" . dap-switch-stack-frame))
  (hercules-def
   :show-funs '(dap-debug dap-debug-last my-dap-prefix)
   :hide-funs '(dap-disconnect quit dap-eval dap-switch-stack-frame)
   :keymap 'my-dap-map)
  (global-set-key (kbd "H-b") #'my-dap-prefix)))


;; Clojure & Cider
(use-package cider
  :defer t
  :after smartparens
  :custom (cider-default-cljs-repl (quote figwheel))
  :bind (:map cider-mode-map
         ("M-i" . sp-indent-defun))
  :config
  (cider-repl-toggle-pretty-printing))

(use-package clojure-mode
  :mode ("\\.clj\\'" "\\.cljs\\'" "\\.edn\\'")
  :config
  (define-clojure-indent
    (defroutes 'defun)
    (GET 2)
    (POST 2)
    (PUT 2)
    (DELETE 2)
    (HEAD 2)
    (ANY 2)
    (OPTIONS 2)
    (PATCH 2)
    (rfn 2)
    (let-routes 1)
    (context 2)))


;; Python
(use-package elpy
  :defer t
  :after flycheck
  :bind (:map elpy-mode-map
	      ("C-M-f" . python-nav-forward-sexp-safe)
	      ("C-M-n" . elpy-nav-forward-block)
	      ("C-M-p" . elpy-nav-backward-block)
	      ("C-M-d" . elpy-nav-forward-indent)
	      ("C-M-u" . elpy-nav-backward-indent)
	      ("M-i" . elpy-format-code)
	      ("C-c M-j" . elpy-shell-switch-to-shell))
  :init
  (advice-add 'python-mode :before 'elpy-enable)
  :config
  (setq elpy-eldoc-show-current-function nil)
  ;; Bugged on macOS, too lazy to fix, would probably require https://pypi.org/project/gnureadline/
  (when (eq system-type 'darwin) (setq python-shell-completion-native-enable nil))
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook (lambda () (add-hook 'before-save-hook 'elpy-format-code nil 'local))))


;; Markdown
(use-package markdown-mode
  :commands markdown-mode
  :bind (:map markdown-mode-map
         ("M-n" . nil)
         ("M-p" . nil)))


;; Graphviz
(use-package graphviz-dot-mode)


;; Go
(use-package go-mode
;;  :hook (before-save . gofmt-before-save)
  :bind (:map go-mode-map
	 ("M-." . godef-jump)
	 ("M-," . pop-tag-mark)
	 ("M-i" . gofmt)))

(use-package go-projectile
  :after (go-mode projectile-mode))

(use-package go-guru
  :after go-mode
  :hook (go-mode . go-guru-hl-identifier-mode))

(use-package company-go
  :after go-mode
  :hook go-mode)

(use-package go-scratch
  :after go-mode
  :hook go-mode)


;; Dart & Flutter
(use-package dart-mode
  :bind (:map dart-mode-map
	 ("M-i" . dart-format)
	 ("M-." . lsp-goto-implementation))
  :config
  (setq dart-format-on-save t))

(use-package flutter
  :after dart-mode
  :bind (:map dart-mode-map
         ("C-c C-k" . flutter-run-or-hot-reload)))


;; Rust
(use-package rust-mode
  :bind (:map rust-mode-map
         ("M-." . lsp-goto-implementation)
	 ("M-i" . rust-format-buffer))
  :config
  (setq rust-format-on-save t))

(use-package racer
  :after rust-mode
  :hook (rust-mode . racer-mode))

(use-package cargo
  :after rust-mode
  :hook (rust-mode . cargo-minor-mode))


;; Swift
(use-package swift-mode)

(use-package swift-helpful
  :after swift-mode)


;; Groovy / .gradle
(use-package groovy-mode
  :defer)


;; Web modes
(use-package css-mode
  :after prettier-js
  :bind (:map css-mode-map
         ("M-i" . prettier-js)
	 ("M-." . lsp-goto-implementation)))

(use-package web-mode
  :after prettier-js
  :mode ("\\.ejs\\'" "\\.erb\\'" "\\.mustache\\'")
  :bind (:map web-mode-map
	 ("M-i" . prettier-js))
  :config
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2))

(use-package jade-mode
  :mode ("\\.jade\\'" "\\.pug\\'"))

(use-package php-mode
  :mode ("\\.\\php\\'" "\\.\\phtml\\'"))

(use-package company-php
  :after (:any php-mode web-mode)
  :hook (php-mode web-mode))

(use-package ruby-mode
  :ensure nil
  :bind (:map ruby-mode-map
	 ("M-." . lsp-goto-implementation)))


;; JavaScript / Node.js / React (JSX)
(use-package add-node-modules-path
  :commands add-node-modules-path)

(use-package rjsx-mode
  :custom (js-indent-level 2)
  :after prettier-js
  :mode "\\.jsx?\\'"
;;  :interpreter ("nodejs" "node")
  :bind (:map rjsx-mode-map
         ("M-i" . prettier-js)
         ("M-." . xref-find-definitions))
  :config
  (add-node-modules-path))

(use-package json-mode
  :custom (json-reformat:indent-width 2)
  :after prettier-js
  :mode "\\.json\\'"
  :bind (:map json-mode-map
	 ("M-i" . prettier-js)))

(use-package prettier-js
  :demand t
  :ensure-system-package (prettier . "npm i -g prettier")
;;  :commands (prettier-js prettier-js-mode)
  :hook ((rjsx-mode yaml-mode css-mode json-mode web-mode) . prettier-js-mode))

(use-package nodejs-repl
  :after rjsx-mode
  :commands nodejs-repl
  :bind (:map rjsx-mode-map
	      ("C-c M-j" . nodejs-repl)
	      ("C-x C-e" . nodejs-repl-send-last-expression)
	      ("C-x C-r" . nodejs-repl-send-region)
	      ("C-c C-k" . nodejs-repl-load-file)))


;; YAML
(use-package yaml-mode
  :after prettier-js
  :bind (:map yaml-mode-map
	      ("M-i" . prettier-js)))


;; Docker
(use-package docker
  :bind ("C-x d" . docker))

(use-package dockerfile-mode
  :mode "Dockerfile\\'")

(use-package docker-compose-mode
  :mode "docker-compose[^/]*\\.yml\\'")


;; Java
(use-package java-mode
  :ensure nil
  :bind (:map java-mode-map
	 ("M-." . lsp-goto-implementation)))


;; Shell-related stuff
(use-package sh-mode
  :ensure nil
  :bind (:map sh-mode-map
	 ("M-." . lsp-goto-implementation)))

(setq explicit-shell-file-name "bash")
(add-hook 'shell-mode-hook (lambda ()
			     (dirtrack-mode)
			     ;; Teach *shell* how to tell what directory we're in by reading the prompt
			     (setq dirtrack-list '("^[0-9:]\\{5\\} \\(.+?\\) \\$ " 1))))


;; Window stuff
(defun enlarge-window-15 ()
  "Enlarge the window by 15 at a time."
  (interactive)
  (enlarge-window 15))

(defun shrink-window-15 ()
  "Shrink the window by 15 at a time."
  (interactive)
  (shrink-window 15))

(defun cool-enlarge-window (height)
  "Prompt for a factor by which to enlarge the window.  HEIGHT represents how many points to enlarge."
  (interactive "nBy: ")
  (enlarge-window height))

(defun init-project (file &optional file2)
  "Initialize my buffers for the project specified by FILE.
FILE represents the project root file to open.
If provided, FILE2 will be opened in the right-side buffer."
  (interactive)
  (find-file file)
  (split-window-right)
  (other-window 1)
  (when file2
    (find-file file2))
  (split-window-below)
  (enlarge-window 15)
  (other-window 2)
  (magit-status))

;; init-emacs
(global-set-key (kbd "H-i e") (lambda () (interactive) (init-project "~/Documents/emacs-config/init.el" "~/.emacs.d/init.el")))

(defun init-dap ()
  "Initialize the window setup for DAP.
Expects the windows to be preconfigured as with `init-project'
with focus residing in the leftmost window."
  (interactive)
  (dap-ui-repl)
  (other-window 1)
  (dap-ui-breakpoints-list)
  (dap-ui-sessions)
  (dap-ui-locals))

(use-package ace-window
  :bind (("M-o" . ace-window)
	 ("s-o" . ace-swap-window))
  :custom-face
  (aw-leading-char-face ((t . (:height 1.1 :weight bold :foreground "#e361c3")))))

(use-package eyebrowse
  :demand t
  :custom (eyebrowse-keymap-prefix (kbd "s-w"))
  :bind (("H-1" . eyebrowse-switch-to-window-config-1)
	 ("H-2" . eyebrowse-switch-to-window-config-2)
	 ("H-3" . eyebrowse-switch-to-window-config-3))
  :config (eyebrowse-mode t))

(let (quit)
  (defvar my-window-map (make-sparse-keymap))
  (bind-keys :map my-window-map
	     ("r" . enlarge-window-15)
	     ("s" . shrink-window-15)
	     ("e" . cool-enlarge-window)
	     ("g" . balance-windows)
	     ("n" . shrink-window)
	     ("p" . enlarge-window)
	     ("f" . enlarge-window-horizontally)
	     ("b" . shrink-window-horizontally)
	     ("d" . init-dap)
	     ("q" . quit)
	     ("<return>" . quit))
  (hercules-def
   :toggle-funs #'my-window-prefix
   :hide-funs '(cool-enlarge-window balance-windows init-dap quit)
   :keymap 'my-window-map
   :transient t)
  (global-set-key (kbd "H-w") #'my-window-prefix))


;; Ediff customizations
(defun ediff-copy-both-to-C ()
  "Copy both variants A and B to the ediff buffer C."
  (interactive)
  (ediff-copy-diff ediff-current-difference nil 'C nil
                   (concat
                    (ediff-get-region-contents ediff-current-difference 'A ediff-control-buffer)
                    (ediff-get-region-contents ediff-current-difference 'B ediff-control-buffer))))

(add-hook 'ediff-keymap-setup-hook (lambda () (define-key ediff-mode-map "d" 'ediff-copy-both-to-C)))
(add-hook 'ediff-before-setup-hook #'eyebrowse-create-window-config)
(add-hook 'ediff-suspend-hook #'eyebrowse-close-window-config)
(add-hook 'ediff-quit-hook #'eyebrowse-close-window-config)


;; Other custom functions
(defun prompt-for-file ()
  "Prompt for a file and return its contents."
  (with-temp-buffer
    (insert-file-contents (read-file-name "Read env from file: "))
    (buffer-string)))

(defun setenv-from-file (arg)
  "Read the contents of a .env file into `setenv'.
If prefixed with one \\[universal-argument] as ARG, uses the current buffer instead of prompting for a file."
  (interactive "p")
  (let ((the-text (if (eq arg 4)
		      (buffer-string)
		    (prompt-for-file))))
    (dolist (line (split-string the-text "\n" t))
      (-let (((k v) (split-string (replace-regexp-in-string "^export " "" line) "=" t)))
	(setenv k v)))))


;; macOS customizations
(when (eq system-type 'darwin)
  ;; Mac modifier key rebindings
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier 'super)
  (setq mac-right-control-modifier 'hyper)

  ;; Fix emoji support
  (defun --provide-emoji-font (frame)
    (set-fontset-font t 'symbol (font-spec :family "Apple Color Emoji") frame 'prepend))
  ;; For when Emacs is started in GUI mode:
  (--provide-emoji-font nil)
  ;; Hook for when a frame is created with emacsclient:
  (add-hook 'after-make-frame-functions #'--provide-emoji-font))

;; Linux customizations
(when (eq system-type 'gnu/linux)
  ;; Fix emoji support
  (defun --provide-emoji-font (frame)
    (set-fontset-font t 'symbol (font-spec :family "Noto Color Emoji") frame 'prepend))
  ;; For when Emacs is started in GUI mode:
  (--provide-emoji-font nil)
  ;; Hook for when a frame is created with emacsclient:
  (add-hook 'after-make-frame-functions #'--provide-emoji-font))
