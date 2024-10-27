(load (expand-file-name "modules/bootstrap-straight" user-emacs-directory))

;; set custom.el file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (and custom-file
           (file-exists-p custom-file))
  (load custom-file nil :nomessage))

(message "load-file-name is: %s" load-file-name)
;; ;; load crafted init config
;; (load (expand-file-name  "modules/crafted-init-config" user-emacs-directory))

;; provide package
(provide 'early-init)
