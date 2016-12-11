;;; package --- .emacs
;Copyright (C) 2015 by Patrick Carr
;Time-stamp: <2016-12-04 22:30:07 cpc26>
;;; Commentary:
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(message "[✓]  Commencer PACKAGE-INIT")
(package-initialize)
(message "[✓]  Commencer CUSTOM")
(setq custom-file "~/.emacs-custom.el")
(load custom-file)
;;;; elpa
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("marmalade" . "https://marmalade-repo.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
			 ("org" . "http://orgmode.org/elpa/")))
;;; Code:
;;;; OS FIXES
(message "[✓]  Commencer OS FIXES")
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))
(let ((default-directory  "~/.emacs.d/lisp/"))
  (normal-top-level-add-subdirs-to-load-path))
;;;; BACKUPS and VERSIONING
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
(message "[✓]  Commencer UI")
(fset 'yes-or-no-p 'y-or-n-p)
(setq find-file-visit-truename t)
;;; MODE LINE
(setq sml/no-confirm-load-theme t)
(setq sml/theme 'light)
(sml/setup)
;;;; TABBAR
(message "[✓]  Commencer TABBAR")
(require 'tabbar)
(setq tabbar-use-images nil)
;; Add a buffer modification state indicator in the tab label, and place a
;; space around the label to make it looks less crowd.
(defadvice tabbar-buffer-tab-label (after fixup_tab_label_space_and_flag activate)
  (setq ad-return-value
	(if (and (buffer-modified-p (tabbar-tab-value tab))
		 (buffer-file-name (tabbar-tab-value tab)))
	    (concat " + " (concat ad-return-value " "))
	  (concat " " (concat ad-return-value " ")))))

;; Called each time the modification state of the buffer changed.
(defun ztl-modification-state-change ()
  (tabbar-set-template tabbar-current-tabset nil)
  (tabbar-display-update))

;; First-change-hook is called BEFORE the change is made.
(defun ztl-on-buffer-modification ()
  (set-buffer-modified-p t)
  (ztl-modification-state-change))
(add-hook 'after-save-hook 'ztl-modification-state-change)

;; This doesn't work for revert, I don't know.
;;(add-hook 'after-revert-hook 'ztl-modification-state-change)
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
(setq linum-format "%d ")
;;; Tranparency
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
  (setq mouse-sel-mode t))
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
;;;; BOOKMARKS+
(require 'bookmark+)
;;;; BUFFERS
(message "[✓]  Commencer BUFFERS")
(require 'ibuffer)
(require 'ibuffer-git)
(defalias 'list-buffers 'ibuffer) ; make ibuffer default
(add-hook 'ibuffer-hook
	  (lambda ()
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
;;; DIRED
(require 'dired+)
;;; HELP
(require 'help+)
(require 'help-fns+)
(require 'help-mode+)
;; dired avec OSX quiklook
(require 'dired)
(require 'cl)

(defvar my-dired-spawn nil)
(make-variable-buffer-local 'my-dired-spawn)

;; http://stackoverflow.com/a/20023781/2112489
(defun my-dired-kill-last-process-named (name)
"Function initially written by @wvxvw, and revised by @lawlist."
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
"This is essentially a three level incursion, starting with `my-dired-qlmanage'
and then calling `my-dired-kill-spawn' twice."
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
(interactive "^p")
  (dired-previous-line arg)
  (let ((my-dired-spawn t))
    (my-dired-kill-last-process-named "qlmanage")))

(defun my-dired-next-line (arg)
(interactive "^p")
  (dired-next-line arg)
  (let ((my-dired-spawn t))
    (my-dired-kill-last-process-named "qlmanage")))

(defun my-dired-quicklook ()
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
;;;; // END UI
;;;; ESHELL
(message "[✓]  Commencer ESHELL")
(with-eval-after-load "esh-opt"
  (autoload 'epe-theme-lambda "eshell-prompt-extras")
  (setq eshell-highlight-prompt nil
        eshell-prompt-function 'epe-theme-lambda))
(add-hook 'eshell-mode-hook 'eshell-fringe-status-mode)
;;;; ORG
(message "[✓]  Commencer ORG")
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
;; Set to the location of your Org files on your local system
(setq org-directory "~/org")
;; Set to the name of the file where new notes will be stored
(setq org-mobile-inbox-for-pull "~/org/flagged.org")
;; Set to <your Dropbox root directory>/MobileOrg.
(setq org-mobile-directory "~/Dropbox/Apps/MobileOrg")
;;; info et doc
(message "[✓]  Commencer DOC")
;;;; INFO
(require 'info+)
;;;; ELDOC
(require 'eldoc)
(require 'css-eldoc)
(load-library "javascript-eldoc")
(require 'javascript-eldoc)
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)
(add-hook 'css-mode-hook 'turn-on-css-eldoc)
(add-hook 'js-mode-hook 'turn-on-javascript-eldoc)
;;;; REGEX
(require 'foreign-regexp)
(custom-set-variables
   '(foreign-regexp/regexp-type 'javascript) ;; Choose your taste of foreign regexp
                                       ;; from 'perl, 'ruby, 'javascript or
                                       ;; 'python.
   '(reb-re-syntax 'foreign-regexp))   ;; Tell re-builder to use foreign regexp.
;;;; LISPS
(message "[✓]  Commencer LISP")
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
(require 'ess-site)
(setq ess-eval-visibly nil)
(define-key ac-completing-map (kbd "M-h") 'ac-quick-help)
;;;; FLYCHECK
(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)
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

;;; HELM
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
;;;; litteraire
(flycheck-define-checker proselint
  "A linter for prose."
  :command ("proselint" source-inplace)
  :error-patterns
  ((warning line-start (file-name) ":" line ":" column ": "
        (id (one-or-more (not (any " "))))
        (message) line-end))
  :modes (text-mode markdown-mode gfm-mode))

(add-to-list 'flycheck-checkers 'proselint)
;; Enable mouse support
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
  (setq mouse-sel-mode t))))
;;;; start the server
(message "[✓]  Commencer SERVER")
(require 'server)
(add-hook 'after-make-frame-functions 'cpc26/xmouse-enable)
(unless (server-running-p) (server-start))

(provide '.emacs)
;;; .emacs ends here
(put 'downcase-region 'disabled nil)
(message "[✓]  Commencer EMACS")
(put 'upcase-region 'disabled nil)
