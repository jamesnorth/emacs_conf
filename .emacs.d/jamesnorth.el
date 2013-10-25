
(message "Loading my library of Emacs-Lisp code")

(defun insert-c-header-block ()
  "Inserts a C header block to prevent including the header more than once"
  (interactive)
  (let ((parts (split-string (buffer-name) "[\.]")))
    (let ((tag (format "__%s_%s__" (upcase (car parts)) (upcase (car (cdr parts))))))
      (goto-char (point-min))
      (insert "#ifndef " tag "\n")
      (insert "#define " tag "\n\n")
      (goto-char (point-max))
      (insert "\n")
      (insert "#endif /* " tag " */\n"))))

; from https://github.com/al3x/emacs/blob/master/utilities/rename-file-and-buffer.el
(defun rename-file-and-buffer (new-name)
  (interactive "sNew name: ")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not filename)
        (message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
          (message "A buffer named '%s' already exists!" new-name)
        (progn
          (rename-file name new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil))))))

(defun indent-whole-buffer ()
  "indent whole buffer"
  (interactive)
  (delete-trailing-whitespace)
  (indent-region (point-min) (point-max) nil)
  (untabify (point-min) (point-max)))

;;;----------------------------------------------------------------------------
;;; Easily count words (http://emacs-fu.blogspot.com/2009/01/counting-words.html)
;;;----------------------------------------------------------------------------
(defun count-words (&optional begin end)
  "count words between BEGIN and END (region); if no region defined, count words in buffer"
  (interactive "r")
  (let ((b (if mark-active begin (point-min)))
        (e (if mark-active end (point-max))))
    (message "Word count: %s" (how-many "\\w+" b e))))

(defun avg (&rest args)
  (/ (apply #'sum args) (length args)))

(provide 'jamesnorth)

