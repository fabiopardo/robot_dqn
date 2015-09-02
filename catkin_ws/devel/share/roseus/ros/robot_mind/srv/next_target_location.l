;; Auto-generated. Do not edit!


(when (boundp 'robot_mind::next_target_location)
  (if (not (find-package "ROBOT_MIND"))
    (make-package "ROBOT_MIND"))
  (shadow 'next_target_location (find-package "ROBOT_MIND")))
(unless (find-package "ROBOT_MIND::NEXT_TARGET_LOCATION")
  (make-package "ROBOT_MIND::NEXT_TARGET_LOCATION"))
(unless (find-package "ROBOT_MIND::NEXT_TARGET_LOCATIONREQUEST")
  (make-package "ROBOT_MIND::NEXT_TARGET_LOCATIONREQUEST"))
(unless (find-package "ROBOT_MIND::NEXT_TARGET_LOCATIONRESPONSE")
  (make-package "ROBOT_MIND::NEXT_TARGET_LOCATIONRESPONSE"))

(in-package "ROS")





(defclass robot_mind::next_target_locationRequest
  :super ros::object
  :slots ())

(defmethod robot_mind::next_target_locationRequest
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

(defclass robot_mind::next_target_locationResponse
  :super ros::object
  :slots (_x _y _z ))

(defmethod robot_mind::next_target_locationResponse
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

(defclass robot_mind::next_target_location
  :super ros::object
  :slots ())

(setf (get robot_mind::next_target_location :md5sum-) "4a842b65f413084dc2b10fb484ea7f17")
(setf (get robot_mind::next_target_location :datatype-) "robot_mind/next_target_location")
(setf (get robot_mind::next_target_location :request) robot_mind::next_target_locationRequest)
(setf (get robot_mind::next_target_location :response) robot_mind::next_target_locationResponse)

(defmethod robot_mind::next_target_locationRequest
  (:response () (instance robot_mind::next_target_locationResponse :init)))

(setf (get robot_mind::next_target_locationRequest :md5sum-) "4a842b65f413084dc2b10fb484ea7f17")
(setf (get robot_mind::next_target_locationRequest :datatype-) "robot_mind/next_target_locationRequest")
(setf (get robot_mind::next_target_locationRequest :definition-)
      "---
float64 x
float64 y
float64 z

")

(setf (get robot_mind::next_target_locationResponse :md5sum-) "4a842b65f413084dc2b10fb484ea7f17")
(setf (get robot_mind::next_target_locationResponse :datatype-) "robot_mind/next_target_locationResponse")
(setf (get robot_mind::next_target_locationResponse :definition-)
      "---
float64 x
float64 y
float64 z

")



(provide :robot_mind/next_target_location "4a842b65f413084dc2b10fb484ea7f17")


