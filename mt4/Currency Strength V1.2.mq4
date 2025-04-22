//+------------------------------------------------------------------+
//|                              Kaufman Adaptive Moving Average.mq4 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+

//v1.0 - version that works
//v1.1 +jpy
//v1.2 functionality to notify if lower than 32 and 68.

#property indicator_separate_window

#property indicator_buffers 8
#property indicator_minimum    0
#property indicator_maximum    100
#property indicator_level1     32.0
#property indicator_level2     68.0
#property indicator_levelcolor clrSilver
#property indicator_levelstyle STYLE_DOT



//---- input parameters 
input int InpRSIPeriod=7; // RSI Period
input bool AlertM = True;

//---- buffers 
double kAMAbuffer[]; 

double dSC,slowSC,fastSC; 
double noise,signal,ER; 
double ERSC,SSC,Price; 
bool fc;

double ExtLowHighBuffer[];
double ExtHighLowBuffer[];
double ExtOpenBuffer[];
double ExtCloseBuffer[];
int countedBars;

double EMABuffer[];
double EMABuffer1[];

double ExtUpFractalsBuffer[];
double ExtDownFractalsBuffer[];

double ExtRSIBuffer[];
double ExtRSIBufferSMA[];

double ExtRSIUpFractalsBuffer[];
double ExtRSIDownFractalsBuffer[];

double ExtTotalScore[];

datetime expiryTimeArraybearEUR;
datetime expiryTimeArraybullEUR;
datetime expiryTimeArraybearUSD;
datetime expiryTimeArraybullUSD;
datetime expiryTimeArraybearCHF;
datetime expiryTimeArraybullCHF;
datetime expiryTimeArraybearGBP;
datetime expiryTimeArraybullGBP;
datetime expiryTimeArraybearAUD;
datetime expiryTimeArraybullAUD;
datetime expiryTimeArraybearNZD;
datetime expiryTimeArraybullNZD;
datetime expiryTimeArraybearJPY;
datetime expiryTimeArraybullJPY;
datetime expiryTimeArraybearCAD;
datetime expiryTimeArraybullCAD;


string showvalue1;
string showvalue2;
string objectkama;

