#include <iostream>
#include <string>
using namespace std;

class SoundDevice {
 public:
  class Sensor {
   public:
    unsigned long uid;
    unsigned long location;
    unsigned short volume;
    unsigned long VolumeAvg();
    unsigned short Send(int x);
    unsigned long GetUID();
    unsigned long GetLocation();
  };

  class WiFi {
   public:
    unsigned long SSID;
    unsigned long Password;
    void ConnectWiFi(unsigned long ssid, unsigned long password);
    void ReconnectWiFi();
  };
};

unsigned long SoundDevice::Sensor::VolumeAvg() {
  /* * * * * * * * * * * * * * * * * * * * * * * */
  /* Calculate volume average and return Send()  */
  /* * * * * * * * * * * * * * * * * * * * * * * */
}
unsigned short SoundDevice::Sensor::Send(int x) {
  /* * * * * * * * * * */
  /* Send x to server  */
  /* * * * * * * * * * */
}

unsigned long SoundDevice::Sensor::GetUID() {
  /* * * * * * * * * * * */
  /* Get uid of sensor   */
  /* * * * * * * * * * * */
}

unsigned long SoundDevice::Sensor::GetLocation() {
  /* * * * * * * * * * * * * * */
  /* Get location of sensor    */
  /* * * * * * * * * * * * * * */
}

void SoundDevice::WiFi::ConnectWiFi(unsigned long ssid,
                                    unsigned long password) {
  /* * * * * * * * * * * * * * * * * * * * * * * * */
  /* Initial sensor setup for connecting to wifi   */
  /* * * * * * * * * * * * * * * * * * * * * * * * */
}

void SoundDevice::WiFi::ReconnectWiFi() {
  /* * * * * * * * * * * * * * * * * * * * * * */
  /* Attempt reconnect if WiFi signal is lost  */
  /* * * * * * * * * * * * * * * * * * * * * * */
}

int main() {
  SoundDevice::Sensor sensor;
  SoundDevice::WiFi wifi;

  return 0;
}
