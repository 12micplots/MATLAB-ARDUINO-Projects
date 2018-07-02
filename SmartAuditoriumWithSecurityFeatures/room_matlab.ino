#include<LiquidCrystal.h>

LiquidCrystal lcd(13,12,8,A3,10,11);

String I="";
boolean complete=false;
unsigned char LED[8]={7,6,5,4,3,2,A4,A5};
unsigned char L[4]={0,0,0,0};
int i;

void setup() {


  Serial.begin(9600);

  
  for(i=0;i<8;i++)
    {
      pinMode(LED[i],OUTPUT);
      digitalWrite(LED[i],HIGH);
    }
    
  lcd.begin(16,2);
  lcd.setCursor(0,0);
  lcd.print("Matlab");
  lcd.setCursor(0,1);
  lcd.print("  RoomLight  ");
  delay(2000);
  lcd.clear();

  pinMode(9,OUTPUT);
  pinMode(A1,INPUT);
  pinMode(A3,OUTPUT);
  
  I.reserve(10);
  
}

int temp,metal;
int light=0;

void loop() {

    serialData();
    if(complete)
      {
        complete=false;
        for(i=0;i<I.length();i++)
          {
            if(I.charAt(i)=='*')
                {
                  L[0]=I.charAt(i+1)-'0';
                  L[1]=I.charAt(i+2)-'0';
                  L[2]=I.charAt(i+3)-'0';
                  L[3]=I.charAt(i+4)-'0';
                }
          }
        I="";
 

          light=0;
          for(i=0;i<4;i++)
            {
              if(L[i]==0)
                {digitalWrite(LED[(i*2)],HIGH); digitalWrite(LED[(i*2)+1],HIGH); }           
              if(L[i]==1)
                {digitalWrite(LED[(i*2)],LOW); digitalWrite(LED[(i*2)+1],HIGH); }           
              if(L[i]==2)
                {digitalWrite(LED[(i*2)],LOW); digitalWrite(LED[(i*2)+1],LOW); }           

              light=light+L[i];
            }
          light=light*12.5;
      }

 
      
    temp=0;
    for(i=0;i<5;i++)
      { temp=temp+analogRead(A0)*4.887; delay(60); }
    temp=temp/50;
    
    lcd.setCursor(0,0);
    lcd.print("TEMP:");
    lcd.print(temp);

    if(temp<35)
      analogWrite(9,180);
    else if(temp<55)
      analogWrite(9,120);
    else if(temp<65)
      analogWrite(9,70);
    else if(temp<75)
      analogWrite(9,20);
      
    lcd.print(" L:");
    lcd.print(light/100);
    lcd.print((light/10)%10);
    lcd.print(light%10);
    lcd.print("%   ");
    
    lcd.setCursor(0,1);
    if(digitalRead(A1)==LOW)
      lcd.print("Metal Detected");
    else
      lcd.print("              ");

    delay(200);
}

void serialData()
  {
    char inChar;

    while(Serial.available()>0)
      {
        inChar=(char)Serial.read();
        I=I+inChar;
        if(inChar=='#')
            complete=true;
      }
  }

