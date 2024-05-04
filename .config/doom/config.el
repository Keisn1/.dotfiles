;; Exec-path-from-shell ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(exec-path-from-shell-initialize)

(setq require-final-newline nil)

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

(defun kb/toggle-window-transparency ()
  "Toggle transparency."
  (interactive)
  (let ((alpha-transparency 75))
    (pcase (frame-parameter nil 'alpha-background)
      (alpha-transparency (set-frame-parameter nil 'alpha-background 93))
      (t (set-frame-parameter nil 'alpha-background alpha-transparency)))))
;; (set-frame-parameter (selected-frame) 'alpha '(93 93))
;; (add-to-list 'default-frame-alist '(alpha . 93))

(setq doom-modeline-buffer-file-name-style 'relative-to-project)

(size-indication-mode -1)

(scroll-bar-mode -1)

(setq which-key-idle-delay 0.001)

;; Dired      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook! 'dired-mode-hook #'nerd-icons-dired-mode)

(after! dired-mode
  (setq dired-omit-mode nil)
  (setq dired-omit-files "^\\.?#\\|^\\.$\\|^\\.\\.$\\|^\\..*$"))

(display-battery-mode 't)

(use-package! golden-ratio
  :after-call pre-command-hook
  :config
  ;; (golden-ratio-mode +1)
  ;; Using this hook for resizing windows is less precise than
  ;; `doom-switch-window-hook'.
  (remove-hook 'window-configuration-change-hook #'golden-ratio)
  (add-hook 'doom-switch-window-hook #'golden-ratio))

(after! pdf-tools
  (add-to-list 'pdf-tools-enabled-modes 'pdf-view-themed-minor-mode)
)

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
      '("~/org-files/agenda-files/Habits.org" "~/org-files/agenda-files/todo.org" "~/org-files/agenda-files/Archive.org" ))

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

(org-babel-do-load-languages 'org-babel-load-languages '((sql . t)))

;; babel-structure templates ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(after! org
  (require 'org-tempo)
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("p" . "src python :results output"))
  (add-to-list 'org-structure-template-alist '("go" . "src go :results output :imports \"fmt\" "))
  (add-to-list 'org-structure-template-alist '("sc" . "src c"))
  (add-to-list 'org-structure-template-alist '("sql" . "src sql"))
  (add-to-list 'org-structure-template-alist '("sqlite" . "src sqlite"))
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

(after! org
  (setq org-startup-folded 'show2levels)
  )

(require 'org-superstar)
(add-hook! 'org-mode-hook #'org-superstar-mode)
(setq org-superstar-headline-bullets-list '("◉" "○" "◈" "◇"))
(setq org-ellipsis " ▼")

(after! org
  (setq org-ellipsis " ▼")
  )

(add-hook! 'org-mode-hook #'display-line-numbers-mode)

(setq org-clock-clocked-in-display nil)

(org-add-link-type "mpv" (lambda (path) (mpv-play path)))

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
          ("d" "latex" plain "%?"
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
 ;; :hook (after-init . org-roam-ui-mode)
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
  (setq org-gtd-engage-prefix-width 30)
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
  (add-to-list 'eglot-server-programs '((c++-mode c-mode) "clangd"))
  (add-to-list 'eglot-server-programs '((go-mode) "gopls"))
  (add-to-list 'eglot-server-programs '((python-mode) "pyright"))
)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; copilot ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; accept completion from copilot and fallback to company
;; (use-package! copilot
;;   :hook (prog-mode . copilot-mode))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Languages ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; C  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq c-basic-offset 4)

;; Go ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (add-hook 'go-ts-mode-hook
;;           (lambda ()
;;             (setq compile-command "go build")))
;; (add-hook 'go-ts-mode-hook eldoc-mode)
(setq-default eglot-workspace-configuration
              '((:gopls .
                        ((staticcheck . t)
                         ;; (matcher . "CaseSensitive")
                         (symbolScope . "workspace")
                         ))))

;; Python ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(after! python
  (setq python-pytest-executable "python3 -m pytest"))

(defun toggle-django-shell-interpreter-args ()
  (interactive)
  (let ((manage-py (locate-dominating-file default-directory "manage.py")))
    (if manage-py
        (setq python-shell-interpreter-args (concat "-i " (expand-file-name manage-py) "manage.py shell"))
      (message "manage.py not found in parent directories"))))

(map! :map doom-leader-toggle-map :desc "toggle-django-shell" "d" 'toggle-django-shell-interpreter-args)

(setq global-visual-line-mode t)
(add-hook! 'inferior-python-mode-hook #'visual-line-mode)
(add-hook! 'special-mode-hook #'visual-line-mode)
(add-hook! 'go-test-mode-hook #'visual-line-mode)

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

(after! flymake
  (setq flymake-show-diagnostics-at-end-of-line t)
  )

(use-package! org-ai
  :commands (
             org-ai-mode
             org-ai-global-mode)
  :init
  (add-hook 'org-mode-hook #'org-ai-mode) ;enable org-ai in org mode
  (org-ai-global-mode)                    ; installs global keybindings C-c M-a
  :config
  (setq org-ai-default-chat-model "gpt-3.5-turbo")
  (org-ai-install-yasnippets)
  )

;; (map!  :leader
;;        "k" org-ai-global-prefix-map
;;        :leader
;;        :prefix "k" "e" #'org-ai-explain-code
;;        )

(use-package! gptel
  :config
  (setq! gptel-api-key #'gptel-api-key-from-auth-source)
  (setq! gptel-default-mode 'org-mode)
  (setq! gptel-directives '(
                            (default-long . "You are a helpful assistant, occasionally dwelling within Emacs, believe it or not.
     A convivial sort with an easy-going natural manner.
     Wrap any generated code in gfm code blocks - this applies only to code, not to general responses.  For example
     ```emacs-lisp
     (message \"this is a test\")
     ```
")
                            (default . "You are a large language model living in Emacs and a helpful assistant. Try to avoid long answers.")
                            (programming . "You are a large language model and a careful programmer. When asked about something with regards to programming, provide code example")
                            (find-emacs-function . "Please provide the name of the Emacs function that performs this action.")
                            (bash-function . "Assist in generating command line commands by providing the requested action without extra elaboration. Only provide the command without any formatting itself as I will further refine it before execution.")))
    (setq! gptel--system-message (alist-get 'default gptel-directives)))

(defvar gptel-global-prefix-map (make-sparse-keymap)
  "Keymap for GPTel.")

(defun gptel-buffer ()
  (interactive)
  (setq current-prefix-arg '(4))
  (call-interactively 'gptel))

(let ((map gptel-global-prefix-map))
  (define-key map (kbd "b") 'gptel)
  (define-key map (kbd "B") 'gptel-buffer)
  (define-key map (kbd "s") 'gptel-send)
  (define-key map (kbd "m") 'gptel-menu)
  (define-key map (kbd "r") 'gptel--suffix-rewrite)
  (define-key map (kbd "R") 'gptel-rewrite-menu)
  (define-key map (kbd "P") 'gjg/gptel-select-system-prompt))

(map!  :leader
       "k" gptel-global-prefix-map)

;; (after! gptel
;;   (add-to-list 'gptel-directives '(find-emacs-function . "Please provide the name of the Emacs function that performs this action.")
;;   (add-to-list 'gptel-directives '(bash-function . "Assist in generating command line commands by providing the requested action without extra elaboration. Only provide the command itself as I will further refine it before execution."))))

;; Use the system prompt builder function

(let ((build-custom-directives-fun "~/.dotfiles/ai/gptel-build-custom-directives.el"))
  (when (f-exists-p build-custom-directives-fun)
    (load build-custom-directives-fun)
    ;; (custom-set-variables '(gptel-directives
    (setq gptel-custom-directives
          (gjg/gptel-build-custom-directives
           "~/.dotfiles/ai/system-prompts/"))))

;; pandoc -f gfm -t org|sed '/:PROPERTIES:/,/:END:/d'

(defun gjg/gptel--convert-markdown->org (str)
  "Convert string STR from markdown to org markup using Pandoc.
         Remove the property drawers Pandoc insists on inserting for org output."
  ;; point will be at the last user position - assistant response will be after that to the end of the buffer (hopefully without the next user prompt)
  ;; So let's
  (interactive)
  (let* ((org-prefix (alist-get 'org-mode gptel-prompt-prefix-alist))
         (shift-indent (progn (string-match "^\\(\\*+\\)" org-prefix) (length (match-string 1 org-prefix))))
         (lua-filter (when (file-readable-p "~/.config/pandoc/gfm_code_to_org_block.lua")
                       (concat "--lua-filter=" (expand-file-name "~/.config/pandoc/gfm_code_to_org_block.lua"))))
         (temp-name (make-temp-name "gptel-convert-" ))
         (sentence-end "\\([.?!
         ]\\)"))
    ;; TODO: consider placing original complete response in the kill ring
    ;; (with-temp-buffer
    (with-current-buffer (get-buffer-create (concat "*" temp-name "*"))
      (insert str)
      (write-region (point-min) (point-max) (concat "/tmp/" temp-name ".md" ))
      (shell-command-on-region (point-min) (point-max)
                               (format "pandoc -f gfm -t org --shift-heading-level-by=%d %s|sed '/:PROPERTIES:/,/:END:/d'" shift-indent lua-filter)
                               nil ;; use current buffer
                               t   ;; replace the buffer contents
                               "*gptel-convert-error*")
      (goto-char (point-min))
      ;; (insert (format "%sAssistant: %s\n" (alist-get 'org-mode gptel-prompt-prefix-alist) (or (sentence-at-point t) "[resp]")))
      (insert (format "%sAssistant: \n" (alist-get 'org-mode gptel-prompt-prefix-alist)))
      ;; (insert "\n")
      (goto-char (point-max))
      (buffer-string))))

(defun gjg/gptel-convert-org-with-pandoc (content buffer)
  "Transform CONTENT acoording to required major-mode using `pandoc'.
          Currenly only `org-mode' is supported
          This depends on the `pandoc' binary only, not on the  Emacs Lisp `pandoc' package."
  (pcase (buffer-local-value 'major-mode buffer)
    ('org-mode (gjg/gptel--convert-markdown->org content))
    (_ content)))

(custom-set-variables '(gptel-response-filter-functions
                        '(gjg/gptel-convert-org-with-pandoc)))

(defun gjg/gptel--annotate-directives (s)
  "Make the directives selection look fancy."
  (let* ((item (assoc (intern s) minibuffer-completion-table))
         (desc (s-truncate 40 (nth 1 item)))
         (prompt (s-truncate 80 (s-replace "\n" "\\n" (nth 2 item)))))
    (when item (concat
                (string-pad "" (- 40 (string-width s)))
                desc
                (string-pad "" (- 55 (string-width desc)))
                prompt
                ))))

(defun gjg/gptel-select-system-prompt (&optional directive-key)
  "Set system message in local gptel buffer to directive/prompt indicated by DIRECTIVE-KEY."
  (interactive)
  (let* ((marginalia-align-offset 80)
         (completion-extra-properties '(:annotation-function gjg/gptel--annotate-directives))
         (directive-key (or directive-key
                            (intern
                             (completing-read
                              ;; "New directive: "
                              (format "Current prompt %s: "
                                      (truncate-string-to-width gptel--system-message 90 nil nil (truncate-string-ellipsis) ))
                              gptel-custom-directives
                              nil ;; predicate/filter
                              nil ;; do not require a match - allow custom prompt
                              nil ;; no initial input
                              nil ;; no history specified
                              "default" ;; default value if return is nil
                              )))))
    (setq-local gptel--system-message (nth 2 (assoc directive-key gptel-custom-directives)))))

(gptel-make-ollama "Ollama"             ;Any name of your choosing
  :host "localhost:11434"               ;Where it's running
  :stream t                             ;Stream responses
  :models '("llama3:latest"))          ;List of models

(add-hook 'python-mode-hook
          (lambda () (setq-local devdocs-current-docs '("python~3.11" "django~5.0" "django_rest_framework"))))

(add-hook 'go-mode-hook
          (lambda () (setq-local devdocs-current-docs '("go"))))

(add-hook 'css-mode-hook
          (lambda () (setq-local devdocs-current-docs '("dom" "css" "javascript" "html" "tailwindcss"))))
(add-hook 'html-mode-hook
          (lambda () (setq-local devdocs-current-docs '("dom" "css" "javascript" "html" "tailwindcss"))))
(add-hook 'mhtml-mode-hook
          (lambda () (setq-local devdocs-current-docs '("dom" "css" "javascript" "html" "tailwindcss"))))
(add-hook 'js-mode-hook
          (lambda () (setq-local devdocs-current-docs '("dom" "css" "javascript" "html" "tailwindcss"))))

(add-to-list 'auto-mode-alist '("\\.gohtml\\'" . mhtml-mode))

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

(map!   :map org-mode-map
        :localleader "v l" #'org-latex-preview)

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
(add-hook 'python-ts-mode-hook (lambda () (setq flymake-show-diagnostics-at-end-of-line nil)))
(after! python
  (set-keymap-parent python-ts-mode-map python-mode-map))
(map! :after python
      :map python-ts-mode-map
      :localleader
      :prefix ("e" . "pipenv")
      :prefix ("i" . "import")
      :prefix ("t" . "test"))

;; dired ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(map! :map evil-motion-state-map "] e" 'flymake-goto-next-error
      :map evil-motion-state-map "[ e" 'flymake-goto-prev-error)
(map!
 :map doom-leader-code-map "k" nil
 :map doom-leader-code-map :desc "flymake-goto-prev-error" "k" 'flymake-goto-prev-error
 :map doom-leader-code-map :desc "flymake-goto-next-error" "j" 'flymake-goto-next-error
 :map doom-leader-code-map :desc "consult-flymake" "l" 'consult-flymake
 :map doom-leader-code-map :desc "flymake-show-project-diagnostics" "L" 'flymake-show-project-diagnostics)

(map!
 :map doom-leader-code-map :desc "eglot-rename" "r" 'eglot-rename)

(map!
 :map doom-leader-toggle-map :desc "golden-ratio-mode" "o" 'golden-ratio-mode)

(map! :leader
      :prefix "s"
      :desc "devdocs-lookup" "o" #'devdocs-lookup
      )

(map! :after go-mode
      :map go-mode-map
      :localleader
      "r" #'go-run
      :prefix ("i" . "import")
      "i" #'go-import-add
      "o" #'eglot-code-action-organize-imports
      :prefix ("t" . "test")
      "t" #'go-test-current-test
      "f" #'go-test-current-file
      "p" #'go-test-current-project
      "c" #'go-test-current-coverage
      )

(map! :leader
      :prefix "s"
      "M" #'imenu-list
      )

(map! :leader
      :prefix "c"
      "o" #'eldoc
      )

(after! mu4e
  (setq! doom-modeline-mu4e nil)
  (setq! mu4e-compose-context-policy 'ask-if-none)
  (setq! sendmail-program (executable-find "msmtp")
        send-mail-function #'smtpmail-send-it
        message-sendmail-f-is-evil t
        message-sendmail-extra-arguments '("--read-envelope-from")
        ;; message-send-mail-function #'message-send-mail-with-sendmail)
        message-send-mail-function #'smtpmail-send-it)

  ;; This is set to 't' to avoid mail syncing issues when using mbsync
  (setq mu4e-change-filenames-when-moving t)

  (setq mu4e-compose-format-flowed t)
  ;; Refresh mail using isync every 10 minutes
  (setq mu4e-update-interval (* 5 60))
  ;; (setq mu4e-get-mail-command "mbsync -a")
  (setq mu4e-maildir "~/.mail")


  ;; (setq mu4e-drafts-folder "/gmail/[Gmail]/Drafts")
  ;; (setq mu4e-sent-folder   "/gmail/[Gmail]/Sent Mail")
  ;; (setq mu4e-refile-folder "/gmail/[Gmail]/All Mail")
  ;; (setq mu4e-trash-folder  "/gmail/[Gmail]/Trash")

  (setq mu4e-contexts
        (list
         ;; icloud
         (make-mu4e-context
          :name "icloud"
          :match-func
          (lambda (msg)
            (when msg
              (string-prefix-p "/icloud" (mu4e-message-field msg :maildir))))
          :vars '((user-mail-address . "kay.freyer@icloud.com")
                  (user-full-name    . "Kay Freyer")
                  (smtpmail-smtp-server . "smtp.mail.me.com")
                  (smtpmail-smtp-service . 587)

                  (mu4e-get-mail-command . "mbsync icloud")
                  (smtpmail-stream-type . starttls)
                  (mu4e-drafts-folder  . "/icloud/Drafts")
                  (mu4e-sent-folder  . "/icloud/Sent Messages")
                  (mu4e-trash-folder  . "/icloud/Bin")))


         ;; kaytravaille account
         (make-mu4e-context
          :name "kaytravaille"
          :match-func
          (lambda (msg)
            (when msg
              (string-prefix-p "/gmail/kaytravaille" (mu4e-message-field msg :maildir))))
          :vars '((user-mail-address . "kaytravaille@gmail.com")
                  (user-full-name    . "Kay Freyer")

                  (mu4e-get-mail-command . "mbsync gmail")
                  (mu4e-drafts-folder  . "/gmail/[Gmail]/kaytravaille/Drafts")
                  (mu4e-sent-folder  . "/gmail/[Gmail]/kaytravaille/Sent Mail")
                  (mu4e-refile-folder  . "/gmail/[Gmail]/kaytravaille/All Mail")
                  (mu4e-trash-folder  . "/gmail/[Gmail]/kaytravaille/Trash")))

         ;; Keisn account
         (make-mu4e-context
          :name "Keisn"
          :match-func
          (lambda (msg)
            (when msg
              (string-prefix-p "/gmail" (mu4e-message-field msg :maildir))))
          :vars '((user-mail-address . "peterdiefontaene@gmail.com")
                  (user-full-name    . "Kay Freyer")

                  (mu4e-get-mail-command . "mbsync gmail")
                  (mu4e-drafts-folder  . "/gmail/[Gmail]/Drafts")
                  (mu4e-sent-folder  . "/gmail/[Gmail]/Sent Mail")
                  (mu4e-refile-folder  . "/gmail/[Gmail]/All Mail")
                  (mu4e-trash-folder  . "/gmail/[Gmail]/Trash")))

         ))

  (setq mu4e-maildir-shortcuts
        '((:maildir "/icloud/Archive"    :key ?a)
          (:maildir "/icloud/inbox" :key ?i)
          (:maildir "/icloud/Sent Messages"     :key ?s)
          (:maildir "/icloud/Saved"    :key ?v))))

(use-package! mu4e-compat
  :config (mu4e-compat-define-aliases-forwards)
)

(setq! org-msg-default-style
'((del nil
      ((font-family . "\"Arial\"")
       (font-size . "10pt")
       (color . "grey")
       (border-left . "none")
       (text-decoration . "line-through")
       (margin-bottom . "0px")
       (margin-top . "10px")
       (line-height . "11pt")))
 (a nil
    ((color . "#0071c5")))
 (a reply-header
    ((color . "black")
     (text-decoration . "none")))
 (div reply-header
      ((padding . "3.0pt 0in 0in 0in")
       (border-top . "solid #e1e1e1 1.0pt")
       (margin-bottom . "20px")))
 (span underline
       ((text-decoration . "underline")))
 (li nil
     ((font-family . "\"Arial\"")
      (font-size . "10pt")
      (line-height . "10pt")
      (margin-bottom . "0px")
      (margin-top . "2px")))
 (nil org-ul
      ((list-style-type . "square")))
 (nil org-ol
      ((font-family . "\"Arial\"")
       (font-size . "10pt")
       (line-height . "10pt")
       (margin-bottom . "0px")
       (margin-top . "0px")
       (margin-left . "30px")
       (padding-top . "0px")
       (padding-left . "5px")))
 (nil signature
      ((font-family . "\"Arial\"")
       (font-size . "10pt")
       (margin-bottom . "20px")))
 (blockquote quote0
             ((padding-left . "5px")
              (margin-left . "10px")
              (margin-top . "10px")
              (margin-bottom . "0")
              (font-style . "italic")
              (background . "#f9f9f9")
              (border-left . "3px solid #ccc")))
 (blockquote quote1
             ((padding-left . "5px")
              (margin-left . "10px")
              (margin-top . "10px")
              (margin-bottom . "0")
              (font-style . "italic")
              (background . "#f9f9f9")
              (color . "#324e72")
              (border-left . "3px solid #3c5d88")))
 (blockquote quote2
             ((padding-left . "5px")
              (margin-left . "10px")
              (margin-top . "10px")
              (margin-bottom . "0")
              (font-style . "italic")
              (background . "#f9f9f9")
              (color . "#6a3a4c")
              (border-left . "3px solid #7f455b")))
 (blockquote quote3
             ((padding-left . "5px")
              (margin-left . "10px")
              (margin-top . "10px")
              (margin-bottom . "0")
              (font-style . "italic")
              (background . "#f9f9f9")
              (color . "#7a4900")
              (border-left . "3px solid #925700")))
 (blockquote quote4
             ((padding-left . "5px")
              (margin-left . "10px")
              (margin-top . "10px")
              (margin-bottom . "0")
              (font-style . "italic")
              (background . "#f9f9f9")
              (color . "#ff34ff")
              (border-left . "3px solid #fe71fe")))
 (blockquote quote5
             ((padding-left . "5px")
              (margin-left . "10px")
              (margin-top . "10px")
              (margin-bottom . "0")
              (font-style . "italic")
              (background . "#f9f9f9")
              (color . "#ff4a46")
              (border-left . "3px solid #ff8986")))
 (blockquote quote6
             ((padding-left . "5px")
              (margin-left . "10px")
              (margin-top . "10px")
              (margin-bottom . "0")
              (font-style . "italic")
              (background . "#f9f9f9")
              (color . "#008941")
              (border-left . "3px solid #00a44d")))
 (blockquote quote7
             ((padding-left . "5px")
              (margin-left . "10px")
              (margin-top . "10px")
              (margin-bottom . "0")
              (font-style . "italic")
              (background . "#f9f9f9")
              (color . "#006fa6")
              (border-left . "3px solid #0085c7")))
 (blockquote quote8
             ((padding-left . "5px")
              (margin-left . "10px")
              (margin-top . "10px")
              (margin-bottom . "0")
              (font-style . "italic")
              (background . "#f9f9f9")
              (color . "#a30059")
              (border-left . "3px solid #c3006a")))
 (blockquote quote9
             ((padding-left . "5px")
              (margin-left . "10px")
              (margin-top . "10px")
              (margin-bottom . "0")
              (font-style . "italic")
              (background . "#f9f9f9")
              (color . "#ffdbe5")
              (border-left . "3px solid #ffffff")))
 (blockquote quote10
             ((padding-left . "5px")
              (margin-left . "10px")
              (margin-top . "10px")
              (margin-bottom . "0")
              (font-style . "italic")
              (background . "#f9f9f9")
              (color . "#000000")
              (border-left . "3px solid #000000")))
 (blockquote quote11
             ((padding-left . "5px")
              (margin-left . "10px")
              (margin-top . "10px")
              (margin-bottom . "0")
              (font-style . "italic")
              (background . "#f9f9f9")
              (color . "#0000a6")
              (border-left . "3px solid #0000c7")))
 (blockquote quote12
             ((padding-left . "5px")
              (margin-left . "10px")
              (margin-top . "10px")
              (margin-bottom . "0")
              (font-style . "italic")
              (background . "#f9f9f9")
              (color . "#63ffac")
              (border-left . "3px solid #a9ffd1")))
 (code nil
       ((font-size . "10pt")
        (font-family . "monospace")
        (background . "#f9f9f9")))
 (code src\ src-asl
       ((color . "#d4d4d6")
        (background-color . "#14191e")))
 (code src\ src-c
       ((color . "#d4d4d6")
        (background-color . "#14191e")))
 (code src\ src-c++
       ((color . "#d4d4d6")
        (background-color . "#14191e")))
 (code src\ src-conf
       ((color . "#d4d4d6")
        (background-color . "#14191e")))
 (code src\ src-cpp
       ((color . "#d4d4d6")
        (background-color . "#14191e")))
 (code src\ src-csv
       ((color . "#d4d4d6")
        (background-color . "#14191e")))
 (code src\ src-diff
       ((color . "#d4d4d6")
        (background-color . "#14191e")))
 (code src\ src-ditaa
       ((color . "#d4d4d6")
        (background-color . "#14191e")))
 (code src\ src-emacs-lisp
       ((color . "#d4d4d6")
        (background-color . "#14191e")))
 (code src\ src-fundamental
       ((color . "#d4d4d6")
        (background-color . "#14191e")))
 (code src\ src-ini
       ((color . "#d4d4d6")
        (background-color . "#14191e")))
 (code src\ src-json
       ((color . "#d4d4d6")
        (background-color . "#14191e")))
 (code src\ src-makefile
       ((color . "#d4d4d6")
        (background-color . "#14191e")))
 (code src\ src-man
       ((color . "#d4d4d6")
        (background-color . "#14191e")))
 (code src\ src-org
       ((color . "#d4d4d6")
        (background-color . "#14191e")))
 (code src\ src-plantuml
       ((color . "#d4d4d6")
        (background-color . "#14191e")))
 (code src\ src-python
       ((color . "#d4d4d6")
        (background-color . "#14191e")))
 (code src\ src-sh
       ((color . "#d4d4d6")
        (background-color . "#14191e")))
 (code src\ src-xml
       ((color . "#d4d4d6")
        (background-color . "#14191e")))
 (nil linenr
      ((padding-right . "1em")
       (color . "black")
       (background-color . "#aaaaaa")))
 (pre nil
      ((line-height . "12pt")
       (color . "#d4d4d6")
       (background-color . "#14191e")
       (margin . "0px")
       (font-size . "9pt")
       (font-family . "monospace")))
 (div org-src-container
      ((margin-top . "10px")))
 (nil figure-number
      ((font-family . "\"Arial\"")
       (font-size . "10pt")
       (color . "#0071c5")
       (font-weight . "bold")
       (text-align . "left")))
 (nil table-number)
 (caption nil
          ((text-align . "left")
           (background . "#0071c5")
           (color . "white")
           (font-weight . "bold")))
 (nil t-above
      ((caption-side . "top")))
 (nil t-bottom
      ((caption-side . "bottom")))
 (nil listing-number
      ((font-family . "\"Arial\"")
       (font-size . "10pt")
       (color . "#0071c5")
       (font-weight . "bold")
       (text-align . "left")))
 (nil figure
      ((font-family . "\"Arial\"")
       (font-size . "10pt")
       (color . "#0071c5")
       (font-weight . "bold")
       (text-align . "left")))
 (nil org-src-name
      ((font-family . "\"Arial\"")
       (font-size . "10pt")
       (color . "#0071c5")
       (font-weight . "bold")
       (text-align . "left")))
 (table nil
        ((font-family . "\"Arial\"")
         (font-size . "10pt")
         (margin-top . "0px")
         (line-height . "10pt")
         (border-collapse . "collapse")))
 (th nil
     ((border . "1px solid white")
      (background-color . "#0071c5")
      (color . "white")
      (padding-left . "10px")
      (padding-right . "10px")))
 (td nil
     ((font-family . "\"Arial\"")
      (font-size . "10pt")
      (margin-top . "0px")
      (padding-left . "10px")
      (padding-right . "10px")
      (background-color . "#f9f9f9")
      (border . "1px solid white")))
 (td org-left
     ((text-align . "left")))
 (td org-right
     ((text-align . "right")))
 (td org-center
     ((text-align . "center")))
 (div outline-text-4
      ((margin-left . "15px")))
 (div outline-4
      ((margin-left . "10px")))
 (h4 nil
     ((margin-bottom . "0px")
      (font-size . "11pt")
      (font-family . "\"Arial\"")))
 (h3 nil
     ((margin-bottom . "0px")
      (text-decoration . "underline")
      (color . "#0071c5")
      (font-size . "12pt")
      (font-family . "\"Arial\"")))
 (h2 nil
     ((margin-top . "20px")
      (margin-bottom . "20px")
      (font-style . "italic")
      (color . "#0071c5")
      (font-size . "13pt")
      (font-family . "\"Arial\"")))
 (h1 nil
     ((margin-top . "20px")
      (margin-bottom . "0px")
      (color . "#0071c5")
      (font-size . "12pt")
      (font-family . "\"Arial\"")))
 (p nil
    ((text-decoration . "none")
     (margin-bottom . "0px")
     (margin-top . "10px")
     (max-width . "50em")
     (line-height . "11pt")
     (font-size . "10pt")
     (font-family . "\"Arial\"")))
 (div nil
      ((font-family . "\"Arial\"")
       (font-size . "10pt")
       (line-height . "11pt"))))
)

(setq! org-msg-enforce-css org-msg-default-style)
(after! org-msg
  (setq!
   org-msg-options "html-postamble:nil H:5 num:nil ^:{} toc:nil author:nil email:nil \\n:t"
         org-msg-startup "hidestars indent inlineimages"
         org-msg-greeting-fmt "\nDear%s,\n\n"
         org-msg-recipient-names '(("kay.freyer@icloud.com" . "Kay"))
         org-msg-greeting-name-limit 3
         org-msg-default-alternatives '((new		. (text html))
                                        (reply-to-html	. (text html))
                                        (reply-to-text	. (text)))
         org-msg-convert-citation t
         org-msg-signature "

 Best Regards,

 #+begin_signature
 --

 *Kay Freyer*
 #+end_signature")
  )

(after! mhtml-mode
  (add-hook 'mhtml-mode-hook (lambda () (apheleia-mode -1))))
(after! jinja2-mode
  (add-hook 'jinja2-mode-hook (lambda () (apheleia-mode -1))))
(after! dockerfile-mode
  (add-hook 'dockerfile-mode-hook (lambda () (apheleia-mode -1))))
(map!
 :map doom-leader-toggle-map :desc "apheleia-mode" "a" 'apheleia-mode)

;; (after! auth-source
;;   (setq auth-sources (nreverse auth-sources)))
(setq! auth-sources '("~/.authinfo.gpg" "~/.authinfo" "~/.netrc"))

;; (after! all-the-icons
;;     :config
;;   (add-to-list 'all-the-icons-extension-icon-alist '("gohtml" all-the-icons-alltheicon "html5" :face all-the-icons-orange)))
;; (add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
(use-package! nerd-icons
    :config
    (add-to-list 'nerd-icons-extension-icon-alist '("gohtml" nerd-icons-devicon "nf-dev-html5" :face nerd-icons-orange)))
;; (add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
