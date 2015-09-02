#include <Controller.h>
#include <ControllerEvent.h>
#include <Logger.h>
#include <ViewImage.h>
#include <math.h>

#define PI 3.141592
#define DEG2RAD(DEG) ( (PI) * (DEG) / 180.0 )

class RobotController : public Controller
{
public:
  void onInit(InitEvent &evt);
  double onAction(ActionEvent &evt);
  void onRecvMsg(RecvMsgEvent &evt);

private:
  ViewService* m_view;
  double vel;
};

void RobotController::onInit(InitEvent &evt)
{
  // Setting the velocity
  vel = 10.0;
  // Connecting service
  m_view = (ViewService*)connectToService("SIGViewer");
}

// Callback function which is called frequently
double RobotController::onAction(ActionEvent &evt)
{
  return 10.0;
}

// Callback function which is called when a message comes
void RobotController::onRecvMsg(RecvMsgEvent &evt)
{
  static int iImage = 0;

  // Display the received message
  std::string msg = evt.getMsg();
  LOG_MSG(("msg : %s", msg.c_str()));

  // Execute captureView when a message "capture" comes
  if (msg == "capture") {
    if(m_view != NULL) {

      ViewImage *img = m_view->captureView(2, COLORBIT_24, IMAGE_320X240);
      if (img != NULL) {

        // Receiving an image data
        char *buf = img->getBuffer();

        // Save in Windows BMP format
        char fname[256];
        sprintf(fname, "view%03d.bmp", iImage++);
        img->saveAsWindowsBMP(fname);

        // Release the memory
        delete img;
      }
    }
  }

  // Rorate the agent when a message "rotation" comes
  if (msg == "rotation"){

    SimObj *my = getObj(myname());

    // Reference of quaternion
    double qy = my->qy();

    // Calculate Euler angle from the quaternion
    double theta = 2*asin(qy);

    // Rorate the body
    double y = theta + DEG2RAD(45);
    if( y >= PI)
      y = y - 2 * PI;

    my->setAxisAndAngle(0, 1.0, 0, y);
   }

  // Going forward when a message "move" comes
  if (msg == "move"){

    SimObj *my = getObj(myname());

    // Get the current position
    Vector3d pos;
    my->getPosition(pos);

    double qy = my->qy();

    // Calculate Euler angle from the quaternion
    double theta = 2*asin(qy);

    // Movement distance
    double dx = 0.0;
    double dz = 0.0;

    // Calculate the movement orientation
    dx = sin(theta) * vel;
    dz = cos(theta) * vel;

    // Move
    my->setPosition( pos.x() + dx, pos.y() , pos.z() + dz );
  }
}

extern "C" Controller * createController ()
{
  return new RobotController;
}

