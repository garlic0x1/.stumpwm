(in-package :stumpwm-config)

(defun show-battery ()
  (format nil "Battery: ~a%"
          (uiop:read-file-line "/sys/class/power_supply/BAT0/capacity")))

(setf *window-format* "%m%n%s%c"
      *time-modeline-string* "%a %b %e %k:%M"
      *mode-line-timeout* 1
      *screen-mode-line-format*
      (list
       "%W^>"
       '(:eval (show-battery))
       " | %d"))

(enable-mode-line (current-screen) (current-head) t)
(set-font "-xos4-terminus-medium-r-normal-*-20-*-*-*-*-*-*-*")
