;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(if (string= system-type "darwin")
 (setq mac-option-modifier 'super)
 (setq mac-command-modifier 'meta))

(setq doom-private-dir "/home/kaypro/.dotfiles/")

;; (add-hook 'window-setup-hook #'toggle-frame-fullscreen)
(setq default-frame-alist '((undecorated . t))) ; get rid of title bar

(setq doom-theme 'kaolin-aurora)

;; (all-the-icons-install-fonts t)
;; (nerd-icons-install-fonts)

(if (string= (system-name) "kaypro-MacBookPro")
    (setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 19)
      doom-variable-pitch-font (font-spec :family "Ubuntu" :size 27)
      doom-big-font (font-spec :family "JetBrainsMono Nerd Font" :size 30)))

(if (string= (system-name) "Kays-Mac-mini.local")
    (setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 15)
      doom-variable-pitch-font (font-spec :family "JetBrainsMono Nerd Font" :size 15)
      doom-big-font (font-spec :family "JetBrainsMono Nerd Font" :size 40)))

(if (string= (system-name) "kaypro-UX330UAK")
    (setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 20)
      doom-variable-pitch-font (font-spec :family "Ubuntu" :size 20)
      doom-big-font (font-spec :family "JetBrainsMono Nerd Font" :size 24)))

(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic)
  )

(custom-set-faces!
  '(show-paren-match :weight ultrabold :slant italic :foreground "red" :background "gray7")
  )

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)
(setq global-visual-line-mode t)

;; (set-frame-parameter (selected-frame) 'alpha '(92 92))
;; (add-to-list 'default-frame-alist '(alpha . 92))

(setq doom-modeline-buffer-file-name-style 'truncate-upto-project)

(after! org
  ;; If you use `org' and don't want your org files in the default location below,
  ;; change `org-directory'. It must be set before org loads!
  (setq org-directory "~/org-files/org/")
  (setq org-attach-directory "~/org-files/org/.attach"))

(setq org-agenda-files
      '("~/org-files/agenda-files/Habits.org" "~/org-files/agenda-files/todo.org"))

(setq org-tag-alist
      '((:startgroup)
                                        ; Put mutually exclusive tags here
        (:endgroup)
        ("work" . ?w)
        ("email" . ?e)
        ("config" . ?c)
        ("private" . ?p)
        ("idea" . ?i)))

(setq org-refile-targets
      '(("~/org-files/agenda-files/Archive.org" :maxlevel . 2)
        ("~/org-files/agenda-files/todo.org" :maxlevel . 2)))
;; Save Org buffers after refiling!
(advice-add 'org-refile :after #'(lambda (&rest _) (org-save-all-org-buffers)))
;; (advice-add 'org-refile :after 'org-save-all-org-buffers)

;; (setq org-agenda-start-with-log-mode t)
(setq org-agenda-custom-commands
      '(("d" "Dashboard"
         ((agenda "" ((org-deadline-warning-days 7)))
          (todo "NEXT"
                ((org-agenda-overriding-header "Next Tasks")))
          (tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))))

        ("n" "Next Tasks"
         ((todo "NEXT"
                ((org-agenda-overriding-header "Next Tasks")))))))

(after! org
  (add-to-list 'org-modules 'org-habit)
  (setq org-agenda-show-future-repeats nil))

;; (setq +org-capture-todo-file)

(setq org-clock-string-limit 11)

(defun set-pomodoro-length (minutes)
  "Set the org-pomodoro-length variable to the specified value in MINUTES."
  (interactive "nEnter pomodoro length in minutes: ")
  (setq org-pomodoro-length minutes)
  (message "org-pomodoro-length set to %d minutes." minutes))

(setq org-enable-notification t)
(setq org-pomodoro-manual-break t)
(setq org-pomodoro-start-sound-p t)
(setq org-pomodoro-start-sound
      "~/.dotfiles/resources/sounds/pomodoro/achievement.wav")
