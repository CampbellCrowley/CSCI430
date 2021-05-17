void ErrorCheck(HTTPClient& http, int httpResponseCode){
    // httpCode will be negative on error
    if (httpResponseCode > 0) {
      // HTTP header has been send and Server response header has been handled
      Serial.printf("[HTTP] POST... code: %d\n", httpResponseCode);

      // file found at server
      if (httpResponseCode == HTTP_CODE_OK) {
        const String& payload = http.getString();
        Serial.println("received payload:\n<<");
        Serial.println(payload);
        Serial.println(">>");
      }
    } else {
      Serial.printf("[HTTP] POST... failed, error: %s\n", http.errorToString(httpResponseCode).c_str());
    }
}

//print Serialnl << varble1 << varble2;
template <typename T>
Print& operator<<(Print& printer, T value)
{
  printer.print(value);
  return printer;
}
