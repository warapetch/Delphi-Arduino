// Init variables
bool bLedState = false;
bool bMyCase = false;
String sVal = "";
int relay01 = 12;

// Setup function
void setup() {

  // Init serial interface
  // ตั้งค่า Comport / Serial port
  Serial.begin(9600); // BaudRate == 9600

  // Set pin mode
  pinMode(relay01, OUTPUT);

  // Print ready command to serial
  Serial.print("READY\n");
}

void loop() {

  // Check if we can read data from serial
  if(Serial.available() > 0) {
    
    // Read data from serial 
    // Serial.read() ==> int
    // Serial.readString() ==> String
    sVal = Serial.readString();
    
    // Compare if not empty
    // ถ้าค่าที่ส่งเข้ามา ไม่เป็นช่องว่าง
    if(sVal != "") {
      // Monitor income Text ตรวจสอบค่าที่รับมา
      // Serial.print("RX = "+sVal+"\n");

      if(sVal == "INIT") {
        // Send connect string
        Serial.print("READY\n");
      } else {
        
        // Execute command
        OnSerialCommand(sVal);
      }
      
      // Reset variable
      sVal = "";
    }
  }
}

void OnSerialCommand(String cmd) {
  bMyCase = false;
  // Check recived value
  if(cmd == "LED_ON") {
    bMyCase = true;
    // Turn on led
    bLedState = true;
    
  } else if(cmd == "LED_OFF") {
    // Turn off led
    bMyCase = true;
    bLedState = false;
  }
  

  if (bMyCase)  {

    // Check led state 
    // ถ้าสั่งเปิดไฟ  bLedState == True
    if(bLedState)  {
      // Turn on led
      digitalWrite(relay01, HIGH);
      // Send successful answer
      Serial.print("LED_ON = OK\n");
    } else {
      // Turn off led
      digitalWrite(relay01, LOW);
      // Send successful answer
      Serial.print("LED_OFF = OK\n");
    }
  }
  
}