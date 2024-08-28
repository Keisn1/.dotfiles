(load "~/.config/crafted-emacs/modules/crafted-early-init-config")

;; set custom.el file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (and custom-file
           (file-exists-p custom-file))
  (load custom-file nil :nomessage))

;; load crafted init config
(load "~/.config/crafted-emacs/modules/crafted-init-config")
