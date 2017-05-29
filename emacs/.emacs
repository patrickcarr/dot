;;; package --- .emacs
;Copyright (C) 2015 by Patrick Carr
;Time-stamp: <2017-05-29 09:59:19 cpc26>
;;; Commentary:
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
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
(require 'POUBELLE.)
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
;;;; ................................................................................
;;;; start the server
;;;; ................................................................................
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
