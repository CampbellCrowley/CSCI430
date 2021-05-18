/**
  Title: Wifi_test
  Author: Ryan Persons
  Date: 3/10/21
  Last modified: 5/16/21
  Description: Automatically post test data 0-10 to the "Hush" server
*/

#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>

/* this can be run with an emulated server on host:
        cd esp8266-core-root-dir
        cd tests/host
        make ../../libraries/ESP8266WebServer/examples/PostServer/PostServer
        bin/PostServer/PostServer
   then put your PC's IP address in SERVER_IP below, port 9080 (instead of default 80):
*/
//#define SERVER_IP "" // PC address with emulation on host


String deviceID = "DEVICE_NAME_HERE";  // BlueberryPie RaspberryPie ApplePie
                                       // PumpkinPie PecanPie SugarCreamPie

int arr[10] = {1,2,3,4,5,6,7,8,9,10};

void setup() {
  WifiInit();
}
void loop() {
  for(int i = 0;i < 10;i++){
    PostVolume(deviceID, arr[i]);
    Serial<< "Volume: " << arr[i] << '\n'
          << "deviceID = " << deviceID << '\n';
    delay(5000);
  }
}
