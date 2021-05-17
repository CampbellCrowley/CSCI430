// All Math fuctions located here

//do we input any negative voltages?
/**
 * The square root of: (x1^2 + x2^2 + x3^2 ... xn^2) / n
 */
int CalcRMS( int arraySize, int arrayValues[] ){
  int add = 0;
  for (int i=0; i < arraySize; i++) {
    add += arrayValues[i] * arrayValues[i];
    
  }
  return sqrt(add / arraySize);
}

uint32_t CalcAvg( int arraySize, int arrayValues[] ){
  uint32_t total = 0;
  for (int i=0; i < arraySize; i++) {
    total += arrayValues[i];
  }
  return (total / arraySize);
}
