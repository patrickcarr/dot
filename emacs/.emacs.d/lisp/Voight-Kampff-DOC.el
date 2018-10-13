;;; Voight-Kampff-DOC.el --- an eldoc-mode plugin for JAVASCRIPT source code

;; Copyright (C) 2015-2016  Colin Carr

;; Author: Colin Carr <cpc26@member.fsf.org>
;; Keywords: DOC, Voight-Kampff

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
;;;   DOC elements
;;;   Tastefully drawn from the Internet
;;

;;; Code:
;;;; ................................................................................
;;;; ORG
;;;; ................................................................................
(message "[✓]  Commencer ORG")
(require 'org)
(require 'org-bullets)
;; Set to the location of your Org files on your local system
(setq org-directory "~/org")
;; Set to the name of the file where new notes will be stored
(defvar org-mobile-inbox-for-pull "~/org/flagged.org")
;; Set to <your Dropbox root directory>/MobileOrg.
(defvar org-mobile-directory "~/Dropbox/Apps/MobileOrg")
(setq org-ellipsis "↴")
;; set after so bullets appear
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
(setq org-startup-indented t)
;; AucTeX
(message "[✓]  Commencer TEX")
(let ((my-path (expand-file-name "/usr/local/bin:/usr/local/texlive/2018/bin/x86_64-darwin")))
(setenv "PATH" (concat my-path ":" (getenv "PATH")))
(add-to-list 'exec-path my-path))
(defvar TeX-auto-save t)
(defvar TeX-parse-self t)
(setq-default TeX-master nil)
(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(defvar reftex-plug-into-AUCTeX t)
(defvar TeX-PDF-mode t)
;; Use Skim as viewer, enable source <-> PDF sync
;; make latexmk available via C-c C-c
;; Note: SyncTeX is setup via ~/.latexmkrc (see below)
;; (add-hook 'LaTeX-mode-hook
;; (lambda ()
;;   (push
;;    '("latexmk" "latexmk -pdf %s" TeX-run-TeX nil t
;;      :help "Run latexmk on file")
;;     TeX-command-list)))
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
(defvar TeX-view-program-selection '((output-pdf "PDF Viewer")))
(defvar TeX-view-program-list
  '(("PDF Viewer" "/Applications/Skim.app/Contents/SharedSupport/displayline -b -g %n %o %b")))
;; Open Skim -> Preferences -> Sync
;; Preset: Emacs
;; Command: /usr/local/bin/emacsclient
;; Arguments: --no-wait +%line "%file"
(custom-set-variables
     '(TeX-source-correlate-method 'synctex)
     '(TeX-source-correlate-mode t)
     '(TeX-source-correlate-start-server t))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; UML  E N T E R P R I S E  Q U A L I T Y COMMUNICATIONS
;;;; ................................................................................
(add-to-list
  'org-src-lang-modes '("plantuml" . plantuml))
;;;; E N T E R P R I S E  Q U A L I T Y COMMUNICATIONS
;; Enable plantuml-mode for PlantUML files
(add-to-list 'auto-mode-alist '("\\.plantuml$'" . plantuml-mode))
;; MD MODE
(add-to-list 'auto-mode-alist '("\\.markdown$'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md$'" . markdown-mode))
(add-to-list 'auto-mode-alist '("README\\.md$'" . gfm-mode))
;;;; REVEAL PRESENTATIONS
(require 'ox-reveal)
;;;; END E N T E R P R I S E  Q U A L I T Y COMMUNICATIONS
;;;; END ORG and DOC PREP
;;;; ................................................................................
;;; info et doc
(message "[✓]  Commencer DOCUMENTATION")
;;;; INFO
;;(require 'info+)
;;;; ELDOC
(require 'eldoc)
(require 'css-eldoc)
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)
(add-hook 'css-mode-hook 'turn-on-css-eldoc)
;;;(add-hook 'js-mode-hook 'turn-on-javascript-eldoc)
;;;  interface for IETF RFC document.
(setq irfc-assoc-mode t)
;;;; END DOCUMENTATION
;;; HELM
;;;; ................................................................................
(message "[✓]  Commencer HELM")
;; https://github.com/xiaohanyu/oh-my-emacs/blob/master/core/ome-completion.org
;; 
;; http://tuhdo.github.io/helm-intro.html
(setq locate-command "mdfind")
(require 'helm-config)
(setq helm-split-window-inside-p t)
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

(provide 'Voight-Kampff-DOC)
;;; Voight-Kampff-DOC.el ends here
