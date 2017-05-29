;;; javascript-eldoc.el --- an eldoc-mode plugin for JAVASCRIPT source code

;; Copyright (C) 2015-2016  Colin Carr

;; Author: Colin Carr <colincarr@qq.com>
;; Keywords:

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
;;;   Experiments with font fixed and variable in many modes
;;;   Some interesting interactions with saved desktops happened.
;;

;;; Code:
;;;--------------------------------------------------------------------------------
;;; FONTS
;; default font to LispM
;;  anciens à l’honneur
(set-face-attribute 'default nil
                :family "LispM" :height 140 :weight 'regular)
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
;;;; MODES
;;; iELM
; this would occasionally not load correctly
(add-hook 'ielm-mode-hook 'setq-buffer-fixed-pitch)
;;; EShell
(add-hook 'eshell-mode-hook 'my-buffer-face-mode-fixed)
;;; iBuffer
(add-hook 'ibuffer-mode-hook 'my-buffer-face-mode-fixed)
;;; ORG-MODE
(defun set-buffer-variable-pitch ()
  "Main text variable, code and tables are fixed."
    (interactive)
    (variable-pitch-mode t)
    (setq line-spacing 3)
     (set-face-attribute 'org-table nil :inherit 'fixed-pitch)
     (set-face-attribute 'org-code nil :inherit 'fixed-pitch)
     (set-face-attribute 'org-block nil :inherit 'fixed-pitch)
    )
(add-hook 'org-mode-hook 'set-buffer-variable-pitch)
;; set after so bullets appear
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
;;; INFO and INFO+
;;; display Info mode buffers in proportional font
;;; but code examples in monospace font
(defvar my-rx-info-code (rx bol "     " (* not-newline) eol))
(defun my-Info-font-lock ()
  "Use fixed fonts for code examples."
  (interactive)
;  (require 'org)
  (font-lock-add-keywords
   nil
   `((,my-rx-info-code
      .
      ;; let's just use org-block
      (quote org-block)
      ))))
(add-hook 'Info-mode-hook 'my-Info-font-lock)
(add-hook 'Info-mode-hook 'my-buffer-face-mode-variable)
;;; HELM
(add-hook 'helm-major-mode-hook 'my-buffer-face-mode-courier)
;;; Markdown Mode
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
;;;


;;;
(provide 'font-experiments)
;;; font-experiments.el ends here
