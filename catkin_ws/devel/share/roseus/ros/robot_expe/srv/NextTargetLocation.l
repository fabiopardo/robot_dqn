;; Auto-generated. Do not edit!


(when (boundp 'robot_expe::NextTargetLocation)
  (if (not (find-package "ROBOT_EXPE"))
    (make-package "ROBOT_EXPE"))
  (shadow 'NextTargetLocation (find-package "ROBOT_EXPE")))
(unless (find-package "ROBOT_EXPE::NEXTTARGETLOCATION")
  (make-package "ROBOT_EXPE::NEXTTARGETLOCATION"))
(unless (find-package "ROBOT_EXPE::NEXTTARGETLOCATIONREQUEST")
  (make-package "ROBOT_EXPE::NEXTTARGETLOCATIONREQUEST"))
(unless (find-package "ROBOT_EXPE::NEXTTARGETLOCATIONRESPONSE")
  (make-package "ROBOT_EXPE::NEXTTARGETLOCATIONRESPONSE"))

(in-package "ROS")





(defclass robot_expe::NextTargetLocationRequest
  :super ros::object
  :slots ())

(defmethod robot_expe::NextTargetLocationRequest
  (:init
   (&key
    )
   (send-super :init)
   self)
  (:serialization-length
   ()
   (+
    0
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;;
   self)
  )

(defclass robot_expe::NextTargetLocationResponse
  :super ros::object
  :slots (_x _y _z ))

(defmethod robot_expe::NextTargetLocationResponse
  (:init
   (&key
    ((:x __x) 0.0)
    ((:y __y) 0.0)
    ((:z __z) 0.0)
    )
   (send-super :init)
   (setq _x (float __x))
   (setq _y (float __y))
   (setq _z (float __z))
   self)
  (:x
   (&optional __x)
   (if __x (setq _x __x)) _x)
  (:y
   (&optional __y)
   (if __y (setq _y __y)) _y)
  (:z
   (&optional __z)
   (if __z (setq _z __z)) _z)
  (:serialization-length
   ()
   (+
    ;; float64 _x
    8
    ;; float64 _y
    8
    ;; float64 _z
    8
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; float64 _x
       (sys::poke _x (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
     ;; float64 _y
       (sys::poke _y (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
     ;; float64 _z
       (sys::poke _z (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; float64 _x
     (setq _x (sys::peek buf ptr- :double)) (incf ptr- 8)
   ;; float64 _y
     (setq _y (sys::peek buf ptr- :double)) (incf ptr- 8)
   ;; float64 _z
     (setq _z (sys::peek buf ptr- :double)) (incf ptr- 8)
   ;;
   self)
  )

(defclass robot_expe::NextTargetLocation
  :super ros::object
  :slots ())

(setf (get robot_expe::NextTargetLocation :md5sum-) "4a842b65f413084dc2b10fb484ea7f17")
(setf (get robot_expe::NextTargetLocation :datatype-) "robot_expe/NextTargetLocation")
(setf (get robot_expe::NextTargetLocation :request) robot_expe::NextTargetLocationRequest)
(setf (get robot_expe::NextTargetLocation :response) robot_expe::NextTargetLocationResponse)

(defmethod robot_expe::NextTargetLocationRequest
  (:response () (instance robot_expe::NextTargetLocationResponse :init)))

(setf (get robot_expe::NextTargetLocationRequest :md5sum-) "4a842b65f413084dc2b10fb484ea7f17")
(setf (get robot_expe::NextTargetLocationRequest :datatype-) "robot_expe/NextTargetLocationRequest")
(setf (get robot_expe::NextTargetLocationRequest :definition-)
      "---
float64 x
float64 y
float64 z

")

(setf (get robot_expe::NextTargetLocationResponse :md5sum-) "4a842b65f413084dc2b10fb484ea7f17")
(setf (get robot_expe::NextTargetLocationResponse :datatype-) "robot_expe/NextTargetLocationResponse")
(setf (get robot_expe::NextTargetLocationResponse :definition-)
      "---
float64 x
float64 y
float64 z

")



(provide :robot_expe/NextTargetLocation "4a842b65f413084dc2b10fb484ea7f17")


