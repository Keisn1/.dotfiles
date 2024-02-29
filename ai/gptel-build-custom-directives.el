;; Generate system prompts for =gptel=
;;   :PROPERTIES:
;;   :image:    img/coding-ai-hologram-1.jpeg-crop-4-3.png
;;   :END:

;;   This section will take all the tangled system prompt files to build the associative list for the =gptel-directives= variable in the [[https://github.com/karthink/gptel][gptel]] package.

;;   Structure for my [[https://github.com/gregoryg/gptel/tree/gregoryg][modified gptel]] is:

;;   + type: alist
;;     + key
;;       file basename ; e.g. =bojack=, =dutch-tutor=
;;     + description
;;       Nabbed from #+description:
;;     + prompt
;;       the non-commented body of the Markdown document - escape all unescaped double-quotes

;;     The magic Emacs Lisp function to create the alist

      (defun gjg/gptel-build-custom-directives (promptdir)
        "Build `gptel-custom-directives' from Markdown files in PROMPTDIR."
        (let* ((prompt-files (directory-files promptdir t "md$")))
          (mapcar (lambda (prompt-file)
                    ;; (list (intern (f-base prompt-file)) "filler1" "filler2")
                    (with-temp-buffer
                      (insert-file-contents prompt-file)
                      (let ((prompt-description "NO DESCRIPTION")
                            (prompt-text nil))
                        ;; nab the description - single-line descriptions only!
                        (goto-char (point-min))
                        (when (re-search-forward "#\\+description: \\(.*?\\) *--> *$" nil t)
                          (setq prompt-description (match-string 1)))
                        ;; remove all comments
                        (delete-matching-lines "^ *<!--" (point-min) (point-max))
                        (delete-matching-lines "^$" (point-min) (+ 1 (point-min))) ; remove first blank line if exists
                        (goto-char (point-min)) ;; not necessary, point is in the midst of comments to start

                        ;; return the megillah
                        (list
                         (intern (f-base prompt-file)) ; gptel-directives key
                         prompt-description
                         (buffer-substring-no-properties (point-min) (point-max)) ))))
                  prompt-files)))
