(in-package :stumpwm-config)

(defmacro deftimed (seconds name args &body body)
  (let ((next-time-var  (make-symbol "next-time"))
        (last-value-var (make-symbol "last-value")))
    `(let ((,next-time-var 0)
           ,last-value-var)
       (defun ,name ,args
         (let ((now (get-universal-time)))
           (if (< now ,next-time-var)
               ,last-value-var
               (setf ,next-time-var (+ now ,seconds)
                     ,last-value-var (progn ,@body))))))))

(defvar *ml-music-data* nil)
(defun show-music () *ml-music-data*)

(cl-workers:defworker/global :ml-music-actor () ()
  (setf *ml-music-data*
        (ignore-errors
         (labels ((ml-on-click-playerctl (code &rest rest)
                    (declare (ignore rest))
                    (let ((button (stumpwm::decode-button-code code)))
                      (case button
                        ((:left-button)
                         (run-shell-command "playerctl play-pause"))
                        ((:right-button)
                         (playerctl))))))
           (register-ml-on-click-id :ml-on-click-playerctl #'ml-on-click-playerctl)
           (destructuring-bind (&key title album artist) (music-data)
             (declare (ignore album))
             (format nil "^(:on-click :ml-on-click-playerctl)Music: ~a - ~a^(:on-click-end) | "
                     (str:shorten 24 title)
                     (str:shorten 24 artist))))))
  (sleep 1)
  (cl-workers:send :ml-music-actor))
(cl-workers:send :ml-music-actor)

(defun music-data ()
  (destructuring-bind (title album artist)
      (mapcar (lambda (s) (second (ppcre:split "  +" s)))
              (subseq
               (split-string
                (run-shell-command "playerctl metadata" t))
               1 4))
    (list :title title
          :album album
          :artist artist)))

(defun show-group ()
  (labels ((ml-on-click-group (code &rest rest)
             (declare (ignore rest))
             (let ((button (stumpwm::decode-button-code code)))
               (case button
                 ((:left-button)
                  (gnext))
                 ((:right-button)
                  (gprev))))))
    (register-ml-on-click-id :ml-on-click-group #'ml-on-click-group)
    "^(:on-click :ml-on-click-group)[%n]^(:on-click-end)"))

(deftimed 1 show-battery ()
  (ignore-errors
   (format nil "Battery: ~a% | "
           (uiop:read-file-line "/sys/class/power_supply/BAT0/capacity"))))

(setf *window-format* "%m%n%s%c"
      *time-modeline-string* "%a %b %e %k:%M"
      *mode-line-timeout* 1
      *screen-mode-line-format*
      (list
       '(:eval (show-group))
       "%W^>"
       '(:eval (show-music))
       '(:eval (show-battery))
       "%d"))

(enable-mode-line (current-screen) (current-head) t)
;; (set-font "-xos4-terminus-medium-r-normal-*-20-*-*-*-*-*-*-*")
