/**
  Title: Noise_detector_device
  Author: Ryan Persons
  Date: 3/10/21
  Last modified: 5/16/21
  Description: Collect and post from 0 - 10 Volume data to the "Hush" server
*/

#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>

int arraySize = 1000;

void setup() {
  Serial.begin(9600);
  Serial << "start";
	WifiInit();
	ADCInit();
}

void loop() {
 // Serial.println("start");
  String deviceID = "DEVICE_NAME_HERE";
	int totalVolume = 0;
	int volumeValues[1000] = {};
  int timer = millis();
  int n = 0;

  //Sample data
  // collect data for 1 minite
  Serial << "                 ";
  while( millis() < (timer + 1000) ){
    for(int i = 0;i < arraySize; i++){
      volumeValues[i] = SampleData();
      //Serial << volumeValues[i];
    }
  	totalVolume += CalcRMS(arraySize, volumeValues);
    n++;
    
  Serial << '\n' << "RMS index: " << CalcRMS(arraySize, volumeValues) << "     ";
  }
  Serial << '\n' << "Real totalVolume: " << totalVolume << '\n';
  totalVolume = totalVolume/n;
  
  Serial << "Avg Value:    " << totalVolume << '\n';
  Serial << "Post:    " << '\n';
	PostVolume(deviceID,totalVolume);

  Serial << "end" << '\n'<< '\n';
}
