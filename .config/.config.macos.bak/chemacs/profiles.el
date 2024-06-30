;; your custom or vanilla emacs profile
(("default" . ((user-emacs-directory . "~/.config/.gnu-emacs")
               (server-name . "gnu")))

 ;; emacs distribution: Crafted-emacs
 ("crafted" . ((user-emacs-directory . "~/.config/.crafted-emacs")
                (server-name . "crafted")))

 ("doom" . ((user-emacs-directory . "~/.config/.doom-emacs")
            (server-name . "doom")
            (env . (("DOOMDIR" . "~/.config/doom")))))

 )
;; emacs distribution: DOOM-emacs
;; )


