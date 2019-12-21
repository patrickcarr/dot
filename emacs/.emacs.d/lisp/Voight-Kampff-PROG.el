;;; Voight-Kampff-PROG.el --- PROG and PROG related

;; Copyright (C) 2015-2016  Colin Carr

;; Author: Colin Carr <cpc26@member.fsf.org>
;; Keywords: PROG, Voight-Kampff

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
;;;   PROG elements
;;;   Tastefully drawn from the Internet
;;

;;; Code:
(message "[✓]  ........................................")
(message "[✓]  Commencer PROG")
(message "[✓]  Commencer DevOps")
(require 'generic-x)
; NGINX
(require 'nginx-mode)
(add-to-list 'auto-mode-alist '("/nginx/sites-\\(?:available\\|enabled\\)/" . nginx-mode))
(message "[✓]    NGINX")
(require 'awscli-capf)
(add-hook 'shell-mode-hook (lambda ()
			     (add-to-list 'completion-at-point-functions 'awscli-capf)))
(message "[✓]    AWS")
;;;;
;;;; ................................................................................
;;;;
;;;; ...............PROG.............................................................
(message "[✓]  Commencer PROG")
;;;; ................................................................................
;;; LSP
(require 'lsp-mode)
(require 'lsp-ui)
(setq lsp-ui-sideline-update-mode 'point)
(add-hook 'lsp-mode-hook 'lsp-ui-mode)
;;(add-hook 'js2-mode-hook 'flycheck-mode)
(require 'company-lsp)
(push 'company-lsp company-backends)
(lsp-treemacs-sync-mode 1)
(add-hook 'js2-mode-hook #'lsp)
(add-hook 'javaScript-mode-hook #'lsp)
(add-hook 'css-mode-hook #'lsp)
(add-hook 'sh-mode-hook #'lsp)
(add-hook 'dockerfile-mode-hook #'lsp)
(add-hook 'web-mode-hook #'lsp)
;;; compile buffer bury
(bury-successful-compilation 1)
;;;; MAGIT
(message "[✓]    MAGIT and GIT")
;;; TODO  some consternation with auto-revert
;(global-auto-revert-mode 1)
;(setq auto-revert-check-vc-info t)
(defvar magit-repository-directories '( "~/src" ))
(global-diff-hl-mode)
(diff-hl-flydiff-mode 1)
;;; GIT-WIP
(add-to-list 'exec-path "~/opt/git-wip/")
(load "~/opt/git-wip/emacs/git-wip.el")
(message "[✓] git-wip and git-wip-timemachine")
; projectile
(projectile-global-mode)
(message "[✓]    Projectile")
;;;; REGEX
(defvar foreign-regexp/regexp-type nil)
(defvar foreign-regexp/re-builder/targ-buf-state/\.orig-pt nil)
(require 'foreign-regexp)
;;; TODO  nice feature but byte compile always complains
(custom-set-variables
   '(foreign-regexp/regexp-type 'javascript) ;; Choose your taste of foreign regexp
                                       ;; from 'perl, 'ruby, 'javascript or
                                       ;; 'python.
   '(reb-re-syntax 'foreign-regexp))   ;; Tell re-builder to use foreign regexp.
;;; flyspell-prog
(setq ispell-program-name "/opt/local/bin/ispell")
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
;;; TODO this needs DB specific PERL to work
;;M-x package-install edbi
;;cpan RPC::EPC::Service
(require 'edbi)
(autoload 'e2wm:dp-edbi "e2wm-edbi" nil t)
(message "[✓]    end SQL")
(message "*****")
;; END SQL
;;;; C-MODE
(setq-default c-indent-tabs-mode t     ; Pressing TAB should cause indentation
	      c-indent-level 4         ; A TAB is equivilent to four spaces
	      c-argdecl-indent 0       ; Do not indent argument decl's extra
	      c-tab-always-indent t
	      backward-delete-function nil) ; DO NOT expand tabs when deleting
(c-add-style "my-c-style" '((c-continued-statement-offset 4))) ; If a statement continues on the next line, indent the continuation by 4
(defun my-c-mode-hook ()
"An efficient and tasteful C mode."
  (c-set-style "my-c-style")
  (c-set-offset 'substatement-open '0) ; brackets should be at same indentation level as the statements they open
  (c-set-offset 'inline-open '+)
  (c-set-offset 'block-open '+)
  (c-set-offset 'brace-list-open '+)   ; all "opens" should be indented by the c-indent-level
  (c-set-offset 'case-label '+)
  (local-set-key (kbd "<tab>") 'c-indent-command)) ; indent case labels by c-indent-level, too
(add-hook 'c-mode-hook 'my-c-mode-hook)
(add-hook 'c++-mode-hook 'my-c-mode-hook)
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
;; (load (expand-file-name "~/quicklisp/slime-helper.el"))
;; (setq inferior-lisp-program "/usr/local/bin/sbcl")
;; (setq slime-contribs '(slime-fancy slime-tramp))
;; ;;;; slime-scratch
;; (setq slime-scratch-file (expand-file-name "~/.slime/slime-scratch.lisp"))
;; ;;;;  slime-auto complete
;; (require 'ac-slime)
;; (add-hook 'slime-mode-hook 'set-up-slime-ac)
;; (add-hook 'slime-repl-mode-hook 'set-up-slime-ac)
;; (eval-after-load "auto-complete"
;;   '(add-to-list 'ac-modes 'slime-repl-mode))
;; ;;;; fuzzy
;; (require 'slime-fuzzy)
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
(add-hook 'slime-mode-hook
	  (lambda ()
	    (local-set-key (kbd "<tab>") 'slime-fuzzy-complete-symbol)))
;; abcl from docker because nothing is more enterprise than Docker and Java
(setq slime-docker-implementations `((abcl ("abcl") :docker-machine "enterprise_lisp")))
;; (setq slime-lisp-implementations  ; M--M-x slime
;;       '((sbcl ("/usr/local/bin/sbcl"))
;; 	(abcl ("docker" "run" "-i" "easye/abcl"))))
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
;; (add-hook 'js2-mode-hook (lambda ()
;;                            (tern-mode)))
(message "[✓]      Start App Dev:: JavaScript::JSLint")
(require 'flymake-easy)
;; (require 'flymake-jslint)
;; (add-hook 'js-mode-hook 'flymake-jslint-load)
;; (add-hook 'js2-mode-hook 'flymake-jslint-load)
(require 'flycheck)
;; disable jshint since we prefer eslint checking
;; (setq-default flycheck-disabled-checkers
;;   (append flycheck-disabled-checkers
;;     '(javascript-jshint)))
;; ;; use eslint with web-mode for jsx files
;; (flycheck-add-mode 'javascript-eslint 'js2-mode)
;; ;; customize flycheck temp file prefix
;; (setq-default flycheck-temp-prefix ".flycheck")
;; ;; disable json-jsonlist checking for json files
;; (setq-default flycheck-disabled-checkers
;;   (append flycheck-disabled-checkers
;;     '(json-jsonlist)))
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
;; (add-to-list 'load-path "~/opt/tern/emacs")
;; (autoload 'tern-mode "tern.el" nil t)
;; (add-hook 'js-mode-hook (lambda () (tern-mode t)))
;; (add-hook 'js2-mode-hook (lambda () (tern-mode t)))
;; ;(define-key tern-mode-keymap [(control ?c) (control ?t)] 'tern-get-type)
;; (eval-after-load 'tern
;;    '(progn
;;       (require 'tern-auto-complete)
;;       (tern-ac-setup)))
;;;; ................................................................................
;;;; JS related DOM and WEB
;;;; WEB MODE
(message "[✓]    WEB-MODE")
;
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml$'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.hbs\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsx$" . web-mode))
(add-to-list 'web-mode-ac-sources-alist
             '("html" . (ac-source-html-tag
                         ac-source-html-attribute)))
;; engines a-list
(setq web-mode-engines-alist
      '(("\\.hbs$" . "ctemplate"))
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
;; (require 'eclim)
;; (setq eclimd-autostart t)
;; (custom-set-variables
;;   '(eclim-eclipse-dirs '("~/opt/eclipse/jee-oxygen/Eclipse.app/Contents/Eclipse"))
;;   '(eclim-executable "~/opt/eclipse/jee-oxygen/Eclipse.app/Contents/Eclipse/eclim")
;;   '(eclimd-default-workspace "~/eclipse-workspace"))
;; (add-hook 'java-mode-hook 'eclim-mode)
;; ;;; Displaying compilation error messages in the echo area
;; (setq help-at-pt-display-when-idle t)
;; (setq help-at-pt-timer-delay 0.1)
;; (help-at-pt-set-timer)
;; ;; add the emacs-eclim source
;; ;(require 'ac-emacs-eclim-source)
;; (ac-emacs-eclim-config)
;;; J A V A
(require 'lsp-java)
(add-hook 'java-mode-hook #'lsp)
;;; YAS-SNIPPETS
;; (require 'yasnippet)
;; (defvar yas-snippet-dirs nil)
;; (setq yas-snippet-dirs '("~/.emacs.d/snippets"))
;; (yas-reload-all)
;; (add-hook 'prog-mode-hook #'yas-minor-mode)
;;;; ................................................................................
(message "[✓]  END PROG")
(message "[✓]  ........................................")
;;;; END PROG
;;;; ................................................................................

(provide 'Voight-Kampff-PROG)
;;; Voight-Kampff-PROG.el ends here
