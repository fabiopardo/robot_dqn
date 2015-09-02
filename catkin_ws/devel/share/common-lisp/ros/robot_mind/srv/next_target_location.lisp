; Auto-generated. Do not edit!


(cl:in-package robot_mind-srv)


;//! \htmlinclude next_target_location-request.msg.html

(cl:defclass <next_target_location-request> (roslisp-msg-protocol:ros-message)
  ()
)

(cl:defclass next_target_location-request (<next_target_location-request>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <next_target_location-request>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'next_target_location-request)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name robot_mind-srv:<next_target_location-request> is deprecated: use robot_mind-srv:next_target_location-request instead.")))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <next_target_location-request>) ostream)
  "Serializes a message object of type '<next_target_location-request>"
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <next_target_location-request>) istream)
  "Deserializes a message object of type '<next_target_location-request>"
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<next_target_location-request>)))
  "Returns string type for a service object of type '<next_target_location-request>"
  "robot_mind/next_target_locationRequest")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'next_target_location-request)))
  "Returns string type for a service object of type 'next_target_location-request"
  "robot_mind/next_target_locationRequest")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<next_target_location-request>)))
  "Returns md5sum for a message object of type '<next_target_location-request>"
  "4a842b65f413084dc2b10fb484ea7f17")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'next_target_location-request)))
  "Returns md5sum for a message object of type 'next_target_location-request"
  "4a842b65f413084dc2b10fb484ea7f17")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<next_target_location-request>)))
  "Returns full string definition for message of type '<next_target_location-request>"
  (cl:format cl:nil "~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'next_target_location-request)))
  "Returns full string definition for message of type 'next_target_location-request"
  (cl:format cl:nil "~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <next_target_location-request>))
  (cl:+ 0
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <next_target_location-request>))
  "Converts a ROS message object to a list"
  (cl:list 'next_target_location-request
))
;//! \htmlinclude next_target_location-response.msg.html

(cl:defclass <next_target_location-response> (roslisp-msg-protocol:ros-message)
  ((x
    :reader x
    :initarg :x
    :type cl:float
    :initform 0.0)
   (y
    :reader y
    :initarg :y
    :type cl:float
    :initform 0.0)
   (z
    :reader z
    :initarg :z
    :type cl:float
    :initform 0.0))
)

(cl:defclass next_target_location-response (<next_target_location-response>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <next_target_location-response>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'next_target_location-response)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name robot_mind-srv:<next_target_location-response> is deprecated: use robot_mind-srv:next_target_location-response instead.")))

(cl:ensure-generic-function 'x-val :lambda-list '(m))
(cl:defmethod x-val ((m <next_target_location-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader robot_mind-srv:x-val is deprecated.  Use robot_mind-srv:x instead.")
  (x m))

(cl:ensure-generic-function 'y-val :lambda-list '(m))
(cl:defmethod y-val ((m <next_target_location-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader robot_mind-srv:y-val is deprecated.  Use robot_mind-srv:y instead.")
  (y m))

(cl:ensure-generic-function 'z-val :lambda-list '(m))
(cl:defmethod z-val ((m <next_target_location-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader robot_mind-srv:z-val is deprecated.  Use robot_mind-srv:z instead.")
  (z m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <next_target_location-response>) ostream)
  "Serializes a message object of type '<next_target_location-response>"
  (cl:let ((bits (roslisp-utils:encode-double-float-bits (cl:slot-value msg 'x))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream))
  (cl:let ((bits (roslisp-utils:encode-double-float-bits (cl:slot-value msg 'y))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream))
  (cl:let ((bits (roslisp-utils:encode-double-float-bits (cl:slot-value msg 'z))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <next_target_location-response>) istream)
  "Deserializes a message object of type '<next_target_location-response>"
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'x) (roslisp-utils:decode-double-float-bits bits)))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'y) (roslisp-utils:decode-double-float-bits bits)))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'z) (roslisp-utils:decode-double-float-bits bits)))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<next_target_location-response>)))
  "Returns string type for a service object of type '<next_target_location-response>"
  "robot_mind/next_target_locationResponse")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'next_target_location-response)))
  "Returns string type for a service object of type 'next_target_location-response"
  "robot_mind/next_target_locationResponse")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<next_target_location-response>)))
  "Returns md5sum for a message object of type '<next_target_location-response>"
  "4a842b65f413084dc2b10fb484ea7f17")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'next_target_location-response)))
  "Returns md5sum for a message object of type 'next_target_location-response"
  "4a842b65f413084dc2b10fb484ea7f17")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<next_target_location-response>)))
  "Returns full string definition for message of type '<next_target_location-response>"
  (cl:format cl:nil "float64 x~%float64 y~%float64 z~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'next_target_location-response)))
  "Returns full string definition for message of type 'next_target_location-response"
  (cl:format cl:nil "float64 x~%float64 y~%float64 z~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <next_target_location-response>))
  (cl:+ 0
     8
     8
     8
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <next_target_location-response>))
  "Converts a ROS message object to a list"
  (cl:list 'next_target_location-response
    (cl:cons ':x (x msg))
    (cl:cons ':y (y msg))
    (cl:cons ':z (z msg))
))
(cl:defmethod roslisp-msg-protocol:service-request-type ((msg (cl:eql 'next_target_location)))
  'next_target_location-request)
(cl:defmethod roslisp-msg-protocol:service-response-type ((msg (cl:eql 'next_target_location)))
  'next_target_location-response)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'next_target_location)))
  "Returns string type for a service object of type '<next_target_location>"
  "robot_mind/next_target_location")