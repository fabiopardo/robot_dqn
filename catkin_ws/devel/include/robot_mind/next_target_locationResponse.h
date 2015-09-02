// Generated by gencpp from file robot_mind/next_target_locationResponse.msg
// DO NOT EDIT!


#ifndef ROBOT_MIND_MESSAGE_NEXT_TARGET_LOCATIONRESPONSE_H
#define ROBOT_MIND_MESSAGE_NEXT_TARGET_LOCATIONRESPONSE_H


#include <string>
#include <vector>
#include <map>

#include <ros/types.h>
#include <ros/serialization.h>
#include <ros/builtin_message_traits.h>
#include <ros/message_operations.h>


namespace robot_mind
{
template <class ContainerAllocator>
struct next_target_locationResponse_
{
  typedef next_target_locationResponse_<ContainerAllocator> Type;

  next_target_locationResponse_()
    : x(0.0)
    , y(0.0)
    , z(0.0)  {
    }
  next_target_locationResponse_(const ContainerAllocator& _alloc)
    : x(0.0)
    , y(0.0)
    , z(0.0)  {
    }



   typedef double _x_type;
  _x_type x;

   typedef double _y_type;
  _y_type y;

   typedef double _z_type;
  _z_type z;




  typedef boost::shared_ptr< ::robot_mind::next_target_locationResponse_<ContainerAllocator> > Ptr;
  typedef boost::shared_ptr< ::robot_mind::next_target_locationResponse_<ContainerAllocator> const> ConstPtr;

}; // struct next_target_locationResponse_

typedef ::robot_mind::next_target_locationResponse_<std::allocator<void> > next_target_locationResponse;

typedef boost::shared_ptr< ::robot_mind::next_target_locationResponse > next_target_locationResponsePtr;
typedef boost::shared_ptr< ::robot_mind::next_target_locationResponse const> next_target_locationResponseConstPtr;

// constants requiring out of line definition



template<typename ContainerAllocator>
std::ostream& operator<<(std::ostream& s, const ::robot_mind::next_target_locationResponse_<ContainerAllocator> & v)
{
ros::message_operations::Printer< ::robot_mind::next_target_locationResponse_<ContainerAllocator> >::stream(s, "", v);
return s;
}

} // namespace robot_mind

namespace ros
{
namespace message_traits
{



// BOOLTRAITS {'IsFixedSize': True, 'IsMessage': True, 'HasHeader': False}
// {'std_msgs': ['/opt/ros/jade/share/std_msgs/cmake/../msg']}

// !!!!!!!!!!! ['__class__', '__delattr__', '__dict__', '__doc__', '__eq__', '__format__', '__getattribute__', '__hash__', '__init__', '__module__', '__ne__', '__new__', '__reduce__', '__reduce_ex__', '__repr__', '__setattr__', '__sizeof__', '__str__', '__subclasshook__', '__weakref__', '_parsed_fields', 'constants', 'fields', 'full_name', 'has_header', 'header_present', 'names', 'package', 'parsed_fields', 'short_name', 'text', 'types']




template <class ContainerAllocator>
struct IsFixedSize< ::robot_mind::next_target_locationResponse_<ContainerAllocator> >
  : TrueType
  { };

template <class ContainerAllocator>
struct IsFixedSize< ::robot_mind::next_target_locationResponse_<ContainerAllocator> const>
  : TrueType
  { };

template <class ContainerAllocator>
struct IsMessage< ::robot_mind::next_target_locationResponse_<ContainerAllocator> >
  : TrueType
  { };

template <class ContainerAllocator>
struct IsMessage< ::robot_mind::next_target_locationResponse_<ContainerAllocator> const>
  : TrueType
  { };

template <class ContainerAllocator>
struct HasHeader< ::robot_mind::next_target_locationResponse_<ContainerAllocator> >
  : FalseType
  { };

template <class ContainerAllocator>
struct HasHeader< ::robot_mind::next_target_locationResponse_<ContainerAllocator> const>
  : FalseType
  { };


template<class ContainerAllocator>
struct MD5Sum< ::robot_mind::next_target_locationResponse_<ContainerAllocator> >
{
  static const char* value()
  {
    return "4a842b65f413084dc2b10fb484ea7f17";
  }

  static const char* value(const ::robot_mind::next_target_locationResponse_<ContainerAllocator>&) { return value(); }
  static const uint64_t static_value1 = 0x4a842b65f413084dULL;
  static const uint64_t static_value2 = 0xc2b10fb484ea7f17ULL;
};

template<class ContainerAllocator>
struct DataType< ::robot_mind::next_target_locationResponse_<ContainerAllocator> >
{
  static const char* value()
  {
    return "robot_mind/next_target_locationResponse";
  }

  static const char* value(const ::robot_mind::next_target_locationResponse_<ContainerAllocator>&) { return value(); }
};

template<class ContainerAllocator>
struct Definition< ::robot_mind::next_target_locationResponse_<ContainerAllocator> >
{
  static const char* value()
  {
    return "float64 x\n\
float64 y\n\
float64 z\n\
\n\
";
  }

  static const char* value(const ::robot_mind::next_target_locationResponse_<ContainerAllocator>&) { return value(); }
};

} // namespace message_traits
} // namespace ros

namespace ros
{
namespace serialization
{

  template<class ContainerAllocator> struct Serializer< ::robot_mind::next_target_locationResponse_<ContainerAllocator> >
  {
    template<typename Stream, typename T> inline static void allInOne(Stream& stream, T m)
    {
      stream.next(m.x);
      stream.next(m.y);
      stream.next(m.z);
    }

    ROS_DECLARE_ALLINONE_SERIALIZER;
  }; // struct next_target_locationResponse_

} // namespace serialization
} // namespace ros

namespace ros
{
namespace message_operations
{

template<class ContainerAllocator>
struct Printer< ::robot_mind::next_target_locationResponse_<ContainerAllocator> >
{
  template<typename Stream> static void stream(Stream& s, const std::string& indent, const ::robot_mind::next_target_locationResponse_<ContainerAllocator>& v)
  {
    s << indent << "x: ";
    Printer<double>::stream(s, indent + "  ", v.x);
    s << indent << "y: ";
    Printer<double>::stream(s, indent + "  ", v.y);
    s << indent << "z: ";
    Printer<double>::stream(s, indent + "  ", v.z);
  }
};

} // namespace message_operations
} // namespace ros

#endif // ROBOT_MIND_MESSAGE_NEXT_TARGET_LOCATIONRESPONSE_H