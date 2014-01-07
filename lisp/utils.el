;; OpCode SCRUM hacks elisp code

(defun opc:deadlinize-all ()
  (interactive)
  (opc:for-each-first-header 'opc:deadlinize))

(defun opc:for-each-first-header (fn)
  (save-excursion
    (beginning-of-buffer)
    (while (re-search-forward "^* " nil t)
      (funcall fn))))

(defun opc:deadlinize ()
  (interactive)
  (save-excursion
    (unless (= 1 (org-current-level))
      (search-backward-regexp "^* " nil t))
    (let ((timestamp-regex
           ;; org-re-timestamp is only from newer org-modes
           (if (boundp 'org-re-timestamp)
               (org-re-timestamp 'all)
             "<\\(.*\\)>")))
      (message timestamp-regex)
      (beginning-of-line)
      (re-search-forward timestamp-regex nil t)
      (let ((time (match-string 1)))
        (org-map-tree
         '(lambda ()
            (if (and (< 2 (org-current-level))
                     (not (org-get-deadline-time (point))))
                (org-deadline nil time))))))))


;;   If you would like a TODO entry to automatically change to DONE when
;;   all children are done, you can use the following setup:

     (defun org-summary-todo (n-done n-not-done)
       "Switch entry to DONE when all subentries are done, to TODO otherwise."
       (let (org-log-done org-log-states)   ; turn off logging
         (org-todo (if (= n-not-done 0) "DONE" "TODO"))))

     (add-hook 'org-after-todo-statistics-hook 'org-summary-todo)