(setq org-pomodoro-finished-sound-p t)
(setq org-pomodoro-finished-sound
      "~/.dotfiles/resources/sounds/pomodoro/arcade-score-interface.wav")
(setq org-pomodoro-killed-sound-p t)
(setq org-pomodoro-killed-sound
      "~/.dotfiles/resources/sounds/pomodoro/alert-bells-echo.wav")
(setq org-pomodoro-short-break-sound-p t)
(setq org-pomodoro-short-break-sound
      "~/.dotfiles/resources/sounds/pomodoro/attention-bell-ding.wav")
(setq org-pomodoro-long-break-sound-p t)
(setq org-pomodoro-long-break-sound
      "~/.dotfiles/resources/sounds/pomodoro/bell-gentle-alarm.wav")
(setq org-pomodoro-overtime-sound-p t)
(setq org-pomodoro-overtime-sound
      "~/.dotfiles/resources/sounds/pomodoro/airport.wav")
(setq org-pomodoro-ticking-sound-p t)
(setq org-pomodoro-ticking-sound
      "~/.dotfiles/resources/sounds/pomodoro/tick.wav")

(after! org
  (require 'org-tempo)
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("p" . "src python-ts :results output"))
  (add-to-list 'org-structure-template-alist '("sc" . "src c"))
  (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
  (setq org-hide-emphasis-markers t)
  )

(require 'org-superstar)
(add-hook! 'org-mode-hook #'org-superstar-mode)
(setq org-superstar-headline-bullets-list '("◉" "○" "◈" "◇"))
(setq org-ellipsis " ▼")

(after! org
  (setq org-ellipsis " ▼")
  )



(defun efs/org-babel-tangle-config ()
  (if (or
      (string-equal (buffer-file-name)
                      (expand-file-name "~/.dotfiles/config_doom.org"))
      (string-equal (buffer-file-name)
                      (expand-file-name "~/.dotfiles/zshrc.org"))
      (string-equal (buffer-file-name)
                      (expand-file-name "~/.dotfiles/crafted-emacs-config.org"))
      (string-equal (buffer-file-name)
                      (expand-file-name "/home/kaypro/.dotfiles/.config/crafted-emacs-config/custom-modules-org/crafted-evil.org"))
      (string-equal (buffer-file-name)
                      (expand-file-name "/home/kaypro/.dotfiles/.config/crafted-emacs-config/custom-modules-org/crafted-defaults.org"))
      (string-equal (buffer-file-name)
                      (expand-file-name "/home/kaypro/.dotfiles/.config/crafted-emacs-config/custom-modules-org/crafted-completion.org"))
      (string-equal (buffer-file-name)
                      (expand-file-name "/home/kaypro/.dotfiles/.config/crafted-emacs-config/custom-modules-org/crafted-ide.org"))
      (string-equal (buffer-file-name)
                      (expand-file-name "~/.dotfiles/ubuntu_setup.org")))
    ;; dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'efs/org-babel-tangle-config)))

(setq org-roam-directory "~/org-files/roam/")

(after! org
  (setq org-roam-completion-everywhere t))

(add-hook! 'org-roam-mode-hook #'org-roam-db-autosync-enable)

(advice-add 'org-roam-buffer-persistent-redisplay :before
            (lambda () (remove-hook 'org-mode-hook 'display-line-numbers-mode)))
(advice-add 'org-roam-buffer-persistent-redisplay :after
            (lambda () (add-hook 'org-mode-hook 'display-line-numbers-mode)))

(after! org
  (setq org-roam-capture-templates
        '(("d" "default" plain "%?"
           :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                              "#+title: ${title}\n#+date: %U\n#+startup: overview\n")
           :unnarrowed t)
          ("y" "python" plain (file "~/.dotfiles/resources/templates/org-roam/PythonNoteTemplate.org")
           :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: Python")
           :unnarrowed t)
          ("l" "programming language" plain
           "* Characteristics\n\n- Family: %?\n- Inspired by: \n\n* Reference:\n\n"
           :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
           :unnarrowed t)
          ("b" "book notes" plain
           "\n* Source\n\nAuthor: %^{Author}\nTitle: ${title}\nDate: %U\nFormat Date: %<%Y-%m-%d %H:%M>\nYear: %^{Year}\n\n* Summary\n\n%?"
           :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
           :unnarrowed t
           )
          ("p" "project" plain "* Goals\n\n%?\n\n* Tasks\n\n** TODO Add initial tasks\n\n* Dates\n\n"
           :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: Project")
           :unnarrowed t))))

(after! org
  (setq org-roam-dailies-capture-templates
        '(("d" "default" entry "* %<%I:%M %p>: %?"
           :if-new (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n")))))

;; Bind this to C-c n I
(defun org-roam-node-insert-immediate (arg &rest args)
  (interactive "P")
  (let ((args (cons arg args))
        (org-roam-capture-templates (list (append (car org-roam-capture-templates)
                                                  '(:immediate-finish t)))))
    (apply #'org-roam-node-insert args)))

(use-package! websocket
    :after org-roam)

(use-package! org-roam-ui
    :after org-roam ;; or :after org
;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;;         a hookable mode anymore, you're advised to pick something yourself
;;         if you don't care about startup time, use
;;  :hook (after-init . org-roam-ui-mode)
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))

(setq org-gtd-update-ack "3.0.0")
(use-package! org-gtd
  :after org
  :config
  (setq org-edna-use-inheritance t)
  (setq org-gtd-directory "~/org-files/gtd")
  (setq org-gtd-engage-prefix-width 20)
  (org-edna-mode)
  (org-gtd-mode)
  ;; (add-to-list 'org-gtd-organize-hooks 'org-set-effort)
  (add-to-list 'org-gtd-organize-hooks 'org-priority)
  (map! :leader
        (:prefix ("d" . "org-gtd")
         :desc "Capture"        "c"  #'org-gtd-capture
         :desc "Engage"         "e"  #'org-gtd-engage
         :desc "Process inbox"  "p"  #'org-gtd-process-inbox
         :desc "Show all next"  "n"  #'org-gtd-show-all-next
         :desc "Stuck projects" "s"  #'org-gtd-review-stuck-projects))
  (map! :map org-gtd-clarify-map
        :desc "Organize this item" "C-c c" #'org-gtd-organize))

(setq projectile-ignored-projects '(".git" "~/org-files/roam/"))
(setq projectile-ignored-projects '("~/org-files/roam/"))
;; (setq projectile-track-known-projects-automatically nil)
;; (setq projectile-auto-discover nil)
;; (setq projectile-project-root-functions
;;       '(projectile-root-local
;;         projectile-root-marked
;;         projectile-root-top-down
;;         projectile-root-top-down-recurring
;;         projectile-root-bottom-up))

(map! :leader
      "b a" 'switch-to-buffer)

(after! evil
  (setq evil-escape-key-sequence "fd")
  (setq evil-escape-delay 0.15)
  (setq evil-escape-excluded-states '(normal multiedit emacs motion)))
;; (modify-syntax-entry ?_ "w"))

(add-hook 'c-mode-hook 'eglot-ensure)
(setq c-basic-offset 4)
;; (after! lsp-mode
;;   (setq c-basic-offset 4))

(setq treesit-language-source-alist
   '((bash "https://github.com/tree-sitter/tree-sitter-bash")
     (c "https://github.com/tree-sitter/tree-sitter-c")
     (cmake "https://github.com/uyha/tree-sitter-cmake")
     (css "https://github.com/tree-sitter/tree-sitter-css")
     (docker "https://github.com/tree-sitter/tree-sitter-docker")
     (elisp "https://github.com/Wilfred/tree-sitter-elisp")
     (go "https://github.com/tree-sitter/tree-sitter-go")
     (gomod "https://github.com/camdencheek/tree-sitter-go-mod.git")
     (html "https://github.com/tree-sitter/tree-sitter-html")
     (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
     (json "https://github.com/tree-sitter/tree-sitter-json")
     (make "https://github.com/alemuller/tree-sitter-make")
     (markdown "https://github.com/ikatyang/tree-sitter-markdown")
     (python "https://github.com/tree-sitter/tree-sitter-python")
     (rust "https://github.com/tree-sitter/tree-sitter-rust")
     (toml "https://github.com/tree-sitter/tree-sitter-toml")
     (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
     (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
     (dockerfile "https://github.com/camdencheek/tree-sitter-dockerfile.git")
     (yaml "https://github.com/ikatyang/tree-sitter-yaml")))

;; (add-to-list 'exec-path "/home/kaypro/go/bin" )
;; (add-to-list 'exec-path "/usr/local/go/bin" )
(exec-path-from-shell-initialize)
(add-hook 'go-ts-mode-hook
          (lambda ()
            (setq compile-command "go build")))
(after! eglot
  (add-hook 'go-mode-hook 'eglot-ensure))

(add-hook 'java-mode-hook 'eglot-java-mode)

;; (add-hook 'java-mode-hook 'eglot-ensure)

(defun my/disable-scroll-bars (frame)
  (modify-frame-parameters frame
                           '((vertical-scroll-bars . nil)
                             (horizontal-scroll-bars . nil))))
(add-hook 'after-make-frame-functions 'my/disable-scroll-bars)

(setq which-key-idle-delay 0.001)

(add-hook! 'dired-mode-hook #'nerd-icons-dired-mode)

(after! dired-mode
  (setq dired-omit-mode nil)
  (setq dired-omit-files "^\\.?#\\|^\\.$\\|^\\.\\.$\\|^\\..*$"))
;; (add-hook! 'dired-omit-mode-hook (add-to-list 'dired-omit-extensions '".bashrc"))
;; (add-hook! 'dired-omit-mode-hook (add-to-list 'dired-omit-extensions '".zshrc"))
;; (setq dired-omit-files "\\`[.]?#\\|\\`[.][.]?\\'\\|^\\..+$\\|^__pycache__$\\|,")
;; (setq 'dired-omit-files "\\`[.]?#\\|\\`[.][.]?\\'")

(add-hook! 'inferior-python-mode-hook #'visual-line-mode)

(after! python
  (setq python-pytest-executable "python3 -m pytest"))

(add-hook 'python-mode-hook 'eglot-ensure)

;; (copy-keymap python-mode-map)           ;
(setq major-mode-remap-alist
      '((python-mode . python-ts-mode)))
(dolist (hook python-mode-hook)
  (add-hook 'python-ts-mode-hook hook))

(add-hook 'python-ts-mode-hook (lambda () (yas-activate-extra-mode 'python-mode)))

(after! python
  (set-keymap-parent python-ts-mode-map python-mode-map))
(map! :after python
      :map python-ts-mode-map
      :localleader
      :prefix ("e" . "pipenv")
      :prefix ("i" . "import")
      :prefix ("t" . "test"))



;; accept completion from copilot and fallback to company
(use-package! copilot
  :hook (prog-mode . copilot-mode))
;; (map! :after copilot
;;       "C-x j" 'copilot-accept-completion
;;       "C-x l" 'copilot-accept-completion-by-word)
(map! :map company-active-map
      "C-SPC" nil
      )
(map! :map evil-insert-state-map
      "C-SPC j" 'copilot-accept-completion
      "C-SPC l" 'copilot-accept-completion-by-word)
  ;; :bind (:map copilot-completion-map
  ;;             (:leader "c u" . 'copilot-accept-completion)
  ;;             (:leader "c y" . 'copilot-accept-completion-by-word)))

;; (setq doom-localleader-key ",")

(map!
        :leader :desc "M-x" "SPC" 'execute-extended-command)

(map!
        :leader :desc "Shell-command" "!" 'shell-command)

(map!
        "M-y" 'consult-yank-from-kill-ring)

(map! :after python
      :map python-mode-map
      :localleader
      :prefix ("e" . "pipenv"))

(map! :after python
      :map python-mode-map
      :localleader
      :desc "pytest all" "t a" #'python-pytest)

(map! :leader
      :prefix ("j" . "harpoon")
      "m" 'harpoon-quick-menu-hydra
      "e" 'harpoon-toggle-quick-menu
      "f" 'harpoon-toggle-file
      "a" 'harpoon-add-file
      "c" 'harpoon-clear
      "g" 'harpoon-go-to-1
      "h" 'harpoon-go-to-2
      "j" 'harpoon-go-to-3
      "k" 'harpoon-go-to-4
      "l" 'harpoon-go-to-5
      ";" 'harpoon-go-to-6
      )

(map!   :mode dired-mode
        :leader "f j" 'dired-jump)



;; (map! :after python
;;       :map python-mode-map
;;       :localleader
;;       :prefix ("e" . "pipenv"))
(map!   :map org-mode-map
        :localleader "v p" 'set-pomodoro-length)

(map!   :mode org-mode
        :leader "n r I" 'org-roam-node-insert-immediate)

(map!
        :leader "w /" 'evil-window-vsplit
        :leader "w -" 'evil-window-split
        :map evil-window-map "c-n" #'which-key-show-next-page-cycle)

(map!
 :leader :desc "buffer new window" "b w" 'switch-to-buffer-other-window
 :leader :desc "doom dashboard" "b h" '+doom-dashboard/open)

(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "qutebrowser")

;;; Code:

;;;###autoload
(defun keychain-refresh-environment ()
  "Set ssh-agent and gpg-agent environment variables.

Set the environment variables `SSH_AUTH_SOCK', `SSH_AGENT_PID'
and `GPG_AGENT' in Emacs' `process-environment' according to
information retrieved from files created by the keychain script."
  (interactive)
  (let* ((ssh (shell-command-to-string "keychain -q --noask --agents ssh --eval"))
         (gpg (shell-command-to-string "keychain -q --noask --agents gpg --eval")))
    (list (and ssh
               (string-match "SSH_AUTH_SOCK[=\s]\\([^\s;\n]*\\)" ssh)
               (setenv       "SSH_AUTH_SOCK" (match-string 1 ssh)))
          (and ssh
               (string-match "SSH_AGENT_PID[=\s]\\([0-9]*\\)?" ssh)
               (setenv       "SSH_AGENT_PID" (match-string 1 ssh)))
          (and gpg
               (string-match "GPG_AGENT_INFO[=\s]\\([^\s;\n]*\\)" gpg)
               (setenv       "GPG_AGENT_INFO" (match-string 1 gpg))))))

;;; _
(provide 'keychain-environment)

(after! rust
  (setq lsp-rust-server 'rust-analyzer))
(after! eglot
  (add-hook 'rust-mode-hook 'eglot-ensure)
)

;; (defun first-graphical-frame-hook-function ()
;;   (remove-hook 'focus-in-hook #'first-graphical-frame-hook-function)
;;   (provide 'ement))
;; (add-hook 'focus-in-hook #'first-graphical-frame-hook-function)

;; (with-eval-after-load 'ement
;;   (setq svg-lib-style-default (svg-lib-style-compute-default))) ;


;; (setf use-default-font-for-symbols nil)
;; (set-fontset-font t 'unicode "Noto Emoji" nil 'append)

;; (use-package ement
;;   :ensure t
;;   :custom
;;   (ement-room-images t)
;;   (ement-room-prism 'both))
  ;; (ement-connect :uri-prefix "keisn:matrix.org")

(add-hook 'html-mode-hook 'skewer-html-mode)
(add-hook 'js2-mode-hook 'skewer-mode)
(add-hook 'css-mode-hook 'skewer-css-mode)

(after! eglot
(add-to-list 'eglot-server-programs '((c++-mode c-mode) "clangd-16"))
(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'c++-mode-hook 'eglot-ensure)
)
