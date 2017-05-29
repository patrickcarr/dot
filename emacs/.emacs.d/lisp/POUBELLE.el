;;; POUBELLE.el ---  POUBELLE

;; Copyright (C) 2015-2016  Colin Carr

;; Author: Colin Carr <cpc26@member.fsf.org>
;; Keywords:  POUBELLE

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
;;;    POUBELLE
;;;   Rent seeking software and bad ideas.
;;

;;; Code:
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
(provide 'POUBELLE)
;;; POUBELLE.el ends here
