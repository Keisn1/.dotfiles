;; Exec-path-from-shell ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(exec-path-from-shell-initialize)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Appearance ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq doom-theme 'kaolin-aurora)
(setq kaolin-themes-comments-style 'contrast)

(if (string= (system-name) "kayarch")
    (setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 20)
          doom-variable-pitch-font (font-spec :family "JetBrainsMono Nerd Font" :size 20)
          doom-big-font (font-spec :family "JetBrainsMono Nerd Font" :size 40)))

(if (string= (system-name) "archlinux")
    (setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 18)
          doom-variable-pitch-font (font-spec :family "JetBrainsMono Nerd Font" :size 18)
          doom-big-font (font-spec :family "JetBrainsMono Nerd Font" :size 36)))

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

(defun kb/toggle-window-transparency ()
  "Toggle transparency."
  (interactive)
  (let ((alpha-transparency 75))
    (pcase (frame-parameter nil 'alpha-background)
      (alpha-transparency (set-frame-parameter nil 'alpha-background 93))
      (t (set-frame-parameter nil 'alpha-background alpha-transparency)))))
;; (set-frame-parameter (selected-frame) 'alpha '(93 93))
;; (add-to-list 'default-frame-alist '(alpha . 93))

(setq doom-modeline-buffer-file-name-style 'truncate-upto-project)

(scroll-bar-mode -1)

(setq which-key-idle-delay 0.001)

;; Dired      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook! 'dired-mode-hook #'nerd-icons-dired-mode)

(after! dired-mode
  (setq dired-omit-mode nil)
  (setq dired-omit-files "^\\.?#\\|^\\.$\\|^\\.\\.$\\|^\\..*$"))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ORG      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; org-directories ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(after! org
  ;; If you use `org' and don't want your org files in the default location below,
  ;; change `org-directory'. It must be set before org loads!
  (setq org-directory "~/org-files/org/")
  (setq org-attach-directory "./.attach"))

;; org-agenda ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
;; corrected from gtd.el

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

;; org-babel ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; babel-structure templates ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(after! org
  (require 'org-tempo)
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("p" . "src python :results output"))
  (add-to-list 'org-structure-template-alist '("sc" . "src c"))
  (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
  (setq org-hide-emphasis-markers t)
  )

;; babel-tangle ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun efs/org-babel-tangle-config ()
  (if (or
       (string-equal (buffer-file-name)
                     (expand-file-name "~/.dotfiles/doom_config.org")))
      ;; dynamic scoping to the rescue
      (let ((org-confirm-babel-evaluate nil))
        (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'efs/org-babel-tangle-config)))

;; org-pomodoro ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

;; org-appearance ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'org-superstar)
(add-hook! 'org-mode-hook #'org-superstar-mode)
(setq org-superstar-headline-bullets-list '("◉" "○" "◈" "◇"))
(setq org-ellipsis " ▼")

(after! org
  (setq org-ellipsis " ▼")
  )

(add-hook! 'org-mode-hook #'display-line-numbers-mode)

(setq org-clock-string-limit 11)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org-roam ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq org-roam-directory "~/org-files/roam2/")

;; org-roam variables ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(after! org
  (setq org-roam-completion-everywhere t))

(add-hook! 'org-roam-mode-hook #'org-roam-db-autosync-enable)

(advice-add 'org-roam-buffer-persistent-redisplay :before
            (lambda () (remove-hook 'org-mode-hook 'display-line-numbers-mode)))
(advice-add 'org-roam-buffer-persistent-redisplay :after
            (lambda () (add-hook 'org-mode-hook 'display-line-numbers-mode)))

;; org-roam templates ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

;; roam capture templates ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; roam daily capture templates ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(after! org
  (setq org-roam-dailies-capture-templates
        '(("d" "default" entry "* %<%I:%M %p>: %?"
           :if-new (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n")))))

;; roam Hack for inserting notes ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Bind this to C-c n I
(defun org-roam-node-insert-immediate (arg &rest args)
  (interactive "P")
  (let ((args (cons arg args))
        (org-roam-capture-templates (list (append (car org-roam-capture-templates)
                                                  '(:immediate-finish t)))))
    (apply #'org-roam-node-insert args)))

;; org-roam-ui ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org-gtd ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Evil  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(after! evil
  (setq evil-escape-key-sequence "fd")
  (setq evil-escape-delay 0.15)
  (setq evil-escape-excluded-states '(normal multiedit emacs motion)))
;; (modify-syntax-entry ?_ "w"))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Treesitter ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; eglot ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(after! eglot
  (add-hook 'go-mode-hook 'eglot-ensure)
  (add-hook 'java-mode-hook 'eglot-java-mode)
  (add-hook 'python-mode-hook 'eglot-ensure)
  (add-hook 'rust-mode-hook 'eglot-ensure)
  (add-hook 'c-mode-hook 'eglot-ensure)
  (add-hook 'c++-mode-hook 'eglot-ensure)
  (add-to-list 'eglot-server-programs '((c++-mode c-mode) "clangd-16"))
  )

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; copilot ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; accept completion from copilot and fallback to company
(use-package! copilot
  :hook (prog-mode . copilot-mode))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Languages ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; C  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq c-basic-offset 4)

;; Go ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-hook 'go-ts-mode-hook
          (lambda ()
            (setq compile-command "go build")))

;; Python ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(after! python
  (setq python-pytest-executable "python3 -m pytest"))

(add-hook! 'inferior-python-mode-hook #'visual-line-mode)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Keychain ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Skewer ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'html-mode-hook 'skewer-html-mode)
(add-hook 'js2-mode-hook 'skewer-mode)
(add-hook 'css-mode-hook 'skewer-css-mode)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Misc ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "qutebrowser")

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; keybindings ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; general ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(map!
        :leader :desc "M-x" "SPC" 'execute-extended-command)

(map!
        :leader :desc "Shell-command" "!" 'shell-command)

;; buffer management ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(map! :leader
      "b a" 'switch-to-buffer)
(map!
 :leader :desc "buffer new window" "b w" 'switch-to-buffer-other-window
 :leader :desc "doom dashboard" "b h" '+doom-dashboard/open)

;; window management ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(map!
        :leader "w /" 'evil-window-vsplit
        :leader "w -" 'evil-window-split
        :map evil-window-map "c-n" #'which-key-show-next-page-cycle)

;; org ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(map!   :map org-mode-map
        :localleader "v p" 'set-pomodoro-length)

(map!   :mode org-mode
        :leader "n r I" 'org-roam-node-insert-immediate)

;; consult ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(map! "M-y" 'consult-yank-from-kill-ring)
(map! :map doom-leader-file-map
      :desc "consult-dir" "L" #'consult-dir)
(map! :leader
      (:prefix ("f" . "file")
       :desc "consult-dir" "L"  #'consult-dir))

;; harpoon ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

;; dired ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(map!   :mode dired-mode
        :leader "f j" 'dired-jump)

(map! :map emacs-lisp-mode-map "C-c C-j" #'eval-print-last-sexp)

(map! :map company-active-map
      "C-SPC" nil)
(map! :map evil-insert-state-map
      "C-SPC j" 'copilot-accept-completion
      "C-SPC l" 'copilot-accept-completion-by-word)

;; python ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(map! :after python
      :map python-mode-map
      :localleader
      :prefix ("e" . "pipenv"))

(map! :after python
      :map python-mode-map
      :localleader
      :desc "pytest all" "t a" #'python-pytest)

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
