
(cl:in-package :asdf)

(defsystem "robot_mind-srv"
  :depends-on (:roslisp-msg-protocol :roslisp-utils )
  :components ((:file "_package")
    (:file "NextTargetLocation" :depends-on ("_package_NextTargetLocation"))
    (:file "_package_NextTargetLocation" :depends-on ("_package"))
  ))