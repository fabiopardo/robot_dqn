// Generated by gencpp from file robot_mind/NextTargetLocation.msg
// DO NOT EDIT!


#ifndef ROBOT_MIND_MESSAGE_NEXTTARGETLOCATION_H
#define ROBOT_MIND_MESSAGE_NEXTTARGETLOCATION_H

#include <ros/service_traits.h>


#include <robot_mind/NextTargetLocationRequest.h>
#include <robot_mind/NextTargetLocationResponse.h>


namespace robot_mind
{

struct NextTargetLocation
{

typedef NextTargetLocationRequest Request;
typedef NextTargetLocationResponse Response;
Request request;
Response response;

typedef Request RequestType;
typedef Response ResponseType;

}; // struct NextTargetLocation
} // namespace robot_mind


namespace ros
{
namespace service_traits
{


template<>
struct MD5Sum< ::robot_mind::NextTargetLocation > {
  static const char* value()
  {
    return "4a842b65f413084dc2b10fb484ea7f17";
  }

  static const char* value(const ::robot_mind::NextTargetLocation&) { return value(); }
};

template<>
struct DataType< ::robot_mind::NextTargetLocation > {
  static const char* value()
  {
    return "robot_mind/NextTargetLocation";
  }

  static const char* value(const ::robot_mind::NextTargetLocation&) { return value(); }
};


// service_traits::MD5Sum< ::robot_mind::NextTargetLocationRequest> should match 
// service_traits::MD5Sum< ::robot_mind::NextTargetLocation > 
template<>
struct MD5Sum< ::robot_mind::NextTargetLocationRequest>
{
  static const char* value()
  {
    return MD5Sum< ::robot_mind::NextTargetLocation >::value();
  }
  static const char* value(const ::robot_mind::NextTargetLocationRequest&)
  {
    return value();
  }
};

// service_traits::DataType< ::robot_mind::NextTargetLocationRequest> should match 
// service_traits::DataType< ::robot_mind::NextTargetLocation > 
template<>
struct DataType< ::robot_mind::NextTargetLocationRequest>
{
  static const char* value()
  {
    return DataType< ::robot_mind::NextTargetLocation >::value();
  }
  static const char* value(const ::robot_mind::NextTargetLocationRequest&)
  {
    return value();
  }
};

// service_traits::MD5Sum< ::robot_mind::NextTargetLocationResponse> should match 
// service_traits::MD5Sum< ::robot_mind::NextTargetLocation > 
template<>
struct MD5Sum< ::robot_mind::NextTargetLocationResponse>
{
  static const char* value()
  {
    return MD5Sum< ::robot_mind::NextTargetLocation >::value();
  }
  static const char* value(const ::robot_mind::NextTargetLocationResponse&)
  {
    return value();
  }
};

// service_traits::DataType< ::robot_mind::NextTargetLocationResponse> should match 
// service_traits::DataType< ::robot_mind::NextTargetLocation > 
template<>
struct DataType< ::robot_mind::NextTargetLocationResponse>
{
  static const char* value()
  {
    return DataType< ::robot_mind::NextTargetLocation >::value();
  }
  static const char* value(const ::robot_mind::NextTargetLocationResponse&)
  {
    return value();
  }
};

} // namespace service_traits
} // namespace ros

#endif // ROBOT_MIND_MESSAGE_NEXTTARGETLOCATION_H
