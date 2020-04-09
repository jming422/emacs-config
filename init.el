;;; init.el --- Initialization file for Emacs
;;; Commentary:
;; My custom Emacs startup file

;;; Code:

;; Autogenerated stuff
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cursor-type 'bar)
 '(custom-enabled-themes nil)
 '(custom-safe-themes
   '("99ea831ca79a916f1bd789de366b639d09811501e8c092c85b2cb7d697777f93" "d5f8099d98174116cba9912fe2a0c3196a7cd405d12fa6b9375c55fc510988b5" "c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" default))
 '(ediff-window-setup-function 'ediff-setup-windows-plain)
 '(package-selected-packages
   '(dashboard wttrin fira-code-mode doom-modeline doom-themes all-the-icons tide typescript-mode vterm all-the-icons-dired all-the-icons-ivy-rich ivy-rich package-lint exwm use-package-ensure-system-package verb forge undo-tree company-emoji lsp-sourcekit swift-helpful swift-mode graphviz-dot-mode kaolin-themes highlight-indentation cider counsel dap-mode json-mode markdown-mode smartparens eyebrowse hercules php-mode clojure-mode git-gutter dash-at-point elpy smart-mode-line yasnippet yasnippet-snippets company-go groovy-mode use-package rjsx-mode web-mode lsp-ui company-lsp lsp-java lsp-mode flycheck company-quickhelp dart-mode flutter yaml-mode rainbow-mode jade-mode company-php prettier-js add-node-modules-path nodejs-repl cargo racer rust-mode go-guru go-mode go-projectile go-scratch docker-compose-mode docker dockerfile-mode exec-path-from-shell rainbow-delimiters expand-region fireplace ample-theme which-key ace-window projectile avy multiple-cursors magit company super-save swiper ivy))
 '(safe-local-variable-values '((encoding . utf-8))))
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
(setq auth-sources '("~/.authinfo.gpg"))
(load (locate-user-emacs-file "mysecrets.el") t)


;; Generic global keybindings
(global-set-key (kbd "C-§") #'ignore)
(global-set-key (kbd "C-`") #'ignore)
(global-set-key (kbd "<escape>") #'keyboard-quit)
(global-set-key (kbd "M-p") #'backward-paragraph)
(global-set-key (kbd "M-n") #'forward-paragraph)
(global-set-key (kbd "H-u") #'upcase-char)
(global-set-key (kbd "H-d") #'downcase-dwim)
(global-set-key (kbd "s-s") #'sort-lines)
(global-set-key (kbd "s-%") #'query-replace-regexp)
(global-set-key (kbd "s-.") #'xref-find-definitions-other-window)
(global-set-key (kbd "H-SPC") #'just-one-space)
(global-set-key (kbd "M-j") (lambda () (interactive)
			      (exchange-point-and-mark)
			      (deactivate-mark)))
(global-set-key (kbd "C-x C-p") #'list-processes)


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
  (super-save-mode))


;; Asthetic alterations & theming
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(show-paren-mode)
(blink-cursor-mode)
(column-number-mode)
(global-eldoc-mode)
(add-to-list 'default-frame-alist
	     '(font . "Fira Code-12"))

(customize-set-variable 'display-time-default-load-average nil)
(customize-set-variable 'display-time-day-and-date t)
(display-time)

(use-package doom-themes
  :demand t
  :config
  (defun godark ()
    (interactive)
    (disable-theme 'doom-one-light)
    (load-theme 'doom-nova t)
    (doom-themes-set-faces
      'doom-nova
      '(mc/cursor-bar-face :height 1 :background (doom-darken (doom-color 'dark-cyan) 0.3) :foreground (doom-lighten (doom-color 'cyan) 0.2))
      '(mode-line-inactive :background (doom-lighten (doom-color 'modeline-bg-alt) 0.05) :foreground (doom-lighten (doom-color 'modeline-fg-alt) 0.05))
      '(sp-pair-overlay-face :background (doom-darken (doom-color 'dark-cyan) 0.15))
      '(vterm-color-black :background (doom-lighten (doom-color 'base2) 0.6) :foreground (doom-color 'base2)))
    (enable-theme 'doom-nova))

  (defun golight ()
    (interactive)
    (disable-theme 'doom-nova)
    (load-theme 'doom-one-light t)
    (doom-themes-set-faces
      'doom-one-light
      '(swiper-line-face :background (doom-lighten (doom-color 'dark-blue) 0.4) :foreground 'unspecified)
      '(mc/cursor-bar-face :height 1 :background (doom-lighten (doom-color 'dark-blue) 0.3) :foreground (doom-darken (doom-color 'blue) 0.2))
      '(highlight-indentation-face :background (doom-color 'base0))
      '(highlight-indentation-current-column-face :background (doom-color 'base2))
      '(company-tooltip :inherit 'tooltip)
      '(markdown-code-face :background (doom-lighten (doom-color 'cyan) 0.95) :extend t)
      '(vterm-color-black :background (doom-darken (doom-color 'base2) 0.5) :foreground (doom-color 'base2)))
    (enable-theme 'doom-one-light))

  (golight))

(use-package doom-modeline
  :after doom-themes
  :init (doom-modeline-mode)
  :custom
  (doom-modeline-icon t)
  (doom-modeline-env-enable-python nil)
  (doom-modeline-buffer-file-name-style 'truncate-with-project))

(use-package fira-code-mode
  ;; Requires installing Fira Code Symbol font first
  :custom (fira-code-mode-disabled-ligatures '("www" "[]" "#{" "#(" "#_" "#_(" "x"))
  :hook prog-mode)

(use-package rainbow-mode
  :commands rainbow-mode)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package highlight-indentation
  :hook ((yaml-mode . highlight-indentation-mode)
	 (yaml-mode . highlight-indentation-current-column-mode)))

(use-package fireplace
  :commands fireplace)

(use-package all-the-icons)
;; After install, run M-x all-the-icons-install-fonts

(use-package all-the-icons-dired
  :after all-the-icons
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package dashboard
  :if (daemonp)
  :after projectile
  :custom
  (dashboard-center-content t)
  (dashboard-set-heading-icons t)
  (dashboard-set-file-icons t)
  (dashboard-startup-banner 'logo)
  (dashboard-items '((projects . 5)
		     (recents . 5)
		     (bookmarks . 5)))
  (dashboard-footer-messages '("Calibrating flux capacitors..."
			       "Circling back..."
			       "Closing the loop..."
			       "Comparing apples to apples..."
			       "Constructing additional pylons..."
			       "Delivering the deliverables..."
			       "Doing business-y business..."
			       "Doing things a little differently around here..."
			       "Finding the 812th Korok seed..."
			       "Free as free speech, free as free beer"
			       "Happy coding!"
			       "Iterating on it..."
			       "Jumping to hyperspace..."
			       "Looking for the net net..."
			       "Moving forward..."
			       "Moving the needle..."
			       "Obtaining the high ground..."
			       "Picking the low hanging fruit..."
			       "Putting a pin in it..."
			       "Putting that in the parking lot..."
			       "Quantifying the execution risk..."
			       "Reticulating splines..."
			       "S Y N E R G I Z I N G..."
			       "S Y N E R G Y"
			       "Seeing where the data takes us..."
			       "Solving impossible problems..."
			       "Strategizing opportunities for cross functional synergies..."
			       "The one true editor, Emacs!"
			       "Thinking outside the box..."))
  :config
  (dashboard-setup-startup-hook)
  (setq initial-buffer-choice (lambda () (get-buffer "*dashboard*"))))

(use-package wttrin
  :commands (wttrin wttrin-query)
  :custom
  (wttrin-default-cities `(,(or my-city-name "Los Angeles")))
  (wttrin-default-accept-language '("Accept-Language" . "en-US,en;q=0.5")))


;; Binding and app-control related packages
(use-package which-key
  :demand t
  :config
  (which-key-mode))

(use-package hercules
  :after which-key)

(use-package dash-at-point
  :if (eq system-type 'darwin)
  :ensure-system-package ("/Applications/Dash.app" . "brew cask install dash")
  :config
  (let ((docsets (concat (alist-get 'python-mode dash-at-point-mode-alist) ",boto3,fnc,pyrsistent,toolz,psql")))
    (add-to-list 'dash-at-point-mode-alist `(python-mode . ,docsets)))
  (add-to-list 'dash-at-point-mode-alist '(rjsx-mode . "javascript,nodejs,lodash,moment,jest,react,awsjs,psql,css"))
  (global-set-key (kbd "s-c") nil)
  (global-set-key (kbd "s-c s-d") #'dash-at-point))

(use-package spotify
  :load-path "git-lisp/spotify.el/"
  :custom
  (spotify-transport (if (eq system-type 'darwin) 'apple 'connect))
  (spotify-player-status-format "♪%p♪ ")
  (spotify-player-status-playing-text "▶")
  (spotify-player-status-paused-text "▌▌")
  (spotify-player-status-stopped-text "■")
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


(defun mc-place ()
  "Function for the mc hercules entry point."
  (interactive)
  (message "Entering multiple-cursors placement state"))

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
  (let (quit)
    (bind-keys :map mc-placement-map
	       ("p" . mc/mark-previous-like-this)
	       ("n" . mc/mark-next-like-this)
	       ("P" . mc/skip-to-previous-like-this)
	       ("N" . mc/skip-to-next-like-this)
	       ("d" . mc/mark-next-word-like-this)
	       ("D" . mc/mark-previous-word-like-this)
	       ("r" . mc/mark-all-dwim)
	       ("=" . er/expand-region)
	       ("<return>" . quit)
	       ("q" . quit))
    (hercules-def
     :toggle-funs #'mc-place
     :hide-funs 'quit
     :keymap 'mc-placement-map
     :transient t)
    (global-set-key (kbd "H-m") #'mc-place)))


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
;;  :config (define-key org-mode-map (kbd "C-c C-r") verb-mode-prefix-map)
  )


;; Smartparens
(use-package smartparens
  :demand t
  :custom (sp-ignore-modes-list '(minibuffer-inactive-mode vterm-mode))
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
  (smartparens-global-mode)
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
  :custom (company-idle-delay 0.2)
  :bind ("TAB" . company-indent-or-complete-common)
  :config
  (setq company-tooltip-align-annotations t)
  (global-company-mode))

(use-package company-quickhelp
  :after (company doom-themes)
  :custom
  (company-quickhelp-color-foreground (doom-color 'fg))
  (company-quickhelp-color-background (doom-color 'bg))
  :config
  (company-quickhelp-mode))

(use-package company-emoji
  :after company
  :config
  (advice-add #'company-emoji-list-create :filter-return (lambda (l) (cons #(":green_circle:" 0 1 (:unicode "🟢")) l)))
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
  :demand t)

(use-package counsel
  :after ivy
  :demand t
  :ensure-system-package rg
  :custom (counsel-grep-base-command "rg -i -M 120 --no-heading --line-number %s %s")
  :bind (("C-s" . counsel-grep-or-swiper)
	 ("s-g" . counsel-rg))
  :config
  (counsel-mode t))

(use-package ivy-rich
  :after ivy
  :demand t
  :config
  (ivy-rich-mode)
  (setcdr (assq t ivy-format-functions-alist) #'ivy-format-function-line))

(use-package all-the-icons-ivy-rich
  :after (all-the-icons ivy-rich)
  :demand t
  :config
  (all-the-icons-ivy-rich-mode))


;; Projectile
(use-package projectile
  :demand t
  :bind ("s-f" . projectile-commander)
  :config
  (projectile-mode)
  (setq projectile-completion-system 'ivy)
  (add-to-list 'projectile-project-root-files-bottom-up "pubspec.yaml"))


;; Git, Magit, and Forge
(use-package magit
  :demand t
  :custom (magit-diff-use-overlays nil)
  :bind ("C-x g" . magit-status))

(use-package forge
  :after magit)

(use-package git-gutter
  :custom (git-gutter:ask-p nil)
  :config
  (global-git-gutter-mode)
  (defvar git-gutter-map (make-sparse-keymap))
  (let (quit)
    (bind-keys :map git-gutter-map
	       ("n" . git-gutter:next-hunk)
	       ("p" . git-gutter:previous-hunk)
	       ("s" . git-gutter:stage-hunk)
	       ("v" . git-gutter:revert-hunk)
	       ("d" . git-gutter:popup-hunk)
	       ("SPC" . git-gutter:mark-hunk)
	       ("q" . quit))
    (hercules-def
     :show-funs #'git-gutter:statistic
     :hide-funs 'quit
     :keymap 'git-gutter-map)
    (global-set-key (kbd "H-g") #'git-gutter:statistic)))


;; Syntax checking + LSP
(use-package package-lint
  :commands package-lint-current-buffer
  :bind (:map emacs-lisp-mode-map
	      ("C-c C-k" . package-lint-current-buffer)))

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
  :bind (:map lsp-mode-map
	      ("M-r" . lsp-rename))
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
  (lsp-prefer-flymake nil)
  (lsp-flycheck-live-reporting nil))

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
  :hook (lsp-mode . lsp-ui-mode)
  :commands lsp-ui-mode
  :custom
  (lsp-ui-doc-enable nil)
  (lsp-ui-flycheck-enable t)
  (lsp-ui-peek-enable nil)
  (lsp-ui-sideline-enable t)
  (lsp-ui-sideline-ignore-duplicate t)
  (lsp-ui-sideline-show-code-actions nil)
  (lsp-ui-sideline-show-diagnostics t)
  (lsp-ui-sideline-show-hover nil)
  (lsp-ui-sideline-show-symbol nil)
  :custom-face (lsp-ui-sideline-global ((t nil)))
  :config
  (setq aw-ignored-buffers (delete 'treemacs-mode aw-ignored-buffers)))


;; DAP & Debugging
(use-package dap-mode
  :hook ((lsp-mode . dap-mode)
	 (python-mode . (lambda () (require 'dap-python)))
	 (go-mode . (lambda () (require 'dap-go) (dap-go-setup)))
	 (rjsx-mode . (lambda () (require 'dap-node) (dap-node-setup))))
  :config
  (register-dap-templates-node)
  (register-dap-templates-python)
  (dap-ui-mode)
  (let (quit)
    (defvar my-dap-map (make-sparse-keymap))
    (bind-keys :map my-dap-map
	       ("C-w b" . dap-ui-breakpoints-list)
	       ("C-w e" . dap-ui-expressions)
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
  :custom (cider-default-cljs-repl 'figwheel)
  :bind (:map cider-mode-map
              ("M-i" . cider-format-buffer)))


;; Python
(use-package elpy
  :defer t
  :after flycheck
  :init
  (advice-add 'python-mode :before 'elpy-enable)
  (defun pyvenv-toggle ()
    "Toggle pyvenv on or off."
    (interactive)
    (let ((f (if pyvenv-virtual-env
		 (lambda ()
		   (interactive)
		   (pyvenv-deactivate)
		   (message "Python virtual environment deactivated."))
	       #'pyvenv-activate)))
      (call-interactively f)))
  :bind (:map elpy-mode-map
	      ("C-M-f" . python-nav-forward-sexp-safe)
	      ("C-M-n" . elpy-nav-forward-block)
	      ("C-M-p" . elpy-nav-backward-block)
	      ("C-M-d" . elpy-nav-forward-indent)
	      ("C-M-u" . elpy-nav-backward-indent)
	      ("M-i" . elpy-format-code)
	      ("C-c M-j" . elpy-shell-switch-to-shell)
	      ("C-c C-v" . pyvenv-toggle)
	      ("M-r" . elpy-refactor-options))
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
(use-package graphviz-dot-mode
  :mode ("\\.dot\\'" "\\.gv\\'"))


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
  :after go-mode)

(use-package go-scratch
  :after go-mode
  :hook go-mode)


;; Dart & Flutter
(use-package dart-mode
  :mode ("\\.dart\\'")
  :bind (:map dart-mode-map
	 ("M-." . lsp-goto-implementation)))

(use-package flutter
  :after dart-mode
  :bind (:map dart-mode-map
         ("C-c C-k" . flutter-run-or-hot-reload)))


;; Rust
(use-package rust-mode
  :bind (:map rust-mode-map
         ("M-." . lsp-goto-implementation)
	 ("M-i" . rust-format-buffer))
  :custom (rust-format-on-save t))

(use-package racer
  :after rust-mode
  :hook (rust-mode . racer-mode))

(use-package cargo
  :after rust-mode
  :hook (rust-mode . cargo-minor-mode))


;; Swift
(use-package swift-mode
  :mode ("\\.swift\\'"))

(use-package swift-helpful
  :after swift-mode)


;; Groovy / .gradle
(use-package groovy-mode)


;; Web modes
(use-package prettier-js
  :demand t ;; Was getting some weird load order errors, and I use it all the time, so just load it always
  :ensure-system-package (prettier . "npm i -g prettier")
  :hook ((rjsx-mode yaml-mode css-mode json-mode typescript-mode) . prettier-js-mode))

(use-package css-mode
  :after prettier-js
  :bind (:map css-mode-map
         ("M-i" . prettier-js)
	 ("M-." . lsp-goto-implementation)))

(use-package web-mode
  :after prettier-js
  :mode ("\\.ejs\\'" "\\.erb\\'" "\\.mustache\\'" "\\.tsx\\'")
  :bind (:map web-mode-map
	      ("M-i" . prettier-js))
  :hook (web-mode . (lambda ()
		      (when (string-equal "tsx" (file-name-extension buffer-file-name))
			(prettier-js-mode)
			(tide-setup)
			(tide-hl-identifier-mode))))
  :config
  (flycheck-add-mode 'typescript-tslint 'web-mode)
  :custom
  (web-mode-markup-indent-offset 2)
  (web-mode-css-indent-offset 2)
  (web-mode-code-indent-offset 2))

(use-package jade-mode
  :mode ("\\.jade\\'" "\\.pug\\'"))

(use-package php-mode
  :mode ("\\.\\php\\'" "\\.\\phtml\\'"))

(use-package company-php
  :after php-mode)

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
  :mode ("\\.jsx?\\'")
;;  :interpreter ("nodejs" "node")
  :bind (:map rjsx-mode-map
         ("M-i" . prettier-js)
         ("M-." . xref-find-definitions))
  :config
  (add-node-modules-path))

(use-package json-mode
  :custom (json-reformat:indent-width 2)
  :after prettier-js
  :mode ("\\.json\\'")
  :bind (:map json-mode-map
	 ("M-i" . prettier-js)))

(use-package nodejs-repl
  :after rjsx-mode
  :commands nodejs-repl
  :bind (:map rjsx-mode-map
	      ("C-c M-j" . nodejs-repl)
	      ("C-x C-e" . nodejs-repl-send-last-expression)
	      ("C-x C-r" . nodejs-repl-send-region)
	      ("C-c C-k" . nodejs-repl-load-file)))


;; Typescript / Tide / TSX
(use-package typescript-mode
  :after prettier-js
  :bind (:map typescript-mode-map
	      ("M-i" . prettier-js))
  :custom (typescript-indent-level 2))

(use-package tide
  :after (typescript-mode company flycheck)
  :hook ((typescript-mode . tide-setup)
         (typescript-mode . tide-hl-identifier-mode)))


;; YAML
(use-package yaml-mode
  :after prettier-js
  :bind (:map yaml-mode-map
	      ("M-i" . prettier-js)))


;; Docker
(use-package docker
  :bind ("C-x d" . docker))

(use-package dockerfile-mode
  :mode ("Dockerfile\\'"))

(use-package docker-compose-mode
  :mode ("docker-compose[^/]*\\.yml\\'"))


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


;; vterm
(use-package vterm
  ;; If on macOS: brew install the following: libvterm, libtool
  :commands vterm
  :bind (:map vterm-mode-map
	      ("C-k" . vterm-send-C-k)))


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

(defun init-project (file &optional file2 third-window-shrink)
  "Initialize my buffers for the project specified by FILE.
FILE represents the project root file to open.
If provided, FILE2 will be opened in the right-side buffer.
If provided, THIRD-WINDOW-SHRINK can customize the amount by which the magit buffer is shrunk (defaults to 15)."
  (interactive)
  (delete-other-windows)
  (find-file file)
  (split-window-right)
  (other-window 1)
  (when file2
    (find-file file2))
  (split-window-below)
  (enlarge-window (or third-window-shrink 15))
  (other-window 2)
  (call-interactively #'magit-status))

(defun init-emacs ()
  "Initialize my buffers to edit my Emacs config."
  (interactive)
  (init-project (locate-user-emacs-file "init.el") (locate-user-emacs-file "git-lisp/fira-code-mode/fira-code-mode.el")))
(global-set-key (kbd "H-i e") #'init-emacs)

(defun init-rust ()
  "Initialize my buffers to my Rust learning projects."
  (interactive)
  (let ((proj-loc "~/Documents/zust"))
    (init-project (concat proj-loc "/src/lib.rs") (concat proj-loc "/Cargo.toml"))))
(global-set-key (kbd "H-i r") #'init-rust)

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
  :custom-face (aw-leading-char-face ((t . (:height 1.1 :weight bold :foreground "#e361c3")))))

(use-package eyebrowse
  :demand t
  :custom (eyebrowse-keymap-prefix (kbd "s-e"))
  :bind (("H-1" . eyebrowse-switch-to-window-config-1)
	 ("H-2" . eyebrowse-switch-to-window-config-2)
	 ("H-3" . eyebrowse-switch-to-window-config-3)
	 ("H-4" . eyebrowse-switch-to-window-config-4))
  :config
  (eyebrowse-mode))

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

(add-hook 'ediff-keymap-setup-hook (lambda () (define-key ediff-mode-map "d" #'ediff-copy-both-to-C)))
(add-hook 'ediff-before-setup-hook #'eyebrowse-create-window-config)
;; (add-hook 'ediff-suspend-hook #'eyebrowse-close-window-config)
;; (add-hook 'ediff-quit-hook #'eyebrowse-close-window-config)
;; (add-hook 'ediff-cleanup-hook #'eyebrowse-close-window-config)


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


;; Fixes for emoji support
(defun --provide-emoji-font (frame)
  "Fixes emoji font loading in FRAME."
  (let ((emoji-font (if (eq system-type 'darwin)
			"Apple Color Emoji"
		      "Noto Color Emoji")))
    (set-fontset-font t 'symbol (font-spec :family emoji-font) frame 'prepend)))
;; For when Emacs is started in GUI mode:
(--provide-emoji-font nil)
;; Hook for when a frame is created with emacsclient:
(add-hook 'after-make-frame-functions #'--provide-emoji-font)


;; macOS customizations
(when (eq system-type 'darwin)
  ;; Mac modifier key rebindings
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier 'super)
  (setq mac-right-control-modifier 'hyper)
  (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
  (add-to-list 'default-frame-alist '(ns-appearance . light)))


;; Linux customizations
(use-package exwm
  :if (eq system-type 'gnu/linux)
  :demand t
  :hook ((exwm-update-class . (lambda ()
				(unless (string-prefix-p "sun-awt-X11-" exwm-instance-name)
				  (exwm-workspace-rename-buffer exwm-class-name))))
	 (exwm-update-title . (lambda ()
				(when (or (not exwm-instance-name)
					  (string-prefix-p "sun-awt-X11-" exwm-instance-name))
				  (exwm-workspace-rename-buffer exwm-title))))
	 (exwm-manage-finish . (lambda ()
				 (when (and exwm-class-name
					    (string= exwm-class-name "PureBrowser"))
				   (exwm-input-set-local-simulation-keys nil)))))
  :bind (:map exwm-mode-map
	      ("C-q" . exwm-input-send-next-key)
	      ("M-o" . ace-window)
	      ("s-o" . ace-swap-window))
  :config
  (require 'exwm-config)
  ;; (setq exwm-workspace-number 4)
  (setq exwm-input-global-keys
	`(;; Bind "M-z" to exit char-mode and fullscreen mode
	  (,(kbd "M-z") . exwm-reset)
	  ;; Bind "s-w" to switch workspace interactively
	  (,(kbd "s-w") . exwm-workspace-switch)
	  ;; Bind "s-0" to "s-9" to switch to a workspace by its index
	  ,@(mapcar (lambda (i)
		      `(,(kbd (format "s-%d" i)) .
			(lambda () (interactive)
			  (exwm-workspace-switch-create ,i))))
		    (number-sequence 0 9))
	  ;; Bind "s-SPC" to open applications
	  (,(kbd "s-SPC") . (lambda (command)
			   (interactive (list (read-shell-command "$ ")))
			   (start-process-shell-command command nil command))))e)
  (setq exwm-input-simulation-keys
	'(;; movement
          ([?\C-b] . [left])
          ([?\M-b] . [C-left])
          ([?\C-f] . [right])
          ([?\M-f] . [C-right])
          ([?\C-p] . [up])
          ([?\C-n] . [down])
          ([?\C-a] . [home])
          ([?\C-e] . [end])
          ([?\M-v] . [prior])
          ([?\C-v] . [next])
          ([?\C-d] . [delete])
          ([?\C-k] . [S-end delete])
          ;; cut/paste.
          ([?\C-w] . [?\C-x])
          ([?\M-w] . [?\C-c])
          ([?\C-y] . [?\C-v])
          ;; search
          ([?\C-s] . [?\C-f])))
  (require 'exwm-systemtray)
  (exwm-systemtray-enable)
  (setq-default visible-bell t)
  (exwm-enable)
  (call-process "xmodmap" nil (get-buffer-create "wm") nil (expand-file-name "~/xmodmap-caps-ctrl")))


;;; init.el ends here
