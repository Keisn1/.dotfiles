;; ;; (require 'crafted-evil-packages)
;; (package-install-selected-packages :noconfirm)

;; (require 'crafted-defaults-config)
;; ;; (require 'crafted-evil-config)

;; ;; Profile emacs startup
;; ;; showing the startup time in the echo area
;; (defun ce-base-example/display-startup-time ()
;;   "Display the startup time after Emacs is fully initialized."
;;   (message "Crafted Emacs loaded in %s."
;;            (emacs-init-time)))
;; (add-hook 'emacs-startup-hook #'ce-base-example/display-startup-time)

;; ;; Turning off menu-bar, tool-bar and scroll-bar
;; (menu-bar-mode -1)
;; (tool-bar-mode -1)
;; (scroll-bar-mode -1)

;; (set-face-attribute 'default nil
;;                     :font "Hack Nerd Font"
;;                     :height 120)
