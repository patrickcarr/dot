;;; package --- .emacs
;Copyright (C) 2015 by Patrick Carr
;Time-stamp: <2017-05-29 00:19:50 cpc26>
;;; Commentary:
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(message "[✓]  Commencer PACKAGE-INIT")
(package-initialize)
(message "[✓]  Commencer CUSTOM")
;; default font to LispM
;;  anciens à l’honneur
(set-face-attribute 'default nil
                :family "LispM" :height 140 :weight 'regular)
(setq custom-file "~/.emacs-custom.el")
(load custom-file)
;;;; elpa
;;;; ................................................................................
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("marmalade" . "https://marmalade-repo.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
			 ("org" . "http://orgmode.org/elpa/")))
;;; Code:
;;;; OS FIXES
;;;; ................................................................................
(message "[✓]  Commencer OS FIXES")
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))
(let ((default-directory  "~/.emacs.d/lisp/"))
  (normal-top-level-add-subdirs-to-load-path))
(message "[✓]  OS X")
;;launchctl-el
;; Emacs recognize plist files as XML files:
(add-to-list 'auto-mode-alist '("\\.plist$" . nxml-mode))
; DEBIAN
(message "[✓]  DEBIAN")
;;;; BACKUPS and VERSIONING
;;;; ................................................................................
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
;;;; UI
;;;; ................................................................................
(message "[✓]  Commencer UI")
;;;--------------------------------------------------------------------------------
;;; FONTS
;; Use monospaced font faces in current buffer
(defun my-buffer-face-mode-fixed ()
   "Set a fixed width (monospace) font in current buffer."
   (interactive)
   (defvar buffer-face-mode-face '(:family "Anonymous Pro" :height 160))
   (buffer-face-mode))
;
;; Use fixed width font face Courier New in current buffer
(defun my-buffer-face-mode-courier ()
   "Set font to fixed width (monospace) font Courier New in current buffer."
   (interactive)
   (defvar buffer-face-mode-face '(:family "Courier New" :height 160 :width regular))
   (buffer-face-mode))
;
;; Use fixed width font face Mensch in current buffer
(defun my-buffer-face-mode-mensch ()
   "Set font to fixed width (monospace) font Mensch in current buffer."
   (interactive)
   (defvar buffer-face-mode-face '(:family "Mensch" :height 160 :width regular))
   (buffer-face-mode))
;
(defvar fixed-pitch '(:family "Anonymous Pro" :height 160 :width regular))
;
(defun setq-buffer-fixed-pitch ()
  "Set 'fixed-pitch-mode' to true."
    (interactive)
    (fixed-pitch-mode t))
;
;; add fixed for prog as default
(add-hook 'prog-mode-hook 'my-buffer-face-mode-fixed)
;; ========================================
;; Use variable width font faces in current buffer
(defun my-buffer-face-mode-variable ()
   "Set font to a variable width (proportional) fonts in current buffer."
   (interactive)
   (defvar buffer-face-mode-face '(:family "Symbola" :height 160 :width regular))
   (buffer-face-mode))
;
;; use Symbola as Variable-Pitch font
(defvar variable-pitch '(:family "Symbola" :height 160))
;
(defun setq-buffer-variable-pitch ()
  "Set 'variable-pitch-mode' to true."
    (interactive)
    (variable-pitch-mode t))
;
;; add variable for text as default
(add-hook 'text-mode-hook 'variable-pitch-mode)
;;; END FONTS
;;;--------------------------------------------------------------------------------
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
;;; iELM
(add-hook 'ielm-mode-hook 'setq-buffer-fixed-pitch)
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
(set-frame-parameter (selected-frame) 'alpha '(85 50))
(add-to-list 'default-frame-alist '(alpha 85 50))
(eval-when-compile (require 'cl))
(defun toggle-transparency ()
  "Toggle transparency for frame."
  (interactive)
  (if (/=
       (cadr (frame-parameter nil 'alpha))
       100)
      (set-frame-parameter nil 'alpha '(100 100))
    (set-frame-parameter nil 'alpha '(85 50))))
(global-set-key (kbd "C-c t") 'toggle-transparency)
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
(setq savehist-file "~/.emacs.d/savehist")
(savehist-mode 1)
(setq history-length t)
(setq history-delete-duplicates t)
(setq savehist-save-minibuffer-history 1)
(setq savehist-additional-variables
      '(kill-ring
        search-ring
        regexp-search-ring
	compile-command))
(global-hl-line-mode 1)
;;;; FLYCHECK
(message "[✓]  Commencer FLYCHECK")
(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)
;;;; BOOKMARKS+
(require 'bookmark+)
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
(add-hook 'ibuffer-mode-hook 'my-buffer-face-mode-fixed)
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
(global-set-key (kbd "C-c e") 'eval-and-replace)
;;; HELP
(require 'help+)
(require 'help-fns+)
(require 'help-mode+)
;;; DIRED
(message "[✓]  Commencer DIRED et OS X")
(require 'dired+)
;; dired avec OSX quiklook
(require 'dired)
(require 'cl)

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
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
;;;; SR-Speedbar
(message "[✓]  Commencer SPEEDBAR")
(which-function-mode 1)
(require 'sr-speedbar)
(speedbar-add-supported-extension ".lisp")
(speedbar-add-supported-extension ".js")
(add-to-list 'speedbar-fetch-etags-parse-list
             '("\\.js" . speedbar-parse-c-or-c++tag))
(setq speedbar-show-unknown-files t)
(setq speedbar-directory-unshown-regexp "^$")
(global-set-key (kbd "s-s") 'sr-speedbar-toggle)
;;;; autoexpand
(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)
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
(add-hook 'eshell-mode-hook 'my-buffer-face-mode-fixed)
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
(global-set-key (kbd "C-=") 'er/expand-region)
;;;; // END UI
;;;; ................................................................................
;;;; ORG
;;;; ................................................................................
(message "[✓]  Commencer ORG")
(require 'org)
(require 'org-bullets)
;; Set to the location of your Org files on your local system
(setq org-directory "~/org")
;; Set to the name of the file where new notes will be stored
(setq org-mobile-inbox-for-pull "~/org/flagged.org")
;; Set to <your Dropbox root directory>/MobileOrg.
(setq org-mobile-directory "~/Dropbox/Apps/MobileOrg")
(setq org-ellipsis "↴")
(defun set-buffer-variable-pitch ()
  "Main text variable, code and tables are fixed."
    (interactive)
    (variable-pitch-mode t)
    (setq line-spacing 3)
     (set-face-attribute 'org-table nil :inherit 'fixed-pitch)
     (set-face-attribute 'org-code nil :inherit 'fixed-pitch)
     (set-face-attribute 'org-block nil :inherit 'fixed-pitch)
     (set-face-attribute 'org-block-background nil :inherit 'fixed-pitch)
    )
(add-hook 'org-mode-hook 'set-buffer-variable-pitch)
;; set after so bullets appear
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
;; AucTeX
(message "[✓]  Commencer TEX")
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)
(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)
(setq TeX-PDF-mode t)
;; Use Skim as viewer, enable source <-> PDF sync
;; make latexmk available via C-c C-c
;; Note: SyncTeX is setup via ~/.latexmkrc (see below)
(add-hook 'LaTeX-mode-hook (lambda ()
  (push
    '("latexmk" "latexmk -pdf %s" TeX-run-TeX nil t
      :help "Run latexmk on file")
    TeX-command-list)
  (add-to-list 'TeX-command-list
	       '("XeLaTeX" "xelatex -interaction=nonstopmode %s" TeX-run-command t t :help "Run xelatex") t))
 )
(add-hook 'TeX-mode-hook '(lambda () (setq TeX-command-default "latexmk")))
;; use Skim as default pdf viewer
;; Skim's displayline is used for forward search (from .tex to .pdf)
;; option -b highlights the current line; option -g opens Skim in the background
(setq TeX-view-program-selection '((output-pdf "PDF Viewer")))
(setq TeX-view-program-list
      '(("PDF Viewer" "/Applications/Skim.app/Contents/SharedSupport/displayline -b -g %n %o %b")))
;;;; UML  E N T E R P R I S E  Q U A L I T Y COMMUNICATIONS
;;;; ................................................................................
(add-to-list
  'org-src-lang-modes '("plantuml" . plantuml))
;;;; E N T E R P R I S E  Q U A L I T Y COMMUNICATIONS
;; Enable plantuml-mode for PlantUML files
(add-to-list 'auto-mode-alist '("\\.plantuml\\'" . plantuml-mode))
;; MD MODE
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode))
;; display source code blocks or pre blocks in monospace
(eval-after-load "markdown-mode"
  '(mapc
    (lambda (face)
      (set-face-attribute
       face nil
       :inherit
       (my-adjoin-to-list-or-symbol
        'fixed-pitch
        (face-attribute face :inherit))))
    (list 'markdown-pre-face 'markdown-inline-code-face)))
;;;; REVEAL PRESENTATIONS
(require 'ox-reveal)
;;;; END E N T E R P R I S E  Q U A L I T Y COMMUNICATIONS
;;;; END ORG and DOC PREP
;;;; ................................................................................
;;; info et doc
(message "[✓]  Commencer DOCUMENTATION")
;;;; INFO
(require 'info+)
;;; display Info mode buffers in proportional font
;;; but code examples in monospace font
(defvar my-rx-info-code (rx bol "     " (* not-newline) eol))
(defun my-Info-font-lock ()
  "Use fixed fonts for code examples."
  (interactive)
  (require 'org)
  (font-lock-add-keywords
   nil
   `((,my-rx-info-code
      .
      ;; let's just use org-block
      (quote org-block)
      ))))
(add-hook 'Info-mode-hook 'my-Info-font-lock)
(add-hook 'Info-mode-hook 'my-buffer-face-mode-variable)
;;;; ELDOC
(require 'eldoc)
(require 'css-eldoc)
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)
(add-hook 'css-mode-hook 'turn-on-css-eldoc)
;(add-hook 'js-mode-hook 'turn-on-javascript-eldoc)
;;;; END DOCUMENTATION
;;; HELM
;;;; ................................................................................
(message "[✓]  Commencer HELM")
;; https://github.com/xiaohanyu/oh-my-emacs/blob/master/core/ome-completion.org
;; 
;; http://tuhdo.github.io/helm-intro.html
(setq locate-command "mdfind")
(require 'helm-config)
(when (executable-find "curl")
  (setq helm-google-suggest-use-curl-p t))
(helm-mode 1)
(helm-autoresize-mode 1)
(setq helm-M-x-fuzzy-match t) ;; optional fuzzy matching for helm-M-x
(setq helm-buffers-fuzzy-matching t
      helm-recentf-fuzzy-match    t)
(setq helm-semantic-fuzzy-match t
      helm-imenu-fuzzy-match    t)
(add-to-list 'helm-sources-using-default-as-input 'helm-source-man-pages)
(setq helm-locate-command "mdfind -name %s %s")
;; helm-flycheck - show flycheck error2
(eval-after-load 'flycheck
  '(define-key flycheck-mode-map (kbd "C-c ! h") 'helm-flycheck))
(add-hook 'helm-major-mode-hook 'my-buffer-face-mode-courier)
;;;; ................................................................................
;;;; litteraire
;;;; ................................................................................
(message "[✓]  Commencer Litteraire")
(flycheck-define-checker proselint
  "A linter for prose."
  :command ("proselint" source-inplace)
  :error-patterns
  ((warning line-start (file-name) ":" line ":" column ": "
        (id (one-or-more (not (any " "))))
        (message) line-end))
  :modes (text-mode markdown-mode gfm-mode))
(require 'helm-org-rifle)
(add-to-list 'flycheck-checkers 'proselint)
;--------------------------------------------------------------------------------
;;;;
;;;; ..............E N T E R P R I S E  Q U A L I T Y................................
;;;;
(message "[✓]  Commencer Tech POUBELLE")
;;;; tech poubelle
;;;; Angular - "it gets its own section"
(message "[✓]    Start Angular")
;; angular-mode
;; angular-html-mode
;; (add-to-list 'yas-snippet-dirs "/path/to/angularjs-mode/snippets")
;; (add-to-list 'ac-dictionary-directories "/path/to/angularjs-mode/ac-dict")
;; (add-to-list 'ac-modes 'angular-mode)
;; (add-to-list 'ac-modes 'angular-html-mode)
;; ng-2 mode
(message "[✓]      TypeScript")
;;; Typescript and TIDE and TSSERVER
(message "[✓]      FLOW STATIC TYPE CHECKER")
;;; NPM MODE
(message "[✓]    Start NPM")
(npm-global-mode)
;;; YAML
(message "[✓]    Start YAML")
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
;; YAML Lint https://github.com/adrienverge/yamllint
;; sudo pip install yamllint
(require 'flycheck-yamllint)
(eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook 'flycheck-yamllint-setup))
;;; ansible
(message "[✓]    Start Ansible")
(add-hook 'yaml-mode-hook #'ansible-doc-mode)
; RUBY - this is not in dev since we are not doing rails
(message "[✓]    Start RUBY")
;;(add-hook 'ruby-mode-hook 'projectile-on)
(require 'robe)
(add-hook 'ruby-mode-hook 'robe-mode)
(add-hook 'projectile-mode-hook 'projectile-rails-on)
(global-set-key (kbd "C-c r r") 'inf-ruby)
(add-hook 'after-init-hook 'inf-ruby-switch-setup)
(add-to-list 'auto-mode-alist
             '("\\.\\(?:gemspec\\|irbrc\\|gemrc\\|rake\\|rb\\|ru\\|thor\\)\\'" . ruby-mode))
(add-to-list 'auto-mode-alist
             '("\\(Capfile\\|Gemfile\\(?:\\.[a-zA-Z0-9._-]+\\)?\\|[rR]akefile\\)\\'" . ruby-mode))
(require 'flymake-ruby)
(add-hook 'ruby-mode-hook 'flymake-ruby-load)
;; Turn on eldoc in ruby files to display info about the
;; method or variable at point
(add-hook 'ruby-mode-hook 'eldoc-mode)
(message "[✓]    End RUBY")
;; Puppet
(message "[✓]    Start Puppet")
;;(autoload 'puppet-mode "puppet-mode" "Major mode for editing puppet manifests")
;(add-to-list 'auto-mode-alist '("\\.pp$" . puppet-mode))
(message "[✓]    End Puppet")
;;;; end tech poubelle
;;;;
;;;;
;;;; Systemes PROG et DevOps
(message "[✓]  Commencer DevOps")
(require 'generic-x)
; NGINX
(require 'nginx-mode)
(add-to-list 'auto-mode-alist '("/nginx/sites-\\(?:available\\|enabled\\)/" . nginx-mode))
(message "[✓]    NGINX")
;;;;
;;;; ................................................................................
;;;;
;;;; ...............PROG.............................................................
(message "[✓]  Commencer PROG")
;;;; ................................................................................
;;; compile buffer bury
(bury-successful-compilation 1)
;;;; MAGIT
(message "[✓]    MAGIT and GIT")
(global-auto-revert-mode 1)
(setq magit-repository-directories '( "~/src" ))
(setq auto-revert-check-vc-info t)
;;; GIT-WIP
(add-to-list 'exec-path "~/opt/git-wip/")
(load "~/opt/git-wip/emacs/git-wip.el")
(message "[✓] git-wip and git-wip-timemachine")
; projectile
(projectile-global-mode)
(global-set-key (kbd "M-<f2>") 'projectile-speedbar-open-current-buffer-in-tree)
(message "[✓]    Projectile")
;;;; REGEX
(require 'foreign-regexp)
(custom-set-variables
   '(foreign-regexp/regexp-type 'javascript) ;; Choose your taste of foreign regexp
                                       ;; from 'perl, 'ruby, 'javascript or
                                       ;; 'python.
   '(reb-re-syntax 'foreign-regexp))   ;; Tell re-builder to use foreign regexp.
;;; flyspell-prog
(add-hook 'prog-mode-hook 'flyspell-prog-mode)
(message "[✓]    flyspell-prog-mode")
;;; rainbow delimeters
(require 'rainbow-delimiters)
;(global-rainbow-delimiters-mode) was removed, too much work
;; - To enable it in all programming-related emacs modes (Emacs 24+):
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
(message "[✓]    rainbow-delimeters")
;; flycheck-plantuml
(with-eval-after-load 'flycheck
  (require 'flycheck-plantuml)
  (flycheck-plantuml-setup))
;;;; Electric pairs
;; auto close bracket insertion. New in emacs 24
(electric-pair-mode 1)
(message "[✓]    electric-pair")
(message "[✓]    Start App Dev:: SQL")
(message "*****")
;;M-x package-install edbi
;;cpan RPC::EPC::Service
(require 'edbi)
(autoload 'e2wm:dp-edbi "e2wm-edbi" nil t)
(global-set-key (kbd "s-d") 'e2wm:dp-edbi)
(message "[✓]    end SQL")
(message "*****")
;; END SQL
;;;; LISPS
;;;; ................................................................................
(message "[✓]    Commencer LISP")
(show-paren-mode 1)
;;;; GUILE GEISER SCHEME
(require 'ac-geiser)
(add-hook 'geiser-mode-hook 'ac-geiser-setup)
(add-hook 'geiser-repl-mode-hook 'ac-geiser-setup)
(eval-after-load "auto-complete"
  '(add-to-list 'ac-modes 'geiser-repl-mode))
;;;; COMMON LISP
(load (expand-file-name "~/quicklisp/slime-helper.el"))
(setq inferior-lisp-program "/usr/local/bin/sbcl")
(setq slime-contribs '(slime-fancy))
;;;; slime-scratch
(setq slime-scratch-file (expand-file-name "~/.slime/slime-scratch.lisp"))
;;;;  slime-auto complete
(require 'ac-slime)
(add-hook 'slime-mode-hook 'set-up-slime-ac)
(add-hook 'slime-repl-mode-hook 'set-up-slime-ac)
(eval-after-load "auto-complete"
  '(add-to-list 'ac-modes 'slime-repl-mode))
;;;; fuzzy
(require 'slime-fuzzy)
(global-set-key (kbd "<tab>") 'slime-fuzzy-complete-symbol)
;;;; slime-mode hook
;; (add-hook 'slime-mode-hook
;;           (lambda ()
;;             (unless (slime-connected-p)
;;               (save-excursion (slime)))))
;; (add-hook 'slime-mode-hook
;;     (lambda ()
;;       (set-variable lisp-indent-function 'common-lisp-indent-function)
;;       (slime-define-key "\r" 'newline-and-indent)
;;       (slime-define-key [(control ?/)] 'backward-up-list)
;;       (slime-define-key [(control ?=)] 'down-list)
;;       (slime-define-key [tab] 'slime-indent-and-complete-symbol)
;;       (slime-define-key [(control c) tab] 'slime-complete-form)
;;       (slime-define-key [f13] 'slime-cheat-sheet)))
;;;; CLIPS
(require 'clips-mode)
(setq inferior-clips-program "clips")
;;;; ESS-R
;; (require 'ess-site)
;; (setq ess-eval-visibly nil)
;; (define-key ac-completing-map (kbd "M-h") 'ac-quick-help)
;;;; ................................................................................
;;;; Javascript
(message "[✓]    Commencer JS")
;;;; JSON
(require 'flycheck-demjsonlint)
(message "[✓]      Start App Dev:: JavaScript-Web")
;;;; JS2-MODE
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-hook 'js2-mode-hook 'js2-imenu-extras-mode)
(add-hook 'js2-mode-hook 'ac-js2-mode)
(setq ac-js2-evaluate-calls t)
(setq js2-highlight-level 3)
(js2-imenu-extras-mode)
;; node
(add-to-list 'interpreter-mode-alist '("node" . js2-mode))
;;; VAR higlight
;; (require 'js2-highlight-vars)
;; (if (featurep 'js2-highlight-vars)
;;     (js2-highlight-vars-mode))
(eval-after-load "js2-highlight-vars-autoloads"
  '(add-hook 'js2-mode-hook (lambda () (js2-highlight-vars-mode))))
(add-hook 'js2-mode-hook (lambda ()
                           (tern-mode)))
(message "[✓]      Start App Dev:: JavaScript::JSLint")
(require 'flymake-easy)
(require 'flymake-jslint)
(add-hook 'js-mode-hook 'flymake-jslint-load)
(add-hook 'js2-mode-hook 'flymake-jslint-load)
;;; JS2-REFACTOR
(message "[✓]    JS2-REFACTOR")
(require 'js2-refactor)
(add-hook 'js2-mode-hook #'js2-refactor-mode)
(js2r-add-keybindings-with-prefix "C-c r")
;; ; paredit
;; (defun my-paredit-nonlisp ()
;;   "Turn on paredit mode for non-lisps."
;;   (interactive)
;;   (set (make-local-variable 'paredit-space-for-delimiter-predicates)
;;        '((lambda (endp delimiter) nil)))
;;   (paredit-mode 1))
;; (add-hook 'js2-mode-hook 'my-paredit-nonlisp)
;; (define-key js2-mode-map "{" 'paredit-open-curly)
;; (define-key js2-mode-map "}" 'paredit-close-curly-and-newline)
;;;; Tern
(add-to-list 'load-path "~/opt/tern/emacs")
(autoload 'tern-mode "tern.el" nil t)
(add-hook 'js-mode-hook (lambda () (tern-mode t)))
(add-hook 'js2-mode-hook (lambda () (tern-mode t)))
;(define-key tern-mode-keymap [(control ?c) (control ?t)] 'tern-get-type)
(eval-after-load 'tern
   '(progn
      (require 'tern-auto-complete)
      (tern-ac-setup)))
;;;; ................................................................................
;;;; JS related DOM and WEB
;;;; WEB MODE
(message "[✓]    WEB-MODE")
;
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.hbs\\'" . web-mode))
(add-to-list 'web-mode-ac-sources-alist
             '("html" . (ac-source-html-tag
                         ac-source-html-attribute)))
;; engines a-list
(setq web-mode-engines-alist
      '(("\\.hbs\\" . "ctemplate"))
      )
;; hooks and custom for web-mode
(defun web-mode-hook ()
  "Hooks for Web mode."
(setq web-mode-markup-indent-offset 2) )
;;indent
(add-hook 'web-mode-hook 'web-mode-hook)
;(add-hook 'web-mode-hook 'tagedit-mode)
(setq web-mode-markup-indent-offset 2)
(setq web-mode-css-indent-offset 2)
(setq web-mode-code-indent-offset 2)
(setq web-mode-indent-style 2)
;;padding
(setq web-mode-style-padding 1)
(setq web-mode-script-padding 1)
(setq web-mode-block-padding 0)
;; comment style
(setq web-mode-comment-style 2)
;; highlight
;;(set-face-attribute 'web-mode-css-rule-face nil :foreground "Pink3")
;;navigate tags
(setq web-mode-ac-sources-alist
  '(("css" . (ac-source-css-property))
    ("html" . (ac-source-words-in-buffer ac-source-abbrev))))
(add-hook 'web-mode-before-auto-complete-hooks
          '(lambda ()
             (let ((web-mode-cur-language
                    (web-mode-language-at-pos)))
               (if (string= web-mode-cur-language "php")
                   (yas-activate-extra-mode 'php-mode)
                 (yas-deactivate-extra-mode 'php-mode))
               (if (string= web-mode-cur-language "css")
                   (setq emmet-use-css-transform t)
                 (setq emmet-use-css-transform nil)))))
(define-key web-mode-map (kbd "C-n") 'web-mode-tag-match)
;;(setq web-mode-enable-current-element-highlight t)
(setq web-mode-enable-current-column-highlight t)
;;;tagedit
;;;; emmet . and tagedit . conflict
;;(tagedit-add-experimental-features)
(eval-after-load "sgml-mode"
  '(progn
     (require 'tagedit)
     (tagedit-add-paredit-like-keybindings)
     (add-hook 'html-mode-hook (lambda () (tagedit-mode 1)))))
(message "[✓]    end web-mode")
;; END WEBMODE
;;;; ................................................................................
(message "[✓]      web-beautify")
(eval-after-load 'js2-mode
  '(define-key js2-mode-map (kbd "C-c b") 'web-beautify-js))
;; Or if you're using 'js-mode' (a.k.a 'javascript-mode')
(eval-after-load 'js
  '(define-key js-mode-map (kbd "C-c b") 'web-beautify-js))
(eval-after-load 'json-mode
  '(define-key json-mode-map (kbd "C-c b") 'web-beautify-js))
(eval-after-load 'sgml-mode
  '(define-key html-mode-map (kbd "C-c b") 'web-beautify-html))
(eval-after-load 'css-mode
  '(define-key css-mode-map (kbd "C-c b") 'web-beautify-css))
;;;; ................................................................................
;;;; O-O-O-O-O-O-O-O-O-O-O-O-O-( COLOR WEB )-O-O-O-O-O-O-O-O-O-O-O-O-O
;;;; ................................................................................
(message "[✓]    START COLOR")
;; color.el
;; hsl
;; RGB
;;
;;  Various Color tools
;;
(require 'color)
(message "[✓]      XAH css")
(defvar xcm-color-names nil "A list of CSS color names.")
(setq xcm-color-names
'("aliceblue" "antiquewhite" "aqua" "aquamarine" "azure" "beige" "bisque" "black" "blanchedalmond" "blue" "blueviolet" "brown" "burlywood" "cadetblue" "chartreuse" "chocolate" "coral" "cornflowerblue" "cornsilk" "crimson" "cyan" "darkblue" "darkcyan" "darkgoldenrod" "darkgray" "darkgreen" "darkgrey" "darkkhaki" "darkmagenta" "darkolivegreen" "darkorange" "darkorchid" "darkred" "darksalmon" "darkseagreen" "darkslateblue" "darkslategray" "darkslategrey" "darkturquoise" "darkviolet" "deeppink" "deepskyblue" "dimgray" "dimgrey" "dodgerblue" "firebrick" "floralwhite" "forestgreen" "fuchsia" "gainsboro" "ghostwhite" "gold" "goldenrod" "gray" "green" "greenyellow" "grey" "honeydew" "hotpink" "indianred" "indigo" "ivory" "khaki" "lavender" "lavenderblush" "lawngreen" "lemonchiffon" "lightblue" "lightcoral" "lightcyan" "lightgoldenrodyellow" "lightgray" "lightgreen" "lightgrey" "lightpink" "lightsalmon" "lightseagreen" "lightskyblue" "lightslategray" "lightslategrey" "lightsteelblue" "lightyellow" "lime" "limegreen" "linen" "magenta" "maroon" "mediumaquamarine" "mediumblue" "mediumorchid" "mediumpurple" "mediumseagreen" "mediumslateblue" "mediumspringgreen" "mediumturquoise" "mediumvioletred" "midnightblue" "mintcream" "mistyrose" "moccasin" "navajowhite" "navy" "oldlace" "olive" "olivedrab" "orange" "orangered" "orchid" "palegoldenrod" "palegreen" "paleturquoise" "palevioletred" "papayawhip" "peachpuff" "peru" "pink" "plum" "powderblue" "purple" "red" "rosybrown" "royalblue" "saddlebrown" "salmon" "sandybrown" "seagreen" "seashell" "sienna" "silver" "skyblue" "slateblue" "slategray" "slategrey" "snow" "springgreen" "steelblue" "tan" "teal" "thistle" "tomato" "turquoise" "violet" "wheat" "white" "whitesmoke" "yellow" "yellowgreen")
 )
;;;   XAH LEE's HEX COLOR IN BUFFER
(defun xah-syntax-color-hex ()
"Syntax color hex color spec such as 「#ff1100」 in current buffer."
  (interactive)
  (font-lock-add-keywords
   nil
   '(("#[abcdef[:digit:]]\\{6\\}"
      (0 (put-text-property
          (match-beginning 0)
          (match-end 0)
          'face (list :background (match-string-no-properties 0)))))))
  (font-lock-fontify-buffer)
  )
(defun xah-syntax-color-hsl ()
  "Syntax color hex color spec such as 「hsl(0,90%,41%)」 in current buffer."
  (interactive)
  (font-lock-add-keywords
   nil
  '(("hsl( *\\([0-9]\\{1,3\\}\\) *, *\\([0-9]\\{1,3\\}\\)% *, *\\([0-9]\\{1,3\\}\\)% *)"
     (0 (put-text-property
         (+ (match-beginning 0) 3)
         (match-end 0)
         'face (list :background
 (concat "#" (mapconcat 'identity
                        (mapcar
                         (lambda (x) (format "%02x" (round (* x 255))))
                         (color-hsl-to-rgb
                          (/ (string-to-number (match-string-no-properties 1)) 360.0)
                          (/ (string-to-number (match-string-no-properties 2)) 100.0)
                          (/ (string-to-number (match-string-no-properties 3)) 100.0)
                          ) )
                        "" )) ;  "#00aa00"
                      ))))) )
  (font-lock-fontify-buffer)
  )
(add-hook 'css-mode-hook 'xah-syntax-color-hex)
(add-hook 'php-mode-hook 'xah-syntax-color-hex)
(add-hook 'html-mode-hook 'xah-syntax-color-hex)
(add-hook 'css-mode-hook 'xah-syntax-color-hsl)
(add-hook 'php-mode-hook 'xah-syntax-color-hsl)
(add-hook 'html-mode-hook 'xah-syntax-color-hsl)
(message "[✓]    COLOR DONE")
;;;; ................................................................................
(message "[✓]    CSS")
;;;; EMMET
;; Place point in a emmet snippet and press C-j to expand it
;; (or alternatively, alias your preferred keystroke to M-x emmet-expand-line)
;; and you'll transform your snippet into the appropriate tag structure.
(add-hook 'sgml-mode-hook 'emmet-mode) ; Auto-start on any markup modes
(add-hook 'css-mode-hook  'emmet-mode) ; enable Emmet's css abbreviation.
(add-hook 'web-mode-hook 'emmet-mode)  ; Auto-start on web mode
(add-hook 'emmet-mode-hook (lambda () (setq emmet-indentation 2))) ;; indent 2 spaces.
(setq emmet-move-cursor-between-quotes t) ;; default nil
;;(add-to-list 'auto-mode-alist '("\\.html?\\'" . emmet-mode))
;;; ac-emmet
(add-hook 'sgml-mode-hook 'ac-emmet-html-setup)
(add-hook 'css-mode-hook 'ac-emmet-css-setup)
(add-hook 'html-mode-hook 'ac-emmet-html-setup)
(add-hook 'web-mode-hook 'ac-emmet-html-setup)
(setq emmet-preview-default t)
(message "[✓]    emmet-mode")
;; END EMMET
;;;; SCSS-MODE
;; https://github.com/antonj/.emacs.d/blob/master/aj-compilation.el
(message "[✓]  scss-mode")
;;; migrate to package from elisp file
;;(add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp/scss-mode-el"))
(autoload 'scss-mode "scss-mode")
(add-to-list 'auto-mode-alist '("\\.scss$" . scss-mode))
(require 'flymake-sass)
(add-hook 'sass-mode-hook 'flymake-sass-load)
(add-hook 'scss-mode-hook 'flymake-sass-load)
(require 'flymake-css)
(add-hook 'css-mode-hook 'flymake-css-load)
;; autocomplete
(add-hook 'sass-mode-hook 'auto-complete-mode)
(add-hook 'scss-mode-hook 'auto-complete-mode)
;;; flycheck scss-lint
(add-hook 'scss-mode-hook 'flycheck-mode)
;; END SCSS
;; END CSS
;;;; ................................................................................
;;;;
;;;; end JS
;;;;
;;;; ................................................................................
(message "[✓]  Commencer E N T E R P R I S E  Q U A L I T Y")
;;;; ................................................................................
(require 'eclim)
(setq eclimd-autostart t)
(custom-set-variables
  '(eclim-eclipse-dirs '("~/eclipse/java-neon/Eclipse.app/Contents/Eclipse/"))
  '(eclim-executable "~/eclipse/java-neon/Eclipse.app/Contents/Eclipse/eclim")
  '(eclimd-default-workspace "~/src/java"))
(add-hook 'java-mode-hook 'eclim-mode)
;;; Displaying compilation error messages in the echo area
(setq help-at-pt-display-when-idle t)
(setq help-at-pt-timer-delay 0.1)
(help-at-pt-set-timer)
;; add the emacs-eclim source
;(require 'ac-emacs-eclim-source)
(ac-emacs-eclim-config)
;;;; ................................................................................
;;;; END PROG
;;;; ................................................................................
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

(provide '.emacs)
;;; .emacs ends here
(put 'downcase-region 'disabled nil)
(message "[✓]  Commencer EMACS")
(put 'upcase-region 'disabled nil)
