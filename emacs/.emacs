;;; package --- .emacs
;Copyright (C) 2015 by Patrick Carr
;Time-stamp: <2018-02-21 22:12:29 cpc26>
;;; Commentary:
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
;;;
(setq debug-on-error t)
(add-to-list 'load-path "~/.emacs.d/lisp/")
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
;;; Code:
;; OS FIXES
(require 'Voight-Kampff-OS)
;; UI elements
(require 'Voight-Kampff-UI)
;; DOC elements
(require 'Voight-Kampff-DOC)

;--------------------------------------------------------------------------------
;;;;
;;;; ..............E N T E R P R I S E  Q U A L I T Y................................
(require 'POUBELLE)
;;;;
;;;; Systemes PROG et DevOps
(require 'Voight-Kampff-PROG)
;;;;
;;;; ................................................................................
;;;; INPUT AND KEYBINDINGS
;;;; ................................................................................
(message "[✓]  Commencer Keybindings")
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
;;
(global-set-key (kbd "C-c r r") 'inf-ruby)
;;;; ................................................................................
;;;; start the server
;;;; ................................................................................
;;; SUPER AI HACKS
(add-to-list 'load-path "/Users/cpc26/tmp/haxen/AI/NClos/nclosemacs")
(load-library "nclose.el")
;;; ML superPowers ignited
;;; FONTS
(set-face-attribute 'default nil
		    :family "Input Mono" :height 140 :weight 'normal)
(set-face-attribute 'fixed-pitch-serif nil
		    :family "Luxi Mono" :height 150 :weight 'normal)
(set-face-attribute 'variable-pitch nil
		    :family "Cardo" :height 160 :weight 'normal)
;;; org-mode
(add-hook 'org-mode-hook
            (lambda ()
	      (variable-pitch-mode 1)))
(set-face-attribute 'org-table nil :inherit 'fixed-pitch)
(set-face-attribute 'org-code nil :inherit 'fixed-pitch)
(set-face-attribute 'org-block nil :inherit 'fixed-pitch)
;;;(fontsize . 14) (font . "-*-Input Mono-normal-normal-normal-*-14-*-*-*-m-0-iso10646-1")
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
(message "[✓]  Commencer SERVER")
(require 'server)
(add-hook 'after-make-frame-functions 'cpc26/xmouse-enable)
(unless (server-running-p) (server-start))
;;
(provide '.emacs)
;;; .emacs ends here
(put 'downcase-region 'disabled nil)
(message "[✓]  Commencer EMACS")
(put 'upcase-region 'disabled nil)
