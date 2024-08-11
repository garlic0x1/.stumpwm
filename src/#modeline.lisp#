(in-package :stumpwm-config)

(defun show-music ()
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
               (str:shorten 20 title)
               (str:shorten 20 artist))))))

(defun show-battery ()
  (ignore-errors
   (format nil "Battery: ~a% | "
           (uiop:read-file-line "/sys/class/power_supply/BAT0/capacity"))))

(setf *window-format* "%m%n%s%c"
      *time-modeline-string* "%a %b %e %k:%M"
      *mode-line-timeout* 1
      *screen-mode-line-format*
      (list
       "%W^>"
       '(:eval (show-music))
       '(:eval (show-battery))
       "%d"))

(enable-mode-line (current-screen) (current-head) t)
(set-font "-xos4-terminus-medium-r-normal-*-20-*-*-*-*-*-*-*")
