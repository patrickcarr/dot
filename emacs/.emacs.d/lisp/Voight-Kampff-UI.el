;;; Voight-Kampff-UI.el --- UI features and behaviours

;; Copyright (C) 2015-2016  Colin Carr

;; Author: Colin Carr <cpc26@member.fsf.org>
;; Keywords: UI, Voight-Kampff

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;;;   UI elements
;;;   Tastefully drawn from the Internet
;;

;;; Code:
;;;--------------------------------------------------------------------------------
;;;; UI
;;;; ................................................................................
(message "[✓]  Commencer UI")

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
;;;; TABBAR
(message "[✓]  Commencer TABBAR")
(require 'tabbar)
(setq tabbar-use-images nil)
;; Add a buffer modification state indicator in the tab label, and place a
;; space around the label to make it looks less crowd.
(defadvice tabbar-buffer-tab-label (after fixup_tab_label_space_and_flag activate)
  "Add a buffer modification state indicator in the tab label, and place a space around the label to make it look less crowded."
  (setq ad-return-value
	(if (and (buffer-modified-p (tabbar-tab-value tab))
		 (buffer-file-name (tabbar-tab-value tab)))
	    (concat " + " (concat ad-return-value " "))
	  (concat " " (concat ad-return-value " ")))))

;; Called each time the modification state of the buffer changed.
(defun ztl-modification-state-change ()
   "Called each time the modification state of the buffer changed."
  (tabbar-set-template tabbar-current-tabset nil)
  "Template and tab sets."
  (tabbar-display-update))

;; First-change-hook is called BEFORE the change is made.
(defun ztl-on-buffer-modification ()
  "First-change-hook is called BEFORE the change is made."
  (set-buffer-modified-p t)
  "Is buffer modified?"
  (ztl-modification-state-change))
(add-hook 'after-save-hook 'ztl-modification-state-change)

;; This doesn't work for revert, I don't know.
(add-hook 'after-revert-hook 'ztl-modification-state-change)
(add-hook 'first-change-hook 'ztl-on-buffer-modification)
;; Group by directory
    (tabbar-mode t)
    (setq tabbar-cycle-scope 'tabs)
    (setq tabbar-buffer-groups-function
          (lambda ()
              (let ((dir (expand-file-name default-directory)))
            (cond ((member (buffer-name) '("*Completions*"
                           "*scratch*"
                           "*Messages*"
                           "*Ediff Registry*"))
               (list "#misc"))
              ((string-match-p "/.emacs.d/" dir)
               (list ".emacs.d"))
              (t (list dir))))))
;;; turn off enterprise tabs M-s t to toggle
(tabbar-mode 0)
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
;;; adventures in scrolling
;; Enable mouse support
(message "[✓]  Commencer MOUSE et SCROLL")
(setq mouse-wheel-scroll-amount '(0.07)) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
;; (setq scroll-step 1)
;; ;; Delay updates to give Emacs a chance for other changes
;; (setq linum-delay t)
;; ;; scrolling to always be a line at a time
;; (setq scroll-conservatively 10000)
;; (setq auto-window-vscroll nil)
;; (global-set-key (kbd "<C-mouse-4>") 'scroll-down-line)
;; (global-set-key (kbd "<C-mouse-5>") 'scroll-up-line)
;; if started emacs -nw
(unless window-system
  (require 'mouse)
  (xterm-mouse-mode t)
  (global-set-key [mouse-4] (lambda ()
                              (interactive)
                              (scroll-down 1)))
  (global-set-key [mouse-5] (lambda ()
                              (interactive)
                              (scroll-up 1)))
  (defun track-mouse (e))
  (defvar mouse-sel-mode t))
(defun cpc26/xmouse-enable (frame)
  "Active xterm mouse and scroll from make FRAME."
  (if (display-graphic-p)
      (progn
  (require 'mouse)
  (xterm-mouse-mode t)
(global-set-key [mouse-4] (lambda ()
                              (interactive)
                              (scroll-down 1)))
(global-set-key [mouse-5] (lambda ()
                              (interactive)
                              (scroll-up 1)))
  (defun track-mouse (e))
  (defvar mouse-sel-mode t))))
;;; window sizing
(require 'golden-ratio)
(golden-ratio-mode 1)
(require 'golden-ratio-scroll-screen)
;;; autocomplete
(ac-config-default)
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
;;;; TRAMP
(require 'tramp)
(setq tramp-default-method "ssh")
;;;;  EVAL and REPLACE
(defun eval-and-replace ()
  "Replace the preceding sexp with its value."
  (interactive)
  (backward-kill-sexp)
  (condition-case nil
      (prin1 (eval (read (current-kill 0)))
             (current-buffer))
    (error (message "Invalid expression")
           (insert (current-kill 0)))))
;;; HELP
;; (require 'help+)
;; (require 'help-fns+)
;; (require 'help-mode+)
;;; DIRED
(message "[✓]  Commencer DIRED et OS X")
;(require 'dired+)
;; dired avec OSX quiklook
(require 'dired)
(require 'cl)
;;; TODO resolve this warning
(defvar my-dired-spawn nil)
(make-variable-buffer-local 'my-dired-spawn)
;; http://stackoverflow.com/a/20023781/2112489
(defun my-dired-kill-last-process-named (name)
"NAME of process, function initially written by @wvxvw, and revised by @lawlist."
  (let (p)
    (cl-loop with name-re =
             (format "^%s\\(?:<\\([[:digit:]]+\\)>\\)?" (regexp-quote name))
     for process in (process-list)
     for pname = (process-name process)
     if (string-match name-re pname)
     collect (cons (string-to-number (or (match-string 1 pname) "0")) process)
     into processes
     finally
      (let ((process (cdar (cl-sort processes '> :key 'car))))
        (when (and process (get-process process))
          (delete-process process)
          (setq p process)))) p))
(defun my-dired-qlmanage ()
  "Press space and get preview of image of file at point."
(interactive)
  (unless (my-dired-kill-last-process-named "qlmanage")
    (let* ((current-node (dired-get-file-for-visit)))
      (set-process-sentinel
        (start-process "qlmanage" nil "/usr/bin/qlmanage" "-p" current-node)
        (lambda (p e)
          (setq e (replace-regexp-in-string "\n$" "" e))
          (cond
            ((and (null my-dired-spawn) (= 9 (process-exit-status p)))
              (message "OFF: my-dired-qlmanage (%s) | %s | %s"
              (process-exit-status p) p e))
            ((and my-dired-spawn (= 9 (process-exit-status p)))
              (message "OFF/ON: my-dired-qlmanage (%s) | %s | %s"
              (process-exit-status p) p e)
              (my-dired-kill-spawn))
            ((= 0 (process-exit-status p))
              (message "OFF (mouse clicked): my-dired-qlmanage (%s) | %s | %s"
              (process-exit-status p) p e))
            (t
              (message "ABNORMAL: my-dired-qlmanage (%s) | %s | %s"
              (process-exit-status p) p e))))))))

(defun my-dired-kill-spawn ()
"This is essentially a three level incursion, starting with `my-dired-qlmanage' and then calling `my-dired-kill-spawn' twice."
(interactive)
  (let* ((current-node (dired-get-file-for-visit)))
    (set-process-sentinel
      (start-process "qlmanage" nil "/usr/bin/qlmanage" "-p" current-node)
      (lambda (p e)
        (setq e (replace-regexp-in-string "\n$" "" e))
        (cond
          ((and (null my-dired-spawn) (= 9 (process-exit-status p)))
            (message "OFF: my-dired-kill-spawn (%s) | %s | %s"
              (process-exit-status p) p e))
          ((and my-dired-spawn (= 9 (process-exit-status p)))
            (message "OFF/ON: my-dired-kill-spawn (%s) | %s | %s"
              (process-exit-status p) p e)
            (my-dired-kill-spawn))
          ((= 0 (process-exit-status p))
            (message "OFF (mouse clicked): my-dired-kill-spawn (%s) | %s | %s"
              (process-exit-status p) p e))
          (t
            (message "ABNORMAL: my-dired-kill-spawn (%s) | %s | %s"
              (process-exit-status p) p e)))))))
(defun my-dired-previous-line (arg)
  "Kill the process and move to previous line ARG."
(interactive "^p")
  (dired-previous-line arg)
  (let ((my-dired-spawn t))
    (my-dired-kill-last-process-named "qlmanage")))
(defun my-dired-next-line (arg)
  "Kill the process and move to next lines ARG."
(interactive "^p")
  (dired-next-line arg)
  (let ((my-dired-spawn t))
    (my-dired-kill-last-process-named "qlmanage")))
(defun my-dired-quicklook ()
  "Key bindings for quick preview in dired os x."
(interactive)
  (my-dired-qlmanage))
(eval-after-load "dired" '(progn
  (define-key dired-mode-map [down] 'my-dired-next-line)
  (define-key dired-mode-map [up] 'my-dired-previous-line)
  (define-key dired-mode-map (kbd "SPC") 'my-dired-quicklook)))
;;;; Multiple Cursors
(message "[✓]  Commencer BUFFERS - multiple cursors")
(require 'multiple-cursors)
;;;; SR-Speedbar
(message "[✓]  Commencer SPEEDBAR")
(which-function-mode 1)
(require 'sr-speedbar)
(speedbar-add-supported-extension ".lisp")
(speedbar-add-supported-extension ".js")
(add-to-list 'speedbar-fetch-etags-parse-list
             '("\\.js$" . speedbar-parse-c-or-c++tag))
(setq speedbar-show-unknown-files t)
(setq speedbar-directory-unshown-regexp "^$")
;;;; autoexpand
(require 'expand-region)
;;;; // END UI
;;;; ESHELL
(message "[✓]  Commencer ESHELL")
(with-eval-after-load "esh-opt"
  (autoload 'epe-theme-lambda "eshell-prompt-extras")
  (defvar eshell-highlight-prompt nil)
  (defvar eshell-prompt-function 'epe-theme-lambda))
(add-hook 'eshell-mode-hook 'eshell-fringe-status-mode)
(require 'esh-help)
(setup-esh-help-eldoc)  ;; To use eldoc in Eshell
;;;; COMMUNICATIONS
;;; EMAIL
;; Mutt support.
(setq auto-mode-alist (append '(("/tmp/mutt.*" . mail-mode)) auto-mode-alist))
(add-to-list 'auto-mode-alist '("/mutt" . mail-mode))
(add-hook 'mail-mode-hook 'turn-on-auto-fill)
;;; DRAG STUFF
(drag-stuff-global-mode 1)
(drag-stuff-define-keys)
(add-to-list 'drag-stuff-except-modes 'org-mode)
;;; expand region
(require 'expand-region)
;;;; // END UI
(provide 'Voight-Kampff-UI)
;;; Voight-Kampff-UI.el ends here
