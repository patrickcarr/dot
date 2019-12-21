(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(Info-additional-directory-list (quote ("/sw/share/info")))
 '(ac-slime-show-flags t)
 '(bmkp-last-as-first-bookmark-file "~/.emacs.d/bookmarks")
 '(column-number-mode t)
 '(custom-enabled-themes (quote (leuven)))
 '(custom-safe-themes
   (quote
    ("6096a2f93610f29bf0f6fe34307587edd21edec95073cbfcfb9d7a3b9206b399" "85d1dbf2fc0e5d30f236712b831fb24faf6052f3114964fdeadede8e1b329832" "170bb47b35baa3d2439f0fd26b49f4278e9a8decf611aa33a0dad1397620ddc3" "d70c11f5a2b69a77f9d56eff42090138721d4c51d9d39ce986680786d694f492" "9a155066ec746201156bb39f7518c1828a73d67742e11271e4f24b7b178c4710" "ba7917b02812fee8da4827fdf7867d3f6f282694f679b5d73f9965f45590843a" "d5f17ae86464ef63c46ed4cb322703d91e8ed5e718bf5a7beb69dd63352b26b2" "ad9747dc51ca23d1c1382fa9bd5d76e958a5bfe179784989a6a666fe801aadf2" "497c5ab15d1a9e4073bc1b9f4ad5edd687ee3053e583b49b25e79da462339632" "51897d0e185a9d350a124afac8d5e95cda53e737f3b33befc44ab02f2b03dab1" "01ac390c8aa5476078be3769f3c72a9e1f5820c9d9a8e8fcde21d0ff0bbeeec1" "89b5c642f4bbcf955215c8f756ae352cdc6b7b0375b01da1f1aa5fd652ae822e" "6e4f8aba68e6934ad0e243f2fc7e6778d87f7d9b16e069cb9fec0cfa7f2f845a" "b28a341d8551fd9d6b0cfac1cfd776ab12ae9d2cd7b606f460ff90e265514679" "412c25cf35856e191cc2d7394eed3d0ff0f3ee90bacd8db1da23227cdff74ca2" "194aeedd04eec6c9bda2729d0c347fb18cfc171a87709c3f2fb4451a2b5e47a8" "f86ddad5a211718f03e9bf4f550a7b8e585f0cb23f8fd33051e5a1ec4a7918cf" "c5d6d43251953cea30a007acf7a6fbca71384558a11fe3d95953ac056a8510dc" "0f92b9f1d391caf540ac746bc251ea00a55f29e20a411460eb6d8e49892ddef9" "d8b3a281518d638e63d1926b71cb32e84c317c9444dacb80a1e0f27e14e4cf54" "70b9c3d480948a3d007978b29e31d6ab9d7e259105d558c41f8b9532c13219aa" "36d92f830c21797ce34896a4cf074ce25dbe0dabe77603876d1b42316530c99d" "b04425cc726711a6c91e8ebc20cf5a3927160681941e06bc7900a5a5bfe1a77f" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "b7b2cd8c45e18e28a14145573e84320795f5385895132a646ff779a141bbda7e" "6ecd762f08fd5c3aab65585d5aa04f6ae8b44d969df4be669259975dac849687" "32840b5ff3c59a31f0845602a26e9a47c27d48bfed86b4a09cdbaf3a25167cf4" default)))
 '(diredp-hide-details-initially-flag nil)
 '(display-battery-mode t)
 '(display-time-mode t)
 '(ecb-layout-window-sizes nil)
 '(ecb-options-version "2.50")
 '(ecb-primary-secondary-mouse-buttons (quote mouse-1--C-mouse-1))
 '(eclim-eclipse-dirs
   (quote
    ("~/opt/eclipse/jee-oxygen/Eclipse.app/Contents/Eclipse")))
 '(eclim-executable
   "~/opt/eclipse/jee-oxygen/Eclipse.app/Contents/Eclipse/eclim")
 '(eclimd-default-workspace "~/eclipse-workspace")
 '(flycheck-sh-shellcheck-executable nil)
 '(flycheck-shellcheck-excluded-warnings (quote ("SC1091")))
 '(foreign-regexp/regexp-type (quote javascript))
 '(geiser-guile-binary "guile-2.0")
 '(helm-M-x-always-save-history t)
 '(indicate-buffer-boundaries (quote left))
 '(lsp-ui-flycheck-enable t)
 '(lsp-ui-sideline-show-hover t)
 '(org-mobile-encryption-password "1qaz2wsx")
 '(package-selected-packages
   (quote
    (which-key company-shell awscli-capf company-lsp dap-mode lsp-treemacs lsp-ui cobol-mode helm-lsp lsp-java helm-jstack salesforce-utils python-mode auctex-latexmk py-autopep8 elpy irfc ansible ansible-doc origami dockerfile-mode sml-modeline treemacs-projectile treemacs helm-tramp gore-mode gorepl-mode go-imports go-guru go-eldoc go-autocomplete ein diff-hl inform-mode malyon tldr projectile-speedbar ac-emmet markdown-mode+ markdown-mode esh-help drag-stuff ac-js2 tern-auto-complete ac-emacs-eclim eclim flymake-css flymake-sass tagedit flymake-jslint flycheck-demjsonlint edbi flycheck-plantuml projectile-rails git-wip-timemachine bury-successful-compilation flymake-ruby robe flycheck-yamllint yaml-mode npm-mode helm-org-rifle js2-refactor plantuml-mode nginx-mode ox-reveal org-ac muttrc-mode js2-highlight-vars js2-mode nodejs-repl expand-region autodisass-java-bytecode javarun web-mode multiple-cursors ess foreign-regexp clips-mode ecb ac-geiser geiser bookmark+ ac-slime auto-complete rainbow-blocks rainbow-delimiters rainbow-mode smart-mode-line-powerline-theme smart-mode-line eshell-fringe-status eshell-prompt-extras org-plus-contrib helm-sage sr-speedbar visual-regexp web-beautify help-mode+ help-fns+ help+ magit eldoc-extension css-eldoc ibuffer-tramp ibuffer-vc ibuffer-projectile ibuffer-git gopher auctex tern exec-path-from-shell dired+ helm-swoop helm-projectile helm-package helm-orgcard helm-make helm-ls-git helm-fuzzier helm-flymake helm-flycheck helm-emmet helm-css-scss helm-ag helm tabbar golden-ratio-scroll-screen golden-ratio org-bullets leuven-theme info+)))
 '(plantuml-jar-path "/Users/colincarr/bin/plantuml.jar")
 '(reb-re-syntax (quote foreign-regexp))
 '(scheme-program-name "guile-2.0")
 '(show-paren-mode t)
 '(size-indication-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(lsp-ui-sideline-code-action ((t (:foreground "dark red")))))
