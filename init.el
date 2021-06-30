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
 '(display-time-day-and-date t)
 '(display-time-default-load-average nil)
 '(ediff-window-setup-function 'ediff-setup-windows-plain)
 '(package-selected-packages
   '(flycheck-clj-kondo vyper-mode typescript-mode rustic request-deferred ein olivetti cljr-ivy clj-refactor dashboard fira-code-mode doom-modeline doom-themes all-the-icons vterm all-the-icons-dired all-the-icons-ivy-rich ivy-rich package-lint use-package-ensure-system-package verb forge undo-tree company-emoji lsp-sourcekit swift-helpful swift-mode graphviz-dot-mode kaolin-themes highlight-indentation cider counsel dap-mode json-mode markdown-mode smartparens eyebrowse hercules php-mode clojure-mode git-gutter dash-at-point elpy smart-mode-line yasnippet yasnippet-snippets company-go groovy-mode use-package rjsx-mode web-mode lsp-ui lsp-java lsp-mode flycheck company-quickhelp dart-mode flutter yaml-mode rainbow-mode jade-mode prettier-js add-node-modules-path nodejs-repl go-guru go-mode go-projectile go-scratch docker-compose-mode docker dockerfile-mode exec-path-from-shell rainbow-delimiters expand-region fireplace ample-theme which-key ace-window projectile avy multiple-cursors magit company super-save swiper ivy))
 '(safe-local-variable-values
   '((cider-clojure-cli-global-options . "-A:dev -R:test")
     (cider-clojure-cli-global-options . "-A:dev")
     (encoding . utf-8))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(aw-leading-char-face ((t :height 1.1 :weight bold :foreground "#e361c3")))
 '(lsp-ui-sideline-global ((t nil))))

;; Un-disabled builtins
(put 'downcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
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
  :custom (exec-path-from-shell-variables '("PATH" "MANPATH" "GOPATH" "JAVA_HOME"))
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
(global-set-key (kbd "s-u") #'revert-buffer)
(global-set-key (kbd "s-%") #'query-replace-regexp)
(global-set-key (kbd "s-.") #'xref-find-definitions-other-window)
(global-set-key (kbd "M-/") #'hippie-expand)
(global-set-key (kbd "H-SPC") #'just-one-space)
(global-set-key (kbd "M-j") (lambda () (interactive)
			      (exchange-point-and-mark)
			      (deactivate-mark)))
(global-set-key (kbd "C-x C-p") #'list-processes)
(global-set-key (kbd "C-,") #'switch-to-buffer)
(global-set-key (kbd "C-.") #'find-file)
(global-set-key (kbd "M-RET") #'browse-url)


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
(global-hl-line-mode)
(global-eldoc-mode)
(add-to-list 'default-frame-alist
	     '(font . "Fira Code-12"))
(setq-default fill-column 120)
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
      '(highlight-indentation-face :background (doom-color 'base3))
      '(highlight-indentation-current-column-face :background  (doom-color 'base5))
      '(mode-line-inactive :background (doom-lighten (doom-color 'modeline-bg-alt) 0.05) :foreground (doom-lighten (doom-color 'modeline-fg-alt) 0.05))
      '(sp-pair-overlay-face :background (doom-darken (doom-color 'dark-cyan) 0.15))
      '(vterm-color-black :background (doom-lighten (doom-color 'base2) 0.6) :foreground (doom-color 'base2))
      '(font-lock-comment-face :foreground (doom-lighten (doom-color 'base7) 0.3))
      '(font-lock-comment-delimiter-face :foreground (doom-lighten (doom-color 'base7) 0.15))
      '(lsp-lsp-flycheck-warning-unnecessary-face :foreground (doom-darken (doom-color 'teal) 0.25) :underline '(:style wave :color "#DADA93")))
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

  (if (let ((hour (decoded-time-hour (decode-time))))
	(> 18 hour 7))
      (golight)
    (godark)))

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
  :hook (prog-mode vterm-mode))

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


