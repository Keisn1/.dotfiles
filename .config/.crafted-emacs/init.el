;; set custom.el file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (and custom-file
           (file-exists-p custom-file))
  (load custom-file nil :nomessage))

;; load crafted init config
(load "~/.config/.crafted-emacs/modules/crafted-init-config")

(require 'crafted-evil-packages)
(package-install-selected-packages :noconfirm)

(require 'crafted-defaults-config)
(require 'crafted-evil-config)

;; Turning off menu-bar, tool-bar and scroll-bar
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(set-face-attribute 'default nil
                    :font "Hack Nerd Font"
                    :height 120)
