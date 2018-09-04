;;; Voight-Kampff-OS.el --- Systems level features

;; Copyright (C) 2015-2016  Colin Carr

;; Author: Colin Carr <cpc26@member.fsf.org>
;; Keywords: OS, Voight-Kampff

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
;;;   OS elements
;;;   Tastefully drawn from the Internet
;;

;;; Code:
;;; ................................................................................
(message "[✓]  Commencer OS FIXES")
;; (when (memq window-system '(mac ns))
;;   (exec-path-from-shell-initialize))
;; (let ((default-directory  "~/.emacs.d/lisp/"))
;;   (normal-top-level-add-subdirs-to-load-path))
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

(provide 'Voight-Kampff-OS)
;;; Voight-Kampff-OS.el ends here