;; Binding and app-control related packages
(use-package which-key
  :demand t
  :config
  (which-key-mode))

(use-package hercules
  :after which-key)

(use-package dash-at-point
  :if (eq system-type 'darwin)
  :ensure-system-package ("/Applications/Dash.app" . "brew install dash --cask")
  :config
  (let ((py-docsets (concat (alist-get 'python-mode dash-at-point-mode-alist) ",boto3,scikit-learn,fnc,pyrsistent,toolz,psql"))
	(clj-docsets (concat (alist-get 'clojure-mode dash-at-point-mode-alist) ",clojuredocs,cljdoc,cljs,java11,psql"))
	(rust-docsets (concat (alist-get 'rust-mode dash-at-point-mode-alist) ",psql")))
    (add-to-list 'dash-at-point-mode-alist `(python-mode . ,py-docsets))
    (add-to-list 'dash-at-point-mode-alist `(clojure-mode . ,clj-docsets))
    (add-to-list 'dash-at-point-mode-alist `(rustic-mode . ,rust-docsets)))
  (add-to-list 'dash-at-point-mode-alist '(rjsx-mode . "javascript,lodash,nodejs,psql,css,moment,chai,react,awsjs"))
  (global-set-key (kbd "s-c") nil)
  (global-set-key (kbd "s-c s-d") #'dash-at-point))

(use-package spotify
  :ensure nil
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
  :custom
  (undo-tree-auto-save-history t)
  (undo-tree-history-directory-alist '(("." . "~/.config/emacs/undo-hist")))
  :bind ("s-/" . undo-tree-visualize)
  :config
  (global-undo-tree-mode))


;; Motion / movement & multiple cursors
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
          ("<return>" . nil) ;; They must have bound <return>, since changing this to RET makes it not work
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
	       ("RET" . quit)
	       ("q" . quit))
    (hercules-def
     :toggle-funs #'mc-place
     :hide-funs 'quit
     :keymap 'mc-placement-map
     :transient t)
    (global-set-key (kbd "H-m") #'mc-place)))


;; Org mode & prose writing
(use-package org
  :demand t
  :custom
  (org-export-backends '(ascii html icalendar latex odt md))
  (org-capture-templates '(("c" "Simple code link template" entry
			    (file "~/Documents/notes.org")
			    "** %f: %a" :immediate-finish t)))
  (org-default-notes-file "~/Documents/notes.org")
  :bind (:map org-mode-map
	      ("C-," . nil))
  :config
  (global-set-key (kbd "H-o H-c") #'org-capture))

(customize-set-variable 'initial-major-mode 'org-mode)
(customize-set-variable 'initial-scratch-message "/This buffer is for text that is not saved, and it's in Org Mode!/\n")

(use-package org-tempo
  :ensure nil
  :after org)

(use-package olivetti
  :defer t)


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
  (smartparens-global-mode))


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
         ("M-h" . ivy-dispatching-done)
	 ("S-SPC" . nil))
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
  :custom
  (counsel-grep-base-command "rg -i -M 120 --no-heading --line-number %s %s")
  (counsel-find-file-ignore-regexp "\\(?:\\`[#.]\\)\\|\\(?:\\`.+?[#~]\\'\\)")
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


;; Prettier
(use-package prettier-js
  ;; I'd been getting some weird load order errors, and I use Prettier all the time, so now I just load it always near
  ;; the beginning of my config.
  :demand t
  :ensure-system-package (prettier . "npm i -g prettier")
  :hook ((rjsx-mode yaml-mode css-mode json-mode typescript-mode markdown-mode) . prettier-js-mode))


;; Git, Magit, and Forge
(use-package magit
  :demand t
  :custom (magit-diff-use-overlays nil)
  :bind ("C-x g" . magit-status))

(use-package forge
  :after (magit prettier-js)
  :hook (forge-post-mode . (lambda () (setq-local prettier-js-args '("--parser" "markdown"))))
  :config
  (transient-append-suffix 'forge-dispatch '(0 2 -1)
    '("c x" "pull review request" forge-edit-topic-review-requests)))

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
  :hook ((shell-script-mode css-mode html-mode java-mode ruby-mode go-mode dart-mode rjsx-mode typescript-mode swift-mode) . lsp)
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
  (lsp-flycheck-live-reporting nil)
  (lsp-eslint-format nil)
  (lsp-eslint-run "onSave")
  (lsp-headerline-breadcrumb-enable nil)
  :config
  (let ((eslint-server "/Users/jming/.vscode/extensions/dbaeumer.vscode-eslint-2.1.6/server/out/eslintServer.js"))
    (when (file-exists-p eslint-server)
      (setq lsp-eslint-server-command `("node" ,eslint-server "--stdio"))))
  (add-to-list 'lsp-file-watch-ignored "[/\\\\]build")
  (add-to-list 'lsp-file-watch-ignored "[/\\\\]tmp"))

(use-package lsp-java
  :after lsp-mode)

(use-package lsp-sourcekit
  :after lsp-mode
  :config
  (setq lsp-sourcekit-executable "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp"))

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

(use-package dap-mode
  :after lsp-mode
  :custom
  (dap-auto-configure-features '(sessions locals breakpoints))
  (dap-label-output-buffer-category t)
  :hook ((lsp-mode . dap-auto-configure-mode)
	 ((rjsx-mode typescript-mode) . dap-node-setup))
  :config
  (require 'dap-python)
  (require 'dap-node)
  (dap-register-debug-template "Node::Attach" '(:type "node" :request "attach" :name "Node::Attach"))
  (add-hook 'dap-stopped-hook (lambda (arg) (call-interactively #'dap-hydra))))


;; SQL
;; Gonna be honest, this indentation does not work how I want it to. I should get around to updating it.
(use-package sql-indent
  :ensure nil
  :load-path "git-lisp/sql-indent/"
  :after sql
  :demand t
  :bind (:map sql-mode-map
	      ("M-i" . sql-indent-buffer))
  :custom (sql-indent-first-column-regexp
	   ;; See sql-indent.el line 66
	   (concat "\\(\\(^\\s-*"
		   (regexp-opt
		    '("select" "update" "insert" "delete" "alter"
		      "union" "intersect" "with" "add"
		      "from" "where" "into" "group" "having" "order" "join"
		      "set" "as"
		      "create" "drop" "truncate"
		      "--" ")" ");" "),")
		    t)
		   "\\(\\b\\|\\s-\\)\\)\\|\\(^```$\\)\\)")))


;; Clojure & Cider
(use-package cider
  :defer t
  :hook (clojure-mode . (lambda () (add-hook 'before-save-hook #'cider-format-buffer t t)))
  :bind (:map cider-mode-map
              ("M-i" . cider-format-buffer)))

(use-package flycheck-clj-kondo
  :after cider
  :hook (clojure-mode . (lambda () (require 'flycheck-clj-kondo))))

(use-package clj-refactor
  :hook (clojure-mode . clj-refactor-mode)
  :config
  (customize-set-variable 'cljr-magic-require-namespaces
			  (append
			   '(("sets" . "clojure.set")
			     ("string" . "clojure.string"))
			   cljr-magic-require-namespaces)))

(use-package cljr-ivy
  :after clj-refactor
  :bind (:map clojure-mode-map
	      ("M-r" . cljr-ivy)))


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
	      ("M-r" . elpy-multiedit-python-symbol-at-point))
  :custom
  (python-shell-interpreter "jupyter")
  (python-shell-interpreter-args "console --simple-prompt")
  (python-shell-prompt-detect-failure-warning nil)
  (elpy-eldoc-show-current-function nil)
  (elpy-shell-echo-output nil)
  :config
  (add-to-list 'python-shell-completion-native-disabled-interpreters "jupyter")
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook (lambda () (add-hook 'before-save-hook 'elpy-format-code nil 'local))))

(use-package request-deferred)
(use-package ein
  :after request-deferred
  :mode ("\\.ipynb\\'" . ein:ipynb-mode))


;; Vyper
(use-package vyper-mode)


;; Markdown
(use-package markdown-mode
  :after prettier-js
  :commands markdown-mode
  :bind (:map markdown-mode-map
         ("M-n" . nil)
         ("M-p" . nil)
	 ("TAB" . nil)
	 ("M-i" . prettier-js)))


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
  :after go-mode)


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
(use-package rustic
  :custom (rustic-format-trigger 'on-save)
  :hook (rustic-mode . (lambda () (setq-local company-backends (remove 'company-emoji company-backends))))
  :bind (:map rustic-mode-map
	      ("M-i" . rustic-format-buffer)))


;; Swift
(use-package swift-mode
  :mode ("\\.swift\\'"))

(use-package swift-helpful
  :after swift-mode)


;; Groovy / .gradle
(use-package groovy-mode)


;; Web modes
(use-package css-mode
  :after prettier-js
  :bind (:map css-mode-map
         ("M-i" . prettier-js)
	 ("M-." . lsp-goto-implementation)))

(use-package web-mode
  :after (prettier-js flycheck)
  :mode ("\\.ejs\\'" "\\.erb\\'" "\\.mustache\\'" "\\.tsx\\'")
  :bind (:map web-mode-map
	      ("M-i" . prettier-js))
  :hook (web-mode . (lambda ()
		      (when (string-equal "tsx" (file-name-extension buffer-file-name))
			(prettier-js-mode)
			(lsp)
			(setq-local web-mode-auto-quote-style 3))))
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

(use-package ruby-mode
  :ensure nil
  :bind (:map ruby-mode-map
	 ("M-." . lsp-goto-implementation)))


;; JavaScript / Typescript / React (JSX)
(use-package add-node-modules-path
  :commands add-node-modules-path)

(defun js-refactor-const-to-function ()
  "Refactor all `const myFunc = () => {}' forms in the current buffer to `function myFunc() {}' forms."
  (interactive)
  (let ((starting-point (point)))
    (goto-char (point-min))
    (while (re-search-forward "^\\(export \\)?const \\([a-zA-Z][^ ]*\\) = \\(async \\)?\\(([^)]*)\\) => {" nil t)
      (replace-match "\\1\\3function \\2\\4 {"))
    (goto-char starting-point)))

(defun js-refactor-to-individual-export ()
  "Refactor the declaration of sexp at point to have the `export' keyword at its beginning, then move point to the next sexp.  If you place your point on the first sexp in a grouped `export { x, y }' form, you can repeat this function to refactor all the exported vars in one fell swoop."
  (interactive)
  (let ((xref-results (xref-find-definitions (xref-backend-identifier-at-point (xref-find-backend)))))
    (when (eq 'buffer (type-of xref-results))
      (quit-window)
      (user-error "Multiple definitions available for identifier at point -- don't know which one to refactor")))
  (move-beginning-of-line nil)
  (insert "export ")
  (xref-pop-marker-stack)
  (sp-forward-sexp)
  (sp-next-sexp))

(use-package rjsx-mode
  :custom (js-indent-level 2)
  :after prettier-js
  :mode ("\\.jsx?\\'" "\\.[cm]js\\'")
  :interpreter ("node" "nodejs")
  :bind (:map rjsx-mode-map
         ("M-i" . prettier-js)
         ("M-." . xref-find-definitions)
	 ("C-c M-f" . js-refactor-const-to-function)
	 ("C-c M-e" . js-refactor-to-individual-export))
  :config
  (add-node-modules-path))

(use-package typescript-mode
  :custom (typescript-indent-level 2)
  :after prettier-js
  :bind (:map typescript-mode-map
	      ("M-i" . prettier-js)
	      ("C-c M-f" . js-refactor-const-to-function))
  :config
  (add-node-modules-path))

(use-package json-mode
  :custom (json-reformat:indent-width 2)
  :after prettier-js
  :mode ("\\.json\\'")
  :bind (:map json-mode-map
	 ("M-i" . prettier-js)))

(use-package nodejs-repl
  :after (rjsx-mode typescript-mode)
  :commands nodejs-repl
  :bind (:map rjsx-mode-map
	 ("C-c M-j" . nodejs-repl)
	 ("C-x C-e" . nodejs-repl-send-last-expression)
	 ("C-x C-r" . nodejs-repl-send-region)
	 ("C-c C-k" . nodejs-repl-load-file)
         :map typescript-mode-map
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
  :custom (vterm-max-scrollback 25000)
  :commands vterm
  :bind (("s-t" . vterm)
	 (:map vterm-mode-map
	       ("C-k" . vterm-send-C-k))))


;; Window stuff
(defun enlarge-window-10 ()
  "Enlarge the window by 10 at a time."
  (interactive)
  (enlarge-window 10))

(defun shrink-window-10 ()
  "Shrink the window by 10 at a time."
  (interactive)
  (shrink-window 10))

(defun cool-enlarge-window (height)
  "Prompt for a factor by which to enlarge the window.  HEIGHT represents how many points to enlarge."
  (interactive "nBy: ")
  (enlarge-window height))

(fset 'fix-windows
   (kmacro-lambda-form [?\M-o ?1 ?\H-w ?g ?\H-w ?r ?n ?n ?n ?n ?n ?b ?b ?b ?b ?b return] 0 "%d"))

(defvar init-project-right-p nil
  "If non-nil, `init-project' will put the largest window on the right side of the frame.  Otherwise, the largest window will be put on the left.")

(defun init-project (file &optional file2 magit-window-shrink)
  "Initialize my windows for the project specified by FILE.
FILE represents the project root file to open.
If provided, FILE2 will be opened in the side window.

Either FILE or FILE2 may instead be the symbol `vterm', in which
case vterm will be started in that window instead of a file.

If provided, MAGIT-WINDOW-SHRINK can customize the amount by which the magit
window is shrunk (defaults to 15)."
  (interactive)
  (delete-other-windows)
  (let ((first-file (car (remove 'vterm (list file file2)))))
    (if (not first-file)
	(warn "At least one arg to init-project must be a file path")
      (find-file first-file)
      (split-window-right)
      (unless init-project-right-p
	(other-window 1))
      (split-window-below)
      (call-interactively #'magit-status) ;; Moves point to magit status buffer
      (shrink-window (or magit-window-shrink 15))
      (shrink-window-horizontally 5)
      (other-window -1)
      (if (eq file2 'vterm) (vterm) (find-file file2))
      (other-window 2)
      (if (eq file 'vterm) (vterm) (find-file file)))))

(defun init-emacs ()
  "Initialize my buffers to edit my Emacs config."
  (interactive)
  (init-project (locate-user-emacs-file "init.el") (locate-user-emacs-file "git-lisp/fira-code-mode/fira-code-mode.el")))
(global-set-key (kbd "H-i e") #'init-emacs)

(defun init-rust ()
  "Initialize my buffers to my Rust learning projects."
  (interactive)
  (let ((proj-loc "~/Documents/personal/rustbucket"))
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
  :custom (aw-dispatch-always t)
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
	     ("r" . enlarge-window-10)
	     ("s" . shrink-window-10)
	     ("e" . cool-enlarge-window)
	     ("g" . balance-windows)
	     ("n" . shrink-window)
	     ("p" . enlarge-window)
	     ("f" . enlarge-window-horizontally)
	     ("b" . shrink-window-horizontally)
	     ("d" . init-dap)
	     ("q" . quit)
	     ("RET" . quit))
  (hercules-def
   :toggle-funs #'my-window-prefix
   :hide-funs '(cool-enlarge-window balance-windows init-dap quit)
   :keymap 'my-window-map
   :transient t)
  (global-set-key (kbd "H-w") #'my-window-prefix))


;; Ediff customizations
(defvar j/ediff-previous-window-config nil)

(defun j/ediff-eyebrowse-open ()
  "Do my eyebrowse things before opening ediff's windows."
  (unless j/ediff-previous-window-config
    (let* ((window-configs (eyebrowse--get 'window-configs))
           (slots (mapcar 'car window-configs))
           (slot (eyebrowse-free-slot slots)))
      (eyebrowse-switch-to-window-config slot)
      (eyebrowse-last-window-config)
      (setq j/ediff-previous-window-config slot))))

(defun j/ediff-eyebrowse-close ()
  "Do my eyebrowse things before closing ediff's windows."
  (when j/ediff-previous-window-config
    (run-hooks 'eyebrowse-pre-window-delete-hook)
    (eyebrowse--delete-window-config j/ediff-previous-window-config)
    (run-hooks 'eyebrowse-post-window-delete-hook)
    (setq j/ediff-previous-window-config nil)))

(defun ediff-copy-both-to-C ()
  "Copy both variants A and B to the ediff buffer C."
  (interactive)
  (ediff-copy-diff ediff-current-difference nil 'C nil
                   (concat
                    (ediff-get-region-contents ediff-current-difference 'A ediff-control-buffer)
                    (ediff-get-region-contents ediff-current-difference 'B ediff-control-buffer))))

(add-hook 'ediff-load-hook
	  (lambda ()
	    (add-hook 'ediff-keymap-setup-hook (lambda () (define-key ediff-mode-map "d" #'ediff-copy-both-to-C)))
	    (add-hook 'ediff-before-setup-hook #'j/ediff-eyebrowse-open)
	    (add-hook 'ediff-quit-hook #'j/ediff-eyebrowse-close 10)
	    (add-hook 'ediff-suspend-hook #'j/ediff-eyebrowse-close 10)
	    (add-hook 'ediff-quit-merge-hook #'j/ediff-eyebrowse-close 10)))


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


;; Fixes for emoji support ✨
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
  (add-hook 'ns-system-appearance-change-functions
            (lambda (appearance)
	      (pcase appearance
                ('light (golight))
                ('dark (godark))))))


;; Linux customizations
(when (eq system-type 'gnu/linux)
  (use-package pinentry
    :demand t
    :config
    (pinentry-start)
    (defun pinentry-emacs (desc prompt ok error)
      (let ((str (read-passwd (concat (replace-regexp-in-string "%22" "\"" (replace-regexp-in-string "%0A" "\n" desc)) prompt ": "))))
	str)))

  (use-package exwm
    :demand t
    :hook ((exwm-update-class . (lambda ()
				  (unless (string-prefix-p "sun-awt-X11-" exwm-instance-name)
				    (exwm-workspace-rename-buffer exwm-class-name))))
	   (exwm-update-title . (lambda ()
				  (when (or (not exwm-instance-name)
					    (string-prefix-p "sun-awt-X11-" exwm-instance-name))
				    (exwm-workspace-rename-buffer exwm-title)))))
    :bind (:map exwm-mode-map
		("C-q" . exwm-input-send-next-key)
		("M-o" . ace-window)
		("s-o" . ace-swap-window))
    :init
    (require 'exwm-systemtray)
    (exwm-systemtray-enable)
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
	    ;; Bind "M-SPC" to open applications
	    (,(kbd "M-SPC") . (lambda (command)
				(interactive (list (read-shell-command "$ ")))
				(start-process-shell-command command nil command)))))
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
    (setq-default visible-bell t)
    (exwm-enable)
    (call-process "xmodmap" nil (get-buffer-create "wm") nil (expand-file-name "~/xmodmap-customizations"))))


;;; init.el ends here
