(in-package :stumpwm-config)

(uiop:launch-program "xinput set-prop 'SynPS/2 Synaptics TouchPad' 'libinput Natural Scrolling Enabled' 1")
(uiop:launch-program "xmodmap ~/.Xmodmap")

(set-prefix-key (kbd "C-s"))
(setf *mouse-focus-policy* :click)

(setf dmenu:*dmenu-position* :top
      dmenu:*dmenu-font* "TerminusMedium-14"
      dmenu:*dmenu-background-color* "'#333333'"
      dmenu:*dmenu-foreground-color* "'#7f7f7f'"
      dmenu:*dmenu-selected-background-color*  "'#7f7f7f'"
      dmenu:*dmenu-selected-foreground-color*  "'#333333'")

(defmacro define-keys (map &body keybinds)
  `(progn
     ,@(mapcar (lambda (keybind)
                 `(define-key ,map ,(first keybind) ,(second keybind)))
               keybinds)))

(defmacro undefine-keys (map &body keys)
  `(progn
     ,@(mapcar (lambda (key)
                 `(undefine-key ,map ,key))
               keys)))

(undefine-keys *root-map*
  ;; clean stuff that I want C- prefix of
  (kbd "e")
  (kbd "c")
  (kbd "n")
  (kbd "p")
  (kbd "k")
  (kbd "K")

  ;; wtf?
  (kbd "Q")

  ;; clean stuff that's on modeline
  (kbd "a")
  (kbd "C-a"))

;;---------------;;
;; Misc Commands ;;
;;---------------;;

(defcommand start-repl () ()
  (slynk:create-server
   :dont-close t
   :port 1337))

(defcommand battery () ()
  (echo (uiop:read-file-string "/sys/class/power_supply/BAT0/capacity")))

(defcommand playerctl () ()
  (let ((sel (dmenu:dmenu :item-list '("play-pause" "next" "previous" "stop")
                          :prompt "Player: ")))
    (uiop:launch-program (uiop:strcat "playerctl " sel))))

;;------------;;
;; Basic Apps ;;
;;------------;;

(defparameter *browser* "firefox")
(defparameter *filer* "nautilus")
(defparameter *terminal* "kgx")

(defcommand browser () ()
  (run-or-raise *browser* '(:class "Browser")))

(defcommand filer () ()
  (run-or-raise *filer* '(:class "Filer")))

(defcommand terminal () ()
  (run-or-raise *terminal* '(:class "Terminal")))

(defcommand dmenu-launch () ()
  ;; (bt:make-thread
  ;;  (lambda ()))
  (uiop:launch-program
   (format nil "dmenu_run ~A -p Run: "
           (dmenu::dmenu-build-cmd-options))))

(defcommand screenshot () ()
  (let ((sel (dmenu:dmenu :item-list '("Full" "Selection" "Window")
                          :prompt "Screenshot: "))
        (program "scrot")
        (clip " -e 'xclip -selection clipboard -t image/png -i $f'"))
    (cond ((string-equal "Full" sel)
           (uiop:launch-program (uiop:strcat program clip)))
          ((string-equal "Window" sel)
           (uiop:launch-program (uiop:strcat program " -u" clip)))
          ((string-equal "Selection" sel)
           (uiop:launch-program (uiop:strcat program " -s" clip))))))

(define-keys *root-map*
  ((kbd "c") "dmenu-call-command")
  ((kbd "r") "dmenu-launch")
  ((kbd "C-Right") "resize 32 0")
  ((kbd "C-Left") "resize -32 0")
  ((kbd "C-]") "gnext")
  ((kbd "C-[") "gprev")
  ((kbd "C-r") "iresize")
  ((kbd "C-b") "browser")
  ((kbd "C-c") "terminal")
  ((kbd "C-f") "only")
  ((kbd "C-k") "delete")
  ((kbd "s") "vsplit")
  ((kbd "v") "hsplit")
  ((kbd "j") "next")
  ((kbd "k") "prev"))

;;------------;;
;; Media Keys ;;
;;------------;;

(define-keys *top-map*
  ((kbd "Print") "screenshot")
  ((kbd "XF86AudioLowerVolume") "exec pactl set-sink-volume @DEFAULT_SINK@ -5%")
  ((kbd "XF86AudioRaiseVolume") "exec pactl set-sink-volume @DEFAULT_SINK@ +5%")
  ((kbd "XF86AudioMute") "exec pactl set-sink-mute @DEFAULT_SINK@ toggle")
  ((kbd "XF86AudioMicMute") "exec pamixer --default-source --toggle-mute")
  ((kbd "XF86MonBrightnessUp") "exec brightnessctl set +5%")
  ((kbd "XF86MonBrightnessDown") "exec brightnessctl set 5%-"))
