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

(add-hook 'window-setup-hook #'toggle-frame-fullscreen)
(setq default-frame-alist '((undecorated . t))) ; get rid of title bar

(setq doom-theme 'doom-Iosvkem)

;; (all-the-icons-install-fonts t)
;; (nerd-icons-install-fonts)

(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 20)
      doom-variable-pitch-font (font-spec :family "Ubuntu" :size 18)
      doom-big-font (font-spec :family "JetBrainsMono Nerd Font" :size 24)
      )

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

(after! org
  ;; If you use `org' and don't want your org files in the default location below,
  ;; change `org-directory'. It must be set before org loads!
  (setq org-log-done 1)
  )

(after! org
  ;; If you use `org' and don't want your org files in the default location below,
  ;; change `org-directory'. It must be set before org loads!
  (setq org-directory "~/org/"))

(setq org-enable-notification t)

(after! org
  (require 'org-tempo)
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("p" . "src python"))
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
                      (expand-file-name "~/.dotfiles/ubuntu_setup.org")))
    ;; dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'efs/org-babel-tangle-config)))

(after! evil
  (setq evil-escape-key-sequence "fd")
  (setq evil-escape-excluded-states '(normal multiedit emacs motion)))

(setq which-key-idle-delay 0.01)

(add-hook! 'dired-mode-hook #'nerd-icons-dired-mode)

;; (add-hook! 'dired-omit-mode-hook (add-to-list 'dired-omit-extensions '".bashrc"))
;; (add-hook! 'dired-omit-mode-hook (add-to-list 'dired-omit-extensions '".zshrc"))
;; (setq dired-omit-files "\\`[.]?#\\|\\`[.][.]?\\'\\|^\\..+$\\|^__pycache__$\\|,")

(add-hook! 'inferior-python-mode-hook #'visual-line-mode)

(setq doom-localleader-key ",")

(map!
        :leader :desc "M-x" "SPC" 'execute-extended-command)

(map!
        "M-y" 'consult-yank-from-kill-ring)

(map! :after python
      :map python-mode-map
      :localleader
      :prefix ("e" . "pipenv"))

(map!
        :leader "f j" 'dired-jump)

(map!
        :leader "w /" 'evil-window-vsplit
        :leader "w -" 'evil-window-split
        :map evil-window-map "c-n" #'which-key-show-next-page-cycle)

(map!
        :leader :desc "doom dashboard" "b h" '+doom-dashboard/open)
