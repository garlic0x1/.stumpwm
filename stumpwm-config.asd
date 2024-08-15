(asdf:defsystem "stumpwm-config"
  :author "garlic0x1"
  :depends-on (:slynk
               :cl-workers
               :str
               :clx-truetype
               :ttf-fonts
               :dmenu)
  :components ((:module "src"
                :components ((:file "package")
                             (:file "appearance")
                             (:file "modeline")
                             (:file "core")))))
