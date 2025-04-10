;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or
;; use 'M-x doom/reload'.


;; To install SOME-PACKAGE from MELPA, ELPA or emacsmirror:
                                        ;(package! some-package)
(package! ob-mermaid)
(package! nerd-icons-dired)
(package! whisper
  :recipe (:host github
	   :repo "natrys/whisper.el"
	   :files ("*.el")))
(package! org-superstar)
(package! catppuccin-theme)
(package! harpoon)
(package! org-gtd)
;; (package! ement)
;; (unpin! org-roam)
;; (unpin! org-roam-ui)
(package! org-roam-ui
  :recipe (:host github :repo "Keisn1/org-roam-ui"))
(package! impatient-mode)
(package! command-log-mode)
;; (package! company-tabnine)
(package! copilot
  :recipe (:host github :repo "copilot-emacs/copilot.el" :files ("*.el")))
(package! exec-path-from-shell)
(package! eglot-java)
(package! go-mode)
(package! go-gen-test)
(package! gorepl-mode)
(package! ob-go)
(package! go-playground)
(package! kaolin-themes)
(package! flycheck :disable t)
(package! golden-ratio)
(package! imenu-list)
(package! bufler)
(package! devdocs)
(package! validate-html)
(package! jinja2-mode)
(package! mpv)
(package! gptel)
;; (package! gptel :recipe (:host github :repo "https://github.com/karthink/gptel.git" :type git :fork "gregoryg"))
(package! org-ai)
(package! rfc-mode
  :recipe (:host github :repo "galdor/rfc-mode" :files ("*.el")))
(package! ox-pandoc)
(package! mu4e-compat
  :recipe (:host github :repo "tecosaur/mu4e-compat"))
;; To install a package directly from a remote git repo, you must specify a
;; `:recipe'. You'll find documentation on what `:recipe' accepts here:
;; https://github.com/radian-software/straight.el#the-recipe-format
                                        ;(package! another-package
                                        ;  :recipe (:host github :repo "username/repo"))


;; If the package you are trying to install does not contain a PACKAGENAME.el
;; file, or is located in a subdirectory of the repo, you'll need to specify
;; `:files' in the `:recipe':
                                        ;(package! this-package
                                        ;  :recipe (:host github :repo "username/repo"
                                        ;           :files ("some-file.el" "src/lisp/*.el")))

;; If you'd like to disable a package included with Doom, you can do so here
;; with the `:disable' property:
                                        ;(package! builtin-package :disable t)

;; You can override the recipe of a built in package without having to specify
;; all the properties for `:recipe'. These will inherit the rest of its recipe
;; from Doom or MELPA/ELPA/Emacsmirror:
                                        ;(package! builtin-package :recipe (:nonrecursive t))
                                        ;(package! builtin-package-2 :recipe (:repo "myfork/package"))

;; Specify a `:branch' to install a package from a particular branch or tag.
;; This is required for some packages whose default branch isn't 'master' (which
;; our package manager can't deal with; see radian-software/straight.el#279)
                                        ;(package! builtin-package :recipe (:branch "develop"))

;; Use `:pin' to specify a particular commit to install.
                                        ;(package! builtin-package :pin "1a2b3c4d5e")


;; Doom's packages are pinned to a specific commit and updated from release to
;; release. The `unpin!' macro allows you to unpin single packages...
                                        ;(unpin! pinned-package)
;; ...or multiple packages
                                        ;(unpin! pinned-package another-pinned-package)
;; ...Or *all* packages (NOT RECOMMENDED; will likely break things)
                                        ;(unpin! t)
