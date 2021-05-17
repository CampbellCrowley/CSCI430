// All Math fuctions located here

//program
int micInput = A0;

void ADCInit() {
  pinMode(micInput, INPUT);
  //analogWriteResolution(10);
}

int SampleData() {
  int data =  analogRead(micInput);     // generateTestValue(); //
  //Serial.println(data);
  return (data/100);
}

/*
int* GetData(){
  int arrayValues[100] = {};
  for(int i = 0;i < arraySize; i++){
    arrayValues[i] = SampleData();
  }
  return arrayValues;
}
*/

//print Serialnl << varble1 << varble2;
template <typename T>
Print& operator<<(Print& printer, T value)
{
  printer.print(value);
  return printer;
}
