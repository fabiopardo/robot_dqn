; Auto-generated. Do not edit!


(cl:in-package robot_expe-srv)


;//! \htmlinclude NextTargetLocation-request.msg.html

(cl:defclass <NextTargetLocation-request> (roslisp-msg-protocol:ros-message)
  ()
)

(cl:defclass NextTargetLocation-request (<NextTargetLocation-request>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <NextTargetLocation-request>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'NextTargetLocation-request)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name robot_expe-srv:<NextTargetLocation-request> is deprecated: use robot_expe-srv:NextTargetLocation-request instead.")))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <NextTargetLocation-request>) ostream)
  "Serializes a message object of type '<NextTargetLocation-request>"
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <NextTargetLocation-request>) istream)
  "Deserializes a message object of type '<NextTargetLocation-request>"
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<NextTargetLocation-request>)))
  "Returns string type for a service object of type '<NextTargetLocation-request>"
  "robot_expe/NextTargetLocationRequest")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'NextTargetLocation-request)))
  "Returns string type for a service object of type 'NextTargetLocation-request"
  "robot_expe/NextTargetLocationRequest")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<NextTargetLocation-request>)))
  "Returns md5sum for a message object of type '<NextTargetLocation-request>"
  "4a842b65f413084dc2b10fb484ea7f17")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'NextTargetLocation-request)))
  "Returns md5sum for a message object of type 'NextTargetLocation-request"
  "4a842b65f413084dc2b10fb484ea7f17")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<NextTargetLocation-request>)))
  "Returns full string definition for message of type '<NextTargetLocation-request>"
  (cl:format cl:nil "~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'NextTargetLocation-request)))
  "Returns full string definition for message of type 'NextTargetLocation-request"
  (cl:format cl:nil "~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <NextTargetLocation-request>))
  (cl:+ 0
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <NextTargetLocation-request>))
  "Converts a ROS message object to a list"
  (cl:list 'NextTargetLocation-request
))
;//! \htmlinclude NextTargetLocation-response.msg.html

(cl:defclass <NextTargetLocation-response> (roslisp-msg-protocol:ros-message)
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

(cl:defclass NextTargetLocation-response (<NextTargetLocation-response>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <NextTargetLocation-response>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'NextTargetLocation-response)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name robot_expe-srv:<NextTargetLocation-response> is deprecated: use robot_expe-srv:NextTargetLocation-response instead.")))

(cl:ensure-generic-function 'x-val :lambda-list '(m))
(cl:defmethod x-val ((m <NextTargetLocation-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader robot_expe-srv:x-val is deprecated.  Use robot_expe-srv:x instead.")
  (x m))

(cl:ensure-generic-function 'y-val :lambda-list '(m))
(cl:defmethod y-val ((m <NextTargetLocation-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader robot_expe-srv:y-val is deprecated.  Use robot_expe-srv:y instead.")
  (y m))

(cl:ensure-generic-function 'z-val :lambda-list '(m))
(cl:defmethod z-val ((m <NextTargetLocation-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader robot_expe-srv:z-val is deprecated.  Use robot_expe-srv:z instead.")
  (z m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <NextTargetLocation-response>) ostream)
  "Serializes a message object of type '<NextTargetLocation-response>"
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
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <NextTargetLocation-response>) istream)
  "Deserializes a message object of type '<NextTargetLocation-response>"
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
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<NextTargetLocation-response>)))
  "Returns string type for a service object of type '<NextTargetLocation-response>"
  "robot_expe/NextTargetLocationResponse")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'NextTargetLocation-response)))
  "Returns string type for a service object of type 'NextTargetLocation-response"
  "robot_expe/NextTargetLocationResponse")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<NextTargetLocation-response>)))
  "Returns md5sum for a message object of type '<NextTargetLocation-response>"
  "4a842b65f413084dc2b10fb484ea7f17")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'NextTargetLocation-response)))
  "Returns md5sum for a message object of type 'NextTargetLocation-response"
  "4a842b65f413084dc2b10fb484ea7f17")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<NextTargetLocation-response>)))
  "Returns full string definition for message of type '<NextTargetLocation-response>"
  (cl:format cl:nil "float64 x~%float64 y~%float64 z~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'NextTargetLocation-response)))
  "Returns full string definition for message of type 'NextTargetLocation-response"
  (cl:format cl:nil "float64 x~%float64 y~%float64 z~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <NextTargetLocation-response>))
  (cl:+ 0
     8
     8
     8
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <NextTargetLocation-response>))
  "Converts a ROS message object to a list"
  (cl:list 'NextTargetLocation-response
    (cl:cons ':x (x msg))
    (cl:cons ':y (y msg))
    (cl:cons ':z (z msg))
))
(cl:defmethod roslisp-msg-protocol:service-request-type ((msg (cl:eql 'NextTargetLocation)))
  'NextTargetLocation-request)
(cl:defmethod roslisp-msg-protocol:service-response-type ((msg (cl:eql 'NextTargetLocation)))
  'NextTargetLocation-response)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'NextTargetLocation)))
  "Returns string type for a service object of type '<NextTargetLocation>"
  "robot_expe/NextTargetLocation")