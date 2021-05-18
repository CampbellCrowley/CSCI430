
#define SERVER_IP_UPDATE_DATA "http://hush.campbellcrowley.com/api/update-data"

#ifndef STASSID
#define STASSID "YOUR_WIFI_NAME_HERE"
#define STAPSK  "YOUR_WIFI_PASSWORD_HERE"
#endif

void WifiInit(){
  WiFi.begin(STASSID, STAPSK);
  
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial << '\n' << "Connected! IP address: " 
         << WiFi.localIP() << '\n';
}

void PostVolume(String deviceID, int volume){
    String POSTbody = deviceID + ";" + volume;
    //String POSTbody = "deviceID02;7";
    
  // wait for WiFi connection
  if ((WiFi.status() == WL_CONNECTED)) {

    WiFiClient client;
    HTTPClient http;

    // send data from device
    Serial.println("Update");
    http.begin(client, SERVER_IP_UPDATE_DATA); //HTTP
    http.addHeader("Content-Type", "text/plain");

    // start connection and send HTTP header and body 
    int httpResponseCode = http.POST(POSTbody);
    
    ErrorCheck(http,httpResponseCode);
   http.end();
  }
}

void ErrorCheck(HTTPClient& http, int httpResponseCode){
    // httpCode will be negative on error
    if (httpResponseCode > 0) {
      // HTTP header has been send and Server response header has been handled
      Serial.printf("[HTTP] POST... code: %d\n", httpResponseCode);

      // file found at server
      if (httpResponseCode == HTTP_CODE_OK) {
        const String& payload = http.getString();
        Serial << "received payload:\n<<" << '\n'
               << payload << ">>" << '\n';
      }
    } else {
      Serial.printf("[HTTP] POST... failed, error: %s\n", http.errorToString(httpResponseCode).c_str());
    }
}
