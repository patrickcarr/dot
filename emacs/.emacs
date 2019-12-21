;;; package --- .emacs
;Copyright (C) 2015 by Patrick Carr
;Time-stamp: <2019-12-17 22:36:35 cpc26>
;;; Commentary:
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
;;; Code:
 (setq inhibit-splash-screen t)
;;(setq debug-on-error nil)
;;(setq debug-on-error t) ; leave it nil for day to day as it is _very_ annoying.
(setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
    (setq exec-path (append exec-path '("/usr/local/bin")))
(add-to-list 'load-path "~/.emacs.d/lisp/")
(if (not (getenv "TERM_PROGRAM"))
    (setenv "PATH"
	    (shell-command-to-string "source $HOME/.bashrc && printf $PATH")))
(message "[✓]  Commencer PACKAGE-INIT")
(package-initialize)
(message "[✓]  Commencer CUSTOM")
(setq custom-file "~/.emacs-custom.el")
(load custom-file)
;;;; elpa
;;;; ................................................................................
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("marmalade" . "https://marmalade-repo.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
			 ("org" . "http://orgmode.org/elpa/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(package-install-selected-packages)
;--------------------------------------------------------------------------------
;;;;
;;;; ..............E N T E R P R I S E  Q U A L I T Y................................
(require 'salesforce-mode)
(require 'apex-mode)
;;;;
(message "[✓]  Commencer BACKUPS and VERSIONING")
(add-hook 'before-save-hook 'time-stamp)
;; ========== Place Backup Files in Specific Directory ==========
;; Activer backup files.
(setq make-backup-files t)
;; Activer versions avec des valeurs par défaut (garder cinq dernières versions, je pense!)
(setq version-control t)
;; Save all backup file in this directory.
(setq backup-directory-alist (quote ((".*" . "~/.emacs.d/backups"))))
(setq delete-old-versions t)
;;;--------------------------------------------------------------------------------
;;;; UI
;;;; ................................................................................
(message "[✓]  Commencer UI")
(require 'which-key)
(which-key-mode)
;;;; BELL - pas le BELL
(defun my-terminal-visible-bell ()
   "Un effet de cloche visuel plus amical."
   (invert-face 'mode-line)
   (run-with-timer 0.1 nil 'invert-face 'mode-line))
(setq visible-bell nil
      ring-bell-function 'my-terminal-visible-bell)
;;; courte
(fset 'yes-or-no-p 'y-or-n-p)
(setq find-file-visit-truename t)
;;; MODE LINE
(defvar sml/no-confirm-load-theme t)
(defvar sml/theme 'light)
(sml/setup)
;;; scratch
(setq initial-scratch-message nil)
(setq frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "%b"))))
;;;;linum
(add-hook 'find-file-hook (lambda () (linum-mode 1)))
(defvar linum-format "%d ")
;;; Transparency
(message "[✓]  Commencer TRANSPARENCY")
;;(set-frame-parameter (selected-frame) 'alpha '(<active> [<inactive>]))
(set-frame-parameter (selected-frame) 'alpha '(100 100))
(add-to-list 'default-frame-alist '(alpha 100 100))
(eval-when-compile (require 'cl))
(defun toggle-transparency ()
  "Toggle transparency for frame."
  (interactive)
  (if (/=
       (cadr (frame-parameter nil 'alpha))
       100)
      (set-frame-parameter nil 'alpha '(100 100))
    (set-frame-parameter nil 'alpha '(85 50))))
;; Set transparency of emacs
(defun transparency (value)
  "Set the transparency of the frame window, (VALUE 0=transparent/100=opaque)."
  (interactive "nTransparency Value 0 - 100 opaque:")
  (set-frame-parameter (selected-frame) 'alpha value))
;;; autocomplete
(ac-config-default)
(setq company-idle-delay 0)
(add-hook 'after-init-hook 'global-company-mode)
;;; state and histories
(desktop-save-mode 1)
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 25)
(defvar savehist-file "~/.emacs.d/savehist")
(savehist-mode 1)
(setq history-length t)
(setq history-delete-duplicates t)
(defvar savehist-save-minibuffer-history 1)
(defvar savehist-additional-variables
      '(kill-ring
        search-ring
        regexp-search-ring
	compile-command))
(global-hl-line-mode 1)
;;;; FLYCHECK
(message "[✓]  Commencer FLYCHECK")
(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)
(setq flycheck-emacs-lisp-load-path 'inherit )
;;;; BOOKMARKS+
;;(require 'bookmark+)
;;;; BUFFERS
(message "[✓]  Commencer BUFFERS")
(require 'ibuffer)
(require 'ibuffer-git)
(defalias 'list-buffers 'ibuffer) ; make ibuffer default
(setq ibuffer-default-sorting-mode 'major-mode)
;;;					
(add-hook 'ibuffer-hook
	  (lambda ()
	    (ibuffer-auto-mode 1)
	    (ibuffer-projectile-set-filter-groups)
	    (ibuffer-vc-set-filter-groups-by-vc-root)
	    (unless (eq ibuffer-sorting-mode 'alphabetic)
	      (ibuffer-do-sort-by-alphabetic))))
;; Use human readable Size column instead of original one
(define-ibuffer-column size-h
  (:name "Size" :inline t)
  (cond
   ((> (buffer-size) 1000000) (format "%7.1fM" (/ (buffer-size) 1000000.0)))
   ((> (buffer-size) 100000) (format "%7.0fk" (/ (buffer-size) 1000.0)))
   ((> (buffer-size) 1000) (format "%7.1fk" (/ (buffer-size) 1000.0)))
   (t (format "%8d" (buffer-size)))))
;;nicely format the ibuffer and include git-status
(setq ibuffer-formats '((mark modified read-only git-status-mini " "
      (name 18 18 :left :elide)
      " "
      (size 9 -1 :right)
      " "
      (git-status 8 8 :left :elide)
      " "
      (mode 16 16 :left :elide)
      " "
      (vc-status 16 16 :left)
      " "
      (mode 16 16 :left :elide)
      " " filename-and-process)))
;;;; Systemes PROG et DevOps
(require 'Voight-Kampff-PROG)
;;;;
;;;; ................................................................................
;;;; INPUT AND KEYBINDINGS
;;;; ................................................................................
(message "[✓]   Commencer Keybindings")
(setq mac-option-modifier 'meta)
(setq mac-right-option-modifier nil)
;;;; Keybindings
(global-set-key "\M-v" 'golden-ratio-scroll-screen-down)
(global-set-key "\C-v" 'golden-ratio-scroll-screen-up)
(global-set-key (kbd "M-x") 'undefined)
(global-set-key "\C-x\C-m" 'helm-M-x)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key "\C-c\C-m" 'execute-extended-command)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key "\t" 'company-complete-common)
;;PROG
(global-set-key (kbd "M-<f2>") 'projectile-speedbar-open-current-buffer-in-tree)
(global-set-key (kbd "s-d") 'e2wm:dp-edbi)
;;UI
(global-set-key (kbd "C-c t") 'toggle-transparency)
(global-set-key (kbd "M-s-†") 'tabbar-mode)
(global-set-key (kbd "M-s-t") 'tabbar-mode)
(global-set-key (kbd "C-c e") 'eval-and-replace)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
(global-set-key (kbd "s-s") 'sr-speedbar-toggle)
(global-set-key (kbd "C-=") 'er/expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)
;;;(define-key origami-mode-map [C-tab] 'origami-recursively-toggle-node)
;;
(global-set-key (kbd "C-c r r") 'inf-ruby)
;;;; ................................................................................
;;;; start the server
;;;; ................................................................................
;;; FONTS
(set-face-attribute 'default nil
		    :family "Input Mono" :height 140 :weight 'normal)
(set-face-attribute 'fixed-pitch-serif nil
		    :family "Luxi Mono" :height 150 :weight 'normal)
(set-face-attribute 'variable-pitch nil
		    :family "Cardo" :height 160 :weight 'normal)
;;; org-mode
;; (add-hook 'org-mode-hook
;;             (lambda ()
;; 	      (variable-pitch-mode 1)))
;; (set-face-attribute 'org-table nil :inherit 'fixed-pitch)
;; (set-face-attribute 'org-code nil :inherit 'fixed-pitch)
;; (set-face-attribute 'org-block nil :inherit 'fixed-pitch)
;;;(fontsize . 14) (font . "-*-Input Mono-normal-normal-normal-*-14-*-*-*-m-0-iso10646-1")
(require 'org)
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
;;; Reading Modes
 (defun xah-toggle-read-novel-mode ()
  "Setup current buffer to be suitable for reading long novel/article text.
• Line wrap at word boundaries.
• Set a right margin.
• line spacing is increased.
• variable width font is used.
Call again to toggle back.
URL `http://ergoemacs.org/emacs/emacs_novel_reading_mode.html'
Version 2017-02-27"
  (interactive)
  (if (null (get this-command 'state-on-p))
      (progn
        (set-window-margins nil 0 9)
        (variable-pitch-mode 1)
        (setq line-spacing 0.4)
        (setq word-wrap t)
        (put this-command 'state-on-p t))
    (progn
      (set-window-margins nil 0 0)
      (variable-pitch-mode 0)
      (setq line-spacing nil)
      (setq word-wrap nil)
      (put this-command 'state-on-p nil)))
  (redraw-frame (selected-frame)))
;;;; END FONTS
;;;; 
;;; EMACS SERVER
;;;;
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(message "[✓]  Commencer SERVER")
(require 'server)
(unless (server-running-p) (server-start))
;;
(provide '.emacs)
;;; .emacs ends here
(message "[✓]  Commencer EMACS")