double ExtStrengthEUR[];
double ExtStrengthUSD[];
double ExtStrengthGBP[];
double ExtStrengthAUD[];
double ExtStrengthNZD[];
double ExtStrengthCHF[];
double ExtStrengthCAD[];
double ExtStrengthJPY[];
//+------------------------------------------------------------------+ 
//| Custom indicator initialization function | 
//+------------------------------------------------------------------+ 
int init() { 
   //---- indicators 
   

   IndicatorShortName("Limao Currency Strength("+IntegerToString(InpRSIPeriod)+")");
   IndicatorBuffers(14);
   
/*   
   SetIndexBuffer(0,kAMAbuffer); 
   SetIndexStyle(0,DRAW_NONE); 
   SetIndexLabel(0,"KAMA Buffer");
   SetIndexDrawBegin(0,periodAMA);

   SetIndexStyle(1, DRAW_NONE, 0, 1, ExtColor1);
   SetIndexBuffer(1, ExtLowHighBuffer);
   SetIndexStyle(2, DRAW_NONE, 0, 1, ExtColor2);
   SetIndexBuffer(2, ExtHighLowBuffer);
   SetIndexStyle(3, DRAW_NONE, 0, 3, ExtColor3);
   SetIndexBuffer(3, ExtOpenBuffer);
   SetIndexStyle(4, DRAW_NONE, 0, 3, ExtColor4);
   SetIndexBuffer(4, ExtCloseBuffer);

   SetIndexLabel(1, "Low/High");
   SetIndexLabel(2, "High/Low");
   SetIndexLabel(3, "Open");
   SetIndexLabel(4, "Close");

   SetIndexDrawBegin(1, 10);
   SetIndexDrawBegin(2, 10);
   SetIndexDrawBegin(3, 10);
   SetIndexDrawBegin(4, 10);

   SetIndexBuffer(5, EMABuffer);
   SetIndexStyle(5, DRAW_NONE, 0, 2, ExtColor3);
   SetIndexLabel(5, "KAMA");   
   SetIndexBuffer(6, EMABuffer1);
   SetIndexStyle(6, DRAW_NONE, 0, 2, ExtColor4);
   SetIndexLabel(6, "KAMA EMA");      

   SetIndexBuffer(7,ExtUpFractalsBuffer);
   SetIndexBuffer(8,ExtDownFractalsBuffer);   

   SetIndexStyle(7,DRAW_LINE, 0, 2, ExtColor6);
   SetIndexArrow(7,119);
   SetIndexStyle(8,DRAW_LINE, 0, 2, ExtColor3);
   SetIndexArrow(8,119);

   SetIndexEmptyValue(7,0.0);
   SetIndexEmptyValue(8,0.0);

   SetIndexLabel(7,"KAMA Up");
   SetIndexLabel(8,"KAMA Down");
*/


   SetIndexBuffer(0, ExtStrengthEUR); 
   SetIndexStyle(0,DRAW_LINE, 0, 2, clrDarkBlue); 
   SetIndexDrawBegin(0,InpRSIPeriod);
   SetIndexBuffer(1, ExtStrengthUSD); 
   SetIndexStyle(1,DRAW_LINE, 0, 2, clrCrimson); 
   SetIndexDrawBegin(1,InpRSIPeriod);
   SetIndexBuffer(2, ExtStrengthGBP); 
   SetIndexStyle(2,DRAW_LINE, 0, 2, clrLightSkyBlue); 
   SetIndexDrawBegin(2,InpRSIPeriod);
   SetIndexBuffer(3,ExtStrengthAUD); 
   SetIndexStyle(3,DRAW_LINE, 0, 2, clrDarkGreen); 
   SetIndexDrawBegin(3,InpRSIPeriod);
   SetIndexBuffer(4,ExtStrengthNZD); 
   SetIndexStyle(4,DRAW_LINE, 0, 2, clrLightGreen); 
   SetIndexDrawBegin(4,InpRSIPeriod);
   SetIndexBuffer(5,ExtStrengthCHF); 
   SetIndexStyle(5,DRAW_LINE, 0, 2, clrWhite); 
   SetIndexDrawBegin(5,InpRSIPeriod);
   SetIndexBuffer(6,ExtStrengthCAD); 
   SetIndexStyle(6,DRAW_LINE, 0, 2, clrOrange); 
   SetIndexDrawBegin(6,InpRSIPeriod);
   SetIndexBuffer(7,ExtStrengthJPY); 
   SetIndexStyle(7,DRAW_LINE, 0, 2, clrYellow); 
   SetIndexDrawBegin(7,InpRSIPeriod);   



      
   IndicatorDigits(Digits-1);
   

   dSC=(fastSC-slowSC); 
   fc=true;
   //---- 
   
     
   if(InpRSIPeriod<2)
     {
      Print("Incorrect value for input variable InpRSIPeriod = ",InpRSIPeriod);
      return(INIT_FAILED);
     }
//---
   SetIndexDrawBegin(0,InpRSIPeriod+10);
//--- initialization done
   return(INIT_SUCCEEDED);
   
   
   return(0); 
} 
//+------------------------------------------------------------------+ 
//| Custom indicator deinitialization function | 
//+------------------------------------------------------------------+ 
int deinit() { 
   return(0); 
} 
//+------------------------------------------------------------------+ 
//| Custom indicator iteration function | 
//+------------------------------------------------------------------+ 
int start() { 
 datetime now = TimeCurrent();
   int limit, pos=1, countedbars=IndicatorCounted();


 
   if (Bars<=10 ||Bars <=InpRSIPeriod) return(0); 
   if(countedbars<0) return(-1);
   if (countedbars>0) countedbars--;
   if (fc==true) {
      limit=(Bars-InpRSIPeriod-countedbars);
      
   }
   else limit=Bars-countedbars;
   
     // Determine the starting point

limit=100;
    // Calculation loop
  

    for (pos=limit-1; pos>=0; pos--){ 
    
ExtStrengthEUR[pos] = (iRSI("EURUSD",0,InpRSIPeriod,PRICE_CLOSE,pos)
+iRSI("EURGBP",0,InpRSIPeriod,PRICE_CLOSE,pos)
+iRSI("EURAUD",0,InpRSIPeriod,PRICE_CLOSE,pos)
+iRSI("EURCHF",0,InpRSIPeriod,PRICE_CLOSE,pos)
+iRSI("EURCAD",0,InpRSIPeriod,PRICE_CLOSE,pos)
+iRSI("EURNZD",0,InpRSIPeriod,PRICE_CLOSE,pos)
+iRSI("EURJPY",0,InpRSIPeriod,PRICE_CLOSE,pos))/7;

ExtStrengthUSD[pos] = ((100-iRSI("AUDUSD",0,InpRSIPeriod,PRICE_CLOSE,pos))
+(100-iRSI("GBPUSD",0,InpRSIPeriod,PRICE_CLOSE,pos))
+(100-iRSI("EURUSD",0,InpRSIPeriod,PRICE_CLOSE,pos))
+iRSI("USDCHF",0,InpRSIPeriod,PRICE_CLOSE,pos)
+iRSI("USDCAD",0,InpRSIPeriod,PRICE_CLOSE,pos)
+iRSI("USDJPY",0,InpRSIPeriod,PRICE_CLOSE,pos)
+(100-iRSI("NZDUSD",0,InpRSIPeriod,PRICE_CLOSE,pos)))/7;

ExtStrengthGBP[pos] = (iRSI("GBPUSD",0,InpRSIPeriod,PRICE_CLOSE,pos)
+iRSI("GBPCHF",0,InpRSIPeriod,PRICE_CLOSE,pos)
+iRSI("GBPCAD",0,InpRSIPeriod,PRICE_CLOSE,pos)
+iRSI("GBPAUD",0,InpRSIPeriod,PRICE_CLOSE,pos)
+iRSI("GBPJPY",0,InpRSIPeriod,PRICE_CLOSE,pos)
+iRSI("GBPNZD",0,InpRSIPeriod,PRICE_CLOSE,pos)
+(100-iRSI("EURGBP",0,InpRSIPeriod,PRICE_CLOSE,pos)))/7;

ExtStrengthAUD[pos] = ((100-iRSI("EURAUD",0,InpRSIPeriod,PRICE_CLOSE,pos))
+iRSI("AUDUSD",0,InpRSIPeriod,PRICE_CLOSE,pos)
+(100-iRSI("GBPAUD",0,InpRSIPeriod,PRICE_CLOSE,pos))
+iRSI("AUDNZD",0,InpRSIPeriod,PRICE_CLOSE,pos)
+iRSI("AUDCHF",0,InpRSIPeriod,PRICE_CLOSE,pos)
+iRSI("AUDJPY",0,InpRSIPeriod,PRICE_CLOSE,pos)
+iRSI("AUDCAD",0,InpRSIPeriod,PRICE_CLOSE,pos))/7;

ExtStrengthNZD[pos] = ((100-iRSI("AUDNZD",0,InpRSIPeriod,PRICE_CLOSE,pos))
+(100-iRSI("GBPNZD",0,InpRSIPeriod,PRICE_CLOSE,pos))
+iRSI("NZDUSD",0,InpRSIPeriod,PRICE_CLOSE,pos)
+(100-iRSI("EURNZD",0,InpRSIPeriod,PRICE_CLOSE,pos))
+iRSI("NZDCHF",0,InpRSIPeriod,PRICE_CLOSE,pos)
+iRSI("NZDJPY",0,InpRSIPeriod,PRICE_CLOSE,pos)
+iRSI("NZDCAD",0,InpRSIPeriod,PRICE_CLOSE,pos))/7;

ExtStrengthCHF[pos] = ((100-iRSI("EURCHF",0,InpRSIPeriod,PRICE_CLOSE,pos))
+(100-iRSI("NZDCHF",0,InpRSIPeriod,PRICE_CLOSE,pos))
+(100-iRSI("AUDCHF",0,InpRSIPeriod,PRICE_CLOSE,pos))
+(100-iRSI("GBPCHF",0,InpRSIPeriod,PRICE_CLOSE,pos))
+(100-iRSI("USDCHF",0,InpRSIPeriod,PRICE_CLOSE,pos))
+iRSI("CHFJPY",0,InpRSIPeriod,PRICE_CLOSE,pos)
+(100-iRSI("CADCHF",0,InpRSIPeriod,PRICE_CLOSE,pos)))/7;

ExtStrengthCAD[pos] = (iRSI("CADCHF",0,InpRSIPeriod,PRICE_CLOSE,pos)
+(100-iRSI("NZDCAD",0,InpRSIPeriod,PRICE_CLOSE,pos))
+(100-iRSI("AUDCAD",0,InpRSIPeriod,PRICE_CLOSE,pos))
+(100-iRSI("GBPCAD",0,InpRSIPeriod,PRICE_CLOSE,pos))
+(100-iRSI("USDCAD",0,InpRSIPeriod,PRICE_CLOSE,pos))
+iRSI("CADJPY",0,InpRSIPeriod,PRICE_CLOSE,pos)
+(100-iRSI("EURCAD",0,InpRSIPeriod,PRICE_CLOSE,pos)))/7;

ExtStrengthJPY[pos] = ((100-iRSI("EURJPY",0,InpRSIPeriod,PRICE_CLOSE,pos))
+(100-iRSI("USDJPY",0,InpRSIPeriod,PRICE_CLOSE,pos))
+(100-iRSI("GBPJPY",0,InpRSIPeriod,PRICE_CLOSE,pos))
+(100-iRSI("CHFJPY",0,InpRSIPeriod,PRICE_CLOSE,pos))
+(100-iRSI("CADJPY",0,InpRSIPeriod,PRICE_CLOSE,pos))
+(100-iRSI("AUDJPY",0,InpRSIPeriod,PRICE_CLOSE,pos))
+(100-iRSI("NZDJPY",0,InpRSIPeriod,PRICE_CLOSE,pos)))/7;





















      fc=false;
   } 
  
   
        /*   
   
   objectkama = "KAMA Indis";
    ObjectCreate(0, objectkama, OBJ_LABEL, 0, 0, 0);


    ObjectSetText(objectkama, showvalue1, 30, "Arial", Red);

    // Position the text at the top-right corner
    int xOffset = 150; // Distance from the right edge
    int yOffset = 10; // Distance from the top edge
    ObjectSetInteger(0, objectkama, OBJPROP_CORNER, CORNER_RIGHT_UPPER); // Top-right corner
    ObjectSetInteger(0, objectkama, OBJPROP_XDISTANCE, xOffset);
    ObjectSetInteger(0, objectkama, OBJPROP_YDISTANCE, yOffset);



ExtStrengthEUR[1] 
ExtStrengthUSD[1] 
ExtStrengthGBP[1] 
ExtStrengthCHF[1] 
ExtStrengthCAD[1] 
ExtStrengthAUD[1] 
ExtStrengthNZD[1] 



*/

      
      if (ExtStrengthEUR[1]< 32  && ExtStrengthEUR[2] >= 32 && now > expiryTimeArraybearEUR && AlertM)
      {
      string alertMessageEURBear = "EUR Strength: Bullish";
      Alert(alertMessageEURBear);
      SendNotification(alertMessageEURBear);
      SendMail(alertMessageEURBear,alertMessageEURBear);
      expiryTimeArraybearEUR = now + 3600; // 1 means 1 second
      }

      if (ExtStrengthEUR[1] > 68  && ExtStrengthEUR[2] <= 68 && now > expiryTimeArraybullEUR && AlertM)
      {
      string alertMessageEURBull = "EUR Strength: Bearish";
      Alert(alertMessageEURBull);
      SendNotification(alertMessageEURBull);
      SendMail(alertMessageEURBull,alertMessageEURBull);
      expiryTimeArraybullEUR = now + 3600; // 1 means 1 second
      }

      if (ExtStrengthCHF[1]< 32  && ExtStrengthCHF[2] >= 32 && now > expiryTimeArraybearCHF && AlertM)
      {
      string alertMessageCHFBear = "CHF Strength: Bullish";
      Alert(alertMessageCHFBear);
      SendNotification(alertMessageCHFBear);
      SendMail(alertMessageCHFBear,alertMessageCHFBear);
      expiryTimeArraybearCHF = now + 3600; // 1 means 1 second
      }

      if (ExtStrengthCHF[1] > 68  && ExtStrengthCHF[2] <= 68 && now > expiryTimeArraybullCHF && AlertM)
      {
      string alertMessageCHFBull = "CHF Strength: Bearish";
      Alert(alertMessageCHFBull);
      SendNotification(alertMessageCHFBull);
      SendMail(alertMessageCHFBull,alertMessageCHFBull);
      expiryTimeArraybullCHF = now + 3600; // 1 means 1 second
      }

      if (ExtStrengthGBP[1]< 32  && ExtStrengthGBP[2] >= 32 && now > expiryTimeArraybearGBP && AlertM)
      {
      string alertMessageGBPBear = "GBP Strength: Bullish";
      Alert(alertMessageGBPBear);
      SendNotification(alertMessageGBPBear);
      SendMail(alertMessageGBPBear,alertMessageGBPBear);
      expiryTimeArraybearGBP = now + 3600; // 1 means 1 second
      }

      if (ExtStrengthGBP[1] > 68  && ExtStrengthGBP[2] <= 68 && now > expiryTimeArraybullGBP && AlertM)
      {
      string alertMessageGBPBull = "GBP Strength: Bearish";
      Alert(alertMessageGBPBull);
      SendNotification(alertMessageGBPBull);
      SendMail(alertMessageGBPBull,alertMessageGBPBull);
      expiryTimeArraybullGBP = now + 3600; // 1 means 1 second
      }

      if (ExtStrengthAUD[1]< 32  && ExtStrengthAUD[2] >= 32 && now > expiryTimeArraybearAUD && AlertM)
      {
      string alertMessageAUDBear = "AUD Strength: Bullish";
      Alert(alertMessageAUDBear);
      SendNotification(alertMessageAUDBear);
      SendMail(alertMessageAUDBear,alertMessageAUDBear);
      expiryTimeArraybearAUD = now + 3600; // 1 means 1 second
      }

      if (ExtStrengthAUD[1] > 68  && ExtStrengthAUD[2] <= 68 && now > expiryTimeArraybullAUD && AlertM)
      {
      string alertMessageAUDBull = "AUD Strength: Bearish";
      Alert(alertMessageAUDBull);
      SendNotification(alertMessageAUDBull);
      SendMail(alertMessageAUDBull,alertMessageAUDBull);
      expiryTimeArraybullAUD = now + 3600; // 1 means 1 second
      }

      if (ExtStrengthNZD[1]< 32  && ExtStrengthNZD[2] >= 32 && now > expiryTimeArraybearNZD && AlertM)
      {
      string alertMessageNZDBear = "NZD Strength: Bullish";
      Alert(alertMessageNZDBear);
      SendNotification(alertMessageNZDBear);
      SendMail(alertMessageNZDBear,alertMessageNZDBear);
      expiryTimeArraybearNZD = now + 3600; // 1 means 1 second
      }

      if (ExtStrengthNZD[1] > 68  && ExtStrengthNZD[2] <= 68 && now > expiryTimeArraybullNZD && AlertM)
      {
      string alertMessageNZDBull = "NZD Strength: Bearish";
      Alert(alertMessageNZDBull);
      SendNotification(alertMessageNZDBull);
      SendMail(alertMessageNZDBull,alertMessageNZDBull);
      expiryTimeArraybullNZD = now + 3600; // 1 means 1 second
      }

      if (ExtStrengthJPY[1]< 32  && ExtStrengthJPY[2] >= 32 && now > expiryTimeArraybearJPY && AlertM)
      {
      string alertMessageJPYBear = "JPY Strength: Bullish";
      Alert(alertMessageJPYBear);
      SendNotification(alertMessageJPYBear);
      SendMail(alertMessageJPYBear,alertMessageJPYBear);
      expiryTimeArraybearJPY = now + 3600; // 1 means 1 second
      }

      if (ExtStrengthJPY[1] > 68  && ExtStrengthJPY[2] <= 68 && now > expiryTimeArraybullJPY && AlertM)
      {
      string alertMessageJPYBull = "JPY Strength: Bearish";
      Alert(alertMessageJPYBull);
      SendNotification(alertMessageJPYBull);
      SendMail(alertMessageJPYBull,alertMessageJPYBull);
      expiryTimeArraybullJPY = now + 3600; // 1 means 1 second
      }


      if (ExtStrengthUSD[1]< 32  && ExtStrengthUSD[2] >= 32 && now > expiryTimeArraybearUSD && AlertM)
      {
      string alertMessageUSDBear = "USD Strength: Bullish";
      Alert(alertMessageUSDBear);
      SendNotification(alertMessageUSDBear);
      SendMail(alertMessageUSDBear,alertMessageUSDBear);
      expiryTimeArraybearUSD = now + 3600; // 1 means 1 second
      }

      if (ExtStrengthUSD[1] > 68  && ExtStrengthUSD[2] <= 68 && now > expiryTimeArraybullUSD && AlertM)
      {
      string alertMessageUSDBull = "USD Strength: Bearish";
      Alert(alertMessageUSDBull);
      SendNotification(alertMessageUSDBull);
      SendMail(alertMessageUSDBull,alertMessageUSDBull);
      expiryTimeArraybullUSD = now + 3600; // 1 means 1 second
      }

      if (ExtStrengthCAD[1]< 32  && ExtStrengthCAD[2] >= 32 && now > expiryTimeArraybearCAD && AlertM)
      {
      string alertMessageCADBear = "CAD Strength: Bullish";
      Alert(alertMessageCADBear);
      SendNotification(alertMessageCADBear);
      SendMail(alertMessageCADBear,alertMessageCADBear);
      expiryTimeArraybearCAD = now + 3600; // 1 means 1 second
      }

      if (ExtStrengthCAD[1] > 68  && ExtStrengthCAD[2] <= 68 && now > expiryTimeArraybullCAD && AlertM)
      {
      string alertMessageCADBull = "CAD Strength: Bearish";
      Alert(alertMessageCADBull);
      SendNotification(alertMessageCADBull);
      SendMail(alertMessageCADBull,alertMessageCADBull);
      expiryTimeArraybullCAD = now + 3600; // 1 means 1 second
      }




   return(0); 
} 


