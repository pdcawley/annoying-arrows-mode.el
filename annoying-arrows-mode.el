;;; annoying-arrows-mode.el --- Ring the bell if using arrows too much

;; Copyright (C) 2011 Magnar Sveen

;; Author: Magnar Sveen <magnars@gmail.com>
;; Keywords: learning

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Entering annoying-arrows-mode makes emacs ring the bell in your
;; face if you use the arrow keys to move long distances.

;; Set the `annoying-arrows-too-far-count' to adjust the length.

;; Code:

(defvar annoying-arrows-too-far-count 10
  "Number of repeated arrow presses before emacs gets annoyed.")

(setq annoying-commands '())

(defvar annoying-arrows--current-count 0)

(defmacro add-annoying-arrows-advice (cmd alternatives)
  `(progn
     (add-to-list 'annoying-commands (quote ,cmd))
     (defadvice ,cmd (before annoying-arrows activate)
       (when annoying-arrows-mode
         (if (eq this-original-command real-last-command)
             (progn
               (incf annoying-arrows--current-count)
               (when (> annoying-arrows--current-count annoying-arrows-too-far-count)
                 (beep 1)
                 (let* ((alt (nth (random (length ,alternatives)) ,alternatives))
                        (key (substitute-command-keys (format "\\[%S]" alt))))
                   (message "Annoying! How about using %S (%s) instead?" alt key))))
           (setq annoying-arrows--current-count 0))))))

(add-annoying-arrows-advice previous-line '(ace-jump-mode backward-paragraph isearch-backward))
(add-annoying-arrows-advice next-line '(ace-jump-mode forward-paragraph isearch-forward))
(add-annoying-arrows-advice right-char '(jump-char-forward right-word))
(add-annoying-arrows-advice left-char '(jump-char-backward left-word))
(add-annoying-arrows-advice forward-char '(jump-char-forward right-word))
(add-annoying-arrows-advice backward-char '(jump-char-backward left-word))

(define-minor-mode annoying-arrows-mode
  "Annoying-Arrows emacs minor mode."
  nil "" nil)

(define-globalized-minor-mode global-annoying-arrows-mode
  annoying-arrows-mode annoying-arrows-mode)

(provide 'annoying-arrows-mode)
;; annoying-arrows-mode.el ends here
