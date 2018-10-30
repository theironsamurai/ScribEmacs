;;; init.el --- ScribEmacs configuration
;;
;; A config geared primarily towards the needs of
;; a writer who just happens to also be a geek.
;;
;;
;; 

;;; Code:


;; Inhibit Spash Screen: go straight to *scratch*
(setq inhibit-splash-screen t)

;; Custom File: don't dirty up me init!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; BOOTSTRAP   ;;;;;;;;;;
;;;;;;; use-package ;;;;;;;;;;
;;;;;;; org-mode    ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'package)
(setq user-emacs-directory "~/.emacs.d/")
(setq package-user-dir (concat user-emacs-directory "packages"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
(when (>= emacs-major-version 25) (setq package-archive-priorities '(("org" . 3)
								     ("melpa" . 2)
								     ("gnu" . 1))))
(setq package-load-list '(all))
(package-initialize)
(setq package-enable-at-startup nil)

;;; Now bootstrap use-package
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(setq use-package-always-ensure t)
(add-hook 'package-menu-mode-hook 'hl-line-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;; ORG MODE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Load org mode early to ensure that the orgmode ELPA version gets picked up, not the
;;; shipped version

(use-package org
  :ensure org-plus-contrib
  :pin org
	:config
  ;; Make following links easier
	(setq org-return-follows-link t)
	(setq org-modules (quote (org-bibtex))))

;; (setq org-wikinodes-scope 'directory)

(setq org-link-frame-setup '((file . find-file)))

;;; ------------ Example of How to use modules
;;
;; (use-package org-inlinetask
;;   :bind (:map org-mode-map
;;               ("C-c C-x t" . org-inlinetask-insert-task))
;;   :after (org)
;;   :commands (org-inlinetask-insert-task))
;; (use-package org-bullets
;;   :ensure t
;;   :commands (org-bullets-mode)
;;   :init (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;; MAIN CONFIG ;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;; -------------- Basic Customizations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Back up files
;;
;; These can get annoying if left in current dir, but
;; are actually quite useful when you need them. So,
;; I'll move them into a seperate spot.

(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
  backup-by-copying t    ; Don't delink hardlinks
  version-control t      ; Use version numbers on backups
  delete-old-versions t  ; Automatically delete excess backups
  kept-new-versions 20   ; how many of the newest versions to keep
  kept-old-versions 5    ; and how many of the old
  )

;; Emacs Defaults
(tool-bar-mode -1)
(menu-bar-mode -1)
(blink-cursor-mode 1)
(setq-default cursor-type 'box)
;; (setq default-frame-alist
;;			'(cursor-color . "orange"))
;; (set-cursor-color nil)
(setq next-line-add-newlines t)
(global-hl-line-mode -1)
;; (delete-selection-mode 1)
(transient-mark-mode 1)
(show-paren-mode 1)
(column-number-mode 1)
(defalias 'yes-or-no-p 'y-or-n-p)
(global-visual-line-mode t)
(global-hl-line-mode t)
(delete-selection-mode t)
(set-default 'tab-width 2)
(electric-pair-mode 1)
;; (setq-default require-final-newline 'visit-save)


;; UTF8
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)




;;; ---- Looks
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Start Maximized
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Faces & Fonts
(if (member "Source Code Pro" (font-family-list))
    (set-face-attribute 'default nil
												:font "Source Code Pro"
												:height 120
												:weight 'normal))

;; Doom Themes
(use-package doom-themes
  :defer t)

;; Global settings (defaults)
(setq doom-themes-enable-bold t    
      doom-themes-enable-italic t) 

;; Enable flashing mode-line on errors
(doom-themes-visual-bell-config)

;; Enable custom neotree theme (all-the-icons must be installed!)
;; (doom-themes-neotree-config)

;; Corrects (and improves) org-mode's native fontification.
(doom-themes-org-config)


;; Other Themes
(use-package zenburn-theme
  :defer t)

(use-package doom-themes
  :defer t)

(use-package borland-blue-theme
  :defer t)

(use-package gruvbox-theme
  :defer t)

(use-package spacemacs-theme
  :defer t)

(use-package cyberpunk-theme
  :defer t)

(use-package leuven-theme
  :defer t)

(use-package plan9-theme
	:defer t)

(use-package color-theme-sanityinc-tomorrow
	:defer t)

(use-package tango-plus-theme
	:defer t)

(use-package espresso-theme
	:defer t)

(use-package faff-theme
	:defer t)






;;; --------------- TRANSPARENCY
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;emacs transparency
(set-frame-parameter (selected-frame) 'alpha '(90 60))
(add-to-list 'default-frame-alist '(alpha 100 100))

(eval-when-compile (require 'cl))
(defun toggle-transparency ()
  (interactive)
  (if (/=
       (cadr (frame-parameter nil 'alpha))
       100)
      (set-frame-parameter nil 'alpha '(100 100))
    (set-frame-parameter nil 'alpha '(90 60))))

;; Set transparency of emacs
(defun transparency (arg &optional active)
  "Sets the transparency of the frame window. 0=transparent/100=opaque"
  (interactive "nEnter alpha value (1-100): \np")
  (let* ((elt (assoc 'alpha default-frame-alist))
         (old (frame-parameter nil 'alpha))
         (new (cond ((atom old)     `(,arg ,arg))
                    ((eql 1 active) `(,arg ,(cadr old)))
                    (t              `(,(car old) ,arg)))))
    (if elt (setcdr elt new) (push `(alpha ,@new) default-frame-alist))
    (set-frame-parameter nil 'alpha new)))

(set-frame-parameter (selected-frame) 'alpha '(100 100))

;;; -------------- CORE PACKAGES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; ---- HELM
;;;;;;;;;;;;;;

(use-package helm
  :init
  (custom-set-variables '(helm-command-prefix-key "C-,"))
  (setq helm-mode-fuzzy-match t)
  (setq helm-completion-in-region-fuzzy-match t)
  (setq helm-candidate-number-list 50)
  :bind (("M-x" . helm-M-x)
         ("C-x C-f" . helm-find-files)
         ("C-x f" . helm-recentf)
         ("M-y" . helm-show-kill-ring)
         ("C-x b" . helm-buffers-list))
  :bind (:map helm-map
	      ("M-j" . helm-previous-line)
	      ("M-k" . helm-next-line)
	      ("M-J" . helm-previous-page)
	      ("M-K" . helm-next-page)
	      ("M-h" . helm-beginning-of-buffer)
	      ("M-H" . helm-end-of-buffer))
  :config (progn
	    (setq helm-buffers-fuzzy-matching t)
            (helm-mode 1))
	)

;; Helm Swoop

(use-package helm-swoop
  :bind (("M-m" . helm-swoop)
	 ("M-M" . helm-swoop-back-to-last-point))
  :init
  (bind-key "M-m" 'helm-swoop-from-isearch isearch-mode-map))

(use-package helm-themes)

;; The Silver Searcher
(use-package ag
  :commands (ag ag-regexp ag-project))

;; Helm Ag
(use-package helm-ag
  :ensure helm-ag
  :bind ("M-p" . helm-projectile-ag)
  :commands (helm-ag helm-projectile-ag)
  :init (setq helm-ag-insert-at-point 'symbol
helm-ag-command-option "--path-to-ignore ~/.agignore"))

(use-package projectile
  ;;  :bind (("C-t p s" . projectile-switch-open-project)
  ;;	 ("C-t p p" . projectile-switch-project))
  :config
  (projectile-global-mode)
  (setq projectile-enable-caching t))

(use-package helm-projectile
  :bind ("M-t" . helm-projectile-find-file)
  :config
  (helm-projectile-on))




;;; ---- More
;;;;;;;;;;;;;;

;; Drag stuff!
;;

(use-package drag-stuff
  :config
  (progn
      (drag-stuff-global-mode 1)
      (drag-stuff-define-keys)
      )
  :bind (("M-<up>" . drag-stuff-up)
	 ("M-<down>" . drag-stuff-down)
	 ("M-<left>" . shift-left)
	 ("M-<right>" . shift-right)))



;; All The Icons
(use-package all-the-icons)



;;; Which-Key
;;
;; What was that keybinding again?
(use-package which-key
	:init
  (setq which-key-separator " ")
  (setq which-key-prefix-prefix "+")
  :config
  (which-key-mode))

;;; Compapy Mode
(use-package company
  :init (global-company-mode)
  :config
  (progn
    (delete 'company-dabbrev company-backends)
    (setq company-tooltip-align-annotations t
	  company-tooltip-minimum-width 27
	  company-idle-delay 0.3
	  company-tooltip-limit 10
	  company-minimum-prefix-length 3
	  company-tooltip-flip-when-above t))
  :bind (:map company-active-map
              ("M-k" . company-select-next)
              ("M-j" . company-select-previous)
              ("TAB" . company-complete-selection))
  :diminish company-mode)


;; ;;; Smart Parens
;; (use-package smartparens
;;   :init
;;   (smartparens-global-mode)
;;   (show-smartparens-global-mode)
;;   (dolist (hook '(inferior-emacs-lisp-mode-hook
;;                   emacs-lisp-mode-hook))
;;     (add-hook hook #'smartparens-strict-mode))
;;   :config
;;   (require 'smartparens-config)
;;   ;;(setq sp-autoskip-closing-pair 'always)
;;   :bind
;;   (:map smartparens-mode-map
;; 	("C-c s u" . sp-unwrap-sexp)
;; 	("C-c s w" . sp-rewrap-sexp))
;;   :diminish (smartparens-mode))

;;; Rainbow!
(use-package rainbow-delimiters
  :defer t
  :init
  (dolist (hook '(text-mode-hook prog-mode-hook emacs-lisp-mode-hook))
    (add-hook hook #'rainbow-delimiters-mode)))


;; smooth-scrolling
(use-package smooth-scrolling
  :init
  (setq smooth-scroll-margin 5
        scroll-conservatively 101
        scroll-preserve-screen-position t
        auto-window-vscroll nil)
  :config
	(setq scroll-margin 5))

(use-package magit
  :defer 2
  :bind (("C-x g" . magit-status)))


;;; -------------- TEXT & EDITING: not Org
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;Text
;; (setq default-fill-column 90)


;;; Multiple Cursors
;;;;;;;;;;;;;;;;;;;;

(use-package multiple-cursors
 	:config
	(global-set-key (kbd "C-S-<down>") 'mc/mark-next-like-this)
	(global-set-key (kbd "C-S-<up>") 'mc/mark-previous-like-this)
  (global-set-key (kbd "<f5>") 'mc/mark-all-like-this)
	)

;;; Markdown Mode
;;;;;;;;;;;;;;;;;;

(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . gfm-mode)
         ("\\.markdown\\'" . gfm-mode))
  :init
	(setq markdown-command "pandoc")
	:config
	(add-hook 'markdown-mode-hook 'markdown-toggle-wiki-links)
  (setq markdown-wiki-link-fontify-missing t))

(global-set-key (kbd "C-o") 'markdown-follow-wiki-link-at-point)



;;; Adoc Mode
;;;;;;;;;;;;;;;;;;

(use-package adoc-mode)

(add-to-list 'auto-mode-alist (cons "\\.adoc\\'" 'adoc-mode))
(add-to-list 'auto-mode-alist (cons "\\.asciidoc\\'" 'adoc-mode))


;; Olitvetti - writing in style

(use-package olivetti
  :init
  (setq olivetti-body-width 80))

(add-hook 'text-mode-hook 'turn-on-olivetti-mode)
(add-hook 'prog-mode-hook 'turn-on-olivetti-mode)

;;; DEFT
;;;;;;;;;;;;;;;;;

(use-package deft
  :config
	(setq deft-extensions '("org" "md" "markdown" "adoc" "asciidoc" "txt" "tex"))
  ;; (setq deft-text-mode 'org-mode)
  (setq deft-use-filename-as-title t)
  (setq deft-file-naming-rules '((noslash . "-")
                                 (nospace . "-")))
  (setq deft-directory "~/Dropbox/orgwiki")
  :bind
	("<f8>" . deft))


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;; EVIL CONFIG ;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (use-package evil
;;   :init ;; tweak evil's configuration before loading it
;;   (setq evil-search-module 'evil-search)
;;   (setq evil-ex-complete-emacs-commands nil)
;;   (setq evil-vsplit-window-right t)
;;   (setq evil-split-window-below t)
;;   (setq evil-shift-round nil)
;;   (setq evil-want-C-u-scroll t)
;; 	(setq evil-toggle-key "C-q")
;;   :config ;; tweak evil after loading it
;;   (evil-mode)
;;   ;; example how to map a command in normal mode (called 'normal state' in evil)
;;   (define-key evil-normal-state-map (kbd ", w") 'evil-window-vsplit))

;; ;; remove all keybindings from insert-state keymap, use emacs-state when editing
;; (setcdr evil-insert-state-map nil)

;; ;; ESC to switch back normal-state
;; (define-key evil-insert-state-map [escape] 'evil-force-normal-state)

;; ;;; Evil Keybindings

;; (global-set-key (kbd "C-;") 'evil-force-normal-state)
;; (global-set-key (kbd "C-u") 'evil-scroll-up)

;; ;; Evil Org Bindings
;; ;; (evil-define-key 'normal org-mode-map "<tab>" 'org-cycle)
;; ;; (evil-define-key '(normal visual) org-mode-map
;; ;; 	"gj" 'org-next-visible-heading
;; ;; 	"gk" 'org-previous-visible-heading)


;; (define-key evil-normal-state-map [return] 'org-open-at-point-global)

;; ;; Evil Org Mode

;; (use-package evil-org
;;   :ensure t
;;   :after org
;;   :config
;;   (add-hook 'org-mode-hook 'evil-org-mode)
;;   (add-hook 'evil-org-mode-hook
;;             (lambda ()
;;               (evil-org-set-key-theme)))
;;   (require 'evil-org-agenda)
;;   (evil-org-agenda-set-keys))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;; GENERAL ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package general
  :config (general-define-key
    ;; :states '(normal visual insert emacs)
    :prefix "C-c"
    ;; :non-normal-prefix "C-c"
    ;; "TAB" '(switch-to-prev-buffer :which-key "previous buffer")
    ;; "SPC" '(helm-M-x :which-key "M-x")
		;; Applications
		"a"   '(:ignore t :which-key "Applications")
		"ad"  'dired
	  "an"  'deft
    ;; -- Shells
    "aa"  '(ansi-term :which-key "open ansi terminal")
    "ae"  '(eshell :which-key "open eshell terminal")
		;; Files
		"f"   '(:ignore t :which-key "Files")
		"ff"  '(helm-find-files :which-key "find files")
		;; "ft"  '(treemacs :which-key "Treemacs")
		;; Search
		"s"   '(:ignore t :which-key "Search")
    "ss"  '(helm-swoop :which-key "helm swoop")
    ;; Buffers
		"b"   '(:ignore t :which-key "Buffers")
    "bb"  '(helm-buffers-list :which-key "buffers list")
    ;; Window
		"w"   '(:ignore t :which-key "Windows")
    "wl"  '(windmove-right :which-key "move right")
    "wh"  '(windmove-left :which-key "move left")
    "wk"  '(windmove-up :which-key "move up")
    "wj"  '(windmove-down :which-key "move bottom")
    "w/"  '(split-window-right :which-key "split right")
		"ww"  '(other-window :which-key "other window")
    "wb"  '(split-window-below :which-key "split bottom")
    "wx"  '(delete-window :which-key "delete window")
		"wd"  '(delete-other-windows :which-key "delete other windows")
		"wo"  '(:ignore t :which-key "Olivetti menu")
  	"woo" '(olivetti-mode :which-key "Olivetti Mode")
		"wom" '(olivetti-toggle-hide-mode-line :which-key "Toggle Mode Line")
		"wow" '(olivetti-set-width :which-key "Set Width")
		;; Markdown
		"m"   '(:ignore t :which-key "Markdown")
		"mlw" '(markdown-insert-wiki-link :which-key "markdown insert wiki-link")
		"mlt" '(markdown-toggle-url-hiding :which-key "markdown toggle URL hiding")
    ;; Org-mode
		"l"  '(:ignore t :which-key "Org Links")
    "lt" '(org-toggle-link-display :which-key "org-toggle-link-display")
		"li" '(org-insert-link :which-key "org-insert-link")
		"ls" '(org-store-link :which-key "org-store-link")
		"o"  '(org-open-at-point-global :which-key "org-open-at-point")
		;; Transparency
		"1"  '(helm-themes :which-key "helm theme")
		"2"  '(toggle-transparency :which-key "Toggle Transparency")
		"3"  '(transparency :which-key "Transparency Value")
		;; evaluate
		"e"   '(:ignore t :which-key "Eval")
		"eb"  '(eval-buffer :which-key "eval buffer")
		"es"  '(eval-last-sexp :which-key "eval last sexp")
		"ef"  '(eval-defun :which-key "eval defun")
		"er"  '(eval-region :which-key "eval region")
		"ex"  '(eval-expression :which-key "eval expression")
		;; Projectile
		"p"   '(:ignore t :which-key "Projectile")
		"pf"  '(helm-projectile-find-file :which-key "Helm Projectile Find File")
		"ps"  '(projectile-switch-open-project :which-key "P-Switch Open Project")
		"pp"  '(projectile-switch-project :which-key "P-Switch Project")
		;; Quill --- Writer Stuff
		"q"   '(:ignore t :which-key "Quill")
		"qi"  '(:ignore t :which-key "iSpell")
		"qiw" '(ispell-word :which-key "iSpell Word")
		"qib" '(ispell-buffer :which-key "iSpell Buffer")
		"qir" '(ispell-region :which-key "iSpell Region")
		"qim" '(ispell-minor-mode :which-key "iSpell Minor Mode")
		;; Region
		"r"   '(:ignore t :which-key "Region")
		"rc"  '(comment-region :which-key "Comment Region")
		"ru"  '(uncomment-region :which-key "Uncomment Region")
		;; LISP
		;; "l"   '(:ignore t :which-key "Lisp menu")
		;; "ls"  '(smartparens-strict-mode :which-key "SmartParens Strict Mode")
    ))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; GLOBAL KEYBINDINGS ;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Org-links EVERYWHERE

;; (global-set-key (kbd "C-c L") 'org-insert-link-global)
;; (global-set-key (kbd "C-c o") 'org-open-at-point-global)

;; windows
(global-set-key (kbd "C-9") 'windmove-left)
(global-set-key (kbd "C-0") 'windmove-right)
(global-set-key (kbd "<f3>") 'split-window-vertically)
(global-set-key (kbd "<f2>") 'split-window-horizontally)
(global-set-key (kbd "<f1>") 'delete-other-windows)
(global-set-key (kbd "<f4>") 'delete-window)


;; -- Check word spelling at point
(global-set-key (kbd "<C-tab>") 'ispell-word)

;; -- Cua-Like Keys for a few things
;; (I find that Copy/Paste vs the Yank style
;; makes no difference. But I want to save
;; and undo via automatic reflex → in every program!
;; Also, practicing the standard Emacs-style
;; C-x C-s in other programs results in ...
;; sub-optimal behavior.)
(global-set-key (kbd "C-s") 'save-buffer)
(global-set-key (kbd "C-z") 'undo)


;; text scale increase/decrease (C +/=)(C -)
(define-key global-map (kbd "C-=") 'text-scale-increase)
(define-key global-map (kbd "C--") 'text-scale-decrease)

;; Some bindings for special characters
(global-set-key (kbd "M-l") (lambda () (interactive) (insert "\u03bb"))) ;lambda
(global-set-key (kbd "M-f") (lambda () (interactive) (insert "\u0192"))) ;function
(global-set-key (kbd "M--") (lambda () (interactive) (insert "\u2192"))) ;arrow

;;; init.el ends here




