(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(when (and custom-file
           (file-exists-p custom-file))
  (load custom-file nil :nomessage))

(load "~/.config/.crafted-emacs/modules/crafted-init-config")

(require 'crafted-defaults-config)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(load-theme 'kaolin-aurora)
(set-frame-parameter nil 'alpha-background 90) ; For current frame

;; Set the fixed pitch face
(set-face-attribute 'default nil
                    :font "JetBrainsMono Nerd Font" 
                    :weight 'medium
                    :height 170)

