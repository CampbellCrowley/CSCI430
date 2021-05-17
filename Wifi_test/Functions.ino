#define SERVER_IP_UPDATE_DATA "http://hush.campbellcrowley.com/api/update-data"

#ifndef STASSID
#define STASSID "BlueBree819"
#define STAPSK  "EKP8191917"
#endif

void WifiInit(){
  Serial.begin(9600);

  WiFi.begin(STASSID, STAPSK);
  
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.print("Connected! IP address: ");
  Serial.println(WiFi.localIP());
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
