//+------------------------------------------------------------------+
//|                              Kaufman Adaptive Moving Average.mq4 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+

//v1.0 - version that works
//v1.1 - code optimization
//v1.2 - add rsi
//v1.3 - made a overall buffer to record down total score
//v1.4 - notification system
#property indicator_chart_window
#property indicator_buffers 14
//#property indicator_color1 Red 
//#property indicator_color2 Red
//#property indicator_color3 White
//#property indicator_color4 Red
//#property indicator_color5 White
//#property indicator_color6 Red
//#property indicator_color7 Blue 
//#property indicator_width2 1
//#property indicator_width3 1
//#property indicator_width4 3
//#property indicator_width5 3
//#property indicator_width6 2



//---- input parameters 

input int periodAMA=5; 
input double nfast=2.5; 
input int nslow=20; 
input color ExtColor1 = Red;    // Shadow of bear candlestick
input color ExtColor2 = White;  // Shadow of bull candlestick
input color ExtColor3 = Red;    // Bear candlestick body
input color ExtColor4 = White;  // Bull candlestick body
input color ExtColor5 = Blue;  // Bull candlestick body
input int EMA_Period = 20;  // EMA period
input int InpRSIPeriod = 14;  // RSI Period

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

datetime expiryTimeArraybear;
datetime expiryTimeArraybull;
//+------------------------------------------------------------------+ 
//| Custom indicator initialization function | 
//+------------------------------------------------------------------+ 
int init() { 
   //---- indicators 
   IndicatorShortName("KAMA+RSI");
   IndicatorBuffers(14);
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

   SetIndexStyle(7,DRAW_LINE, 0, 2, ExtColor3);
   SetIndexArrow(7,119);
   SetIndexStyle(8,DRAW_LINE, 0, 2, ExtColor4);
   SetIndexArrow(8,119);

   SetIndexEmptyValue(7,0.0);
   SetIndexEmptyValue(8,0.0);

   SetIndexLabel(7,"KAMA Up");
   SetIndexLabel(8,"KAMA Down");

   SetIndexBuffer(9, ExtRSIBuffer);
   SetIndexStyle(9, DRAW_LINE, 0, 2, ExtColor4);
   SetIndexLabel(9,"RSI");
   
   SetIndexBuffer(10, ExtRSIBufferSMA);
   SetIndexStyle(10, DRAW_LINE, 0, 2, ExtColor4);
   SetIndexLabel(10,"RSISMA");

   SetIndexStyle(11,DRAW_LINE, 0, 2, ExtColor3);
   SetIndexArrow(11,119);
   SetIndexStyle(12,DRAW_LINE, 0, 2, ExtColor4);
   SetIndexArrow(12,119);

   SetIndexEmptyValue(11,0.0);
   SetIndexEmptyValue(12,0.0);

   SetIndexLabel(11,"RSI Up");
   SetIndexLabel(12,"RSI Down");

   SetIndexBuffer(11,ExtRSIUpFractalsBuffer);
   SetIndexBuffer(12,ExtRSIDownFractalsBuffer);   

   SetIndexStyle(13,DRAW_ARROW, 0, 2, ExtColor5);
   SetIndexArrow(13,15);
   SetIndexEmptyValue(13,0.0);
   SetIndexLabel(13,"Scoring");
   SetIndexBuffer(13,ExtTotalScore);    
      
   IndicatorDigits(Digits);
   
   slowSC=(2.0 /(nslow+1)); 
   fastSC=(2.0 /(nfast+1)); 

   dSC=(fastSC-slowSC); 
   fc=true;
   //---- 
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
   int i, limit, pos=1, posA, countedbars=IndicatorCounted();
   double haOpen, haHigh, haLow, haClose;
   double alpha, price1, price2;
   bool   bFoundd, bFoundu;
   bool   cFoundd, cFoundu;
   double avgGain = 0.0, avgLoss = 0.0;
   double k1, r1, t1;
   datetime now = TimeCurrent();

   alpha = 2.0 / (EMA_Period + 1);
   if (Bars<=periodAMA+2 ||Bars<=10 ||Bars <=InpRSIPeriod) return(0); 
   if(countedbars<0) return(-1);
   if (countedbars>0) countedbars--;
   if (fc==true) {
      limit=(Bars-periodAMA-countedbars);
      kAMAbuffer[limit+1]=(High[limit+1]+Low[limit+1]+Close[limit+1])/3;
   }
   else limit=Bars-countedbars;
   
     // Determine the starting point
    if (countedBars > 0) {
        posA = Bars - countedBars;
    } else {
        posA = Bars - 1;

        // Initialize the first bar
        if (Open[posA] < Close[posA]) {
            ExtLowHighBuffer[posA] = Low[posA];
            ExtHighLowBuffer[posA] = High[posA];
        } else {
            ExtLowHighBuffer[posA] = High[posA];
            ExtHighLowBuffer[posA] = Low[posA];
        }

        ExtOpenBuffer[posA] = Open[posA];
        ExtCloseBuffer[posA] = Close[posA];
    }

    // Calculation loop
    for (i = posA - 1; i >= 0; i--) {
        // Heiken Ashi calculations
        haOpen = (ExtOpenBuffer[i + 1] + ExtCloseBuffer[i + 1]) / 2;
        haClose = (Open[i] + High[i] + Low[i] + Close[i]) / 4;
        haHigh = MathMax(High[i], MathMax(haOpen, haClose));
        haLow = MathMin(Low[i], MathMin(haOpen, haClose));

        // Assign values to buffers based on candlestick direction
        if (haOpen < haClose) {
            ExtLowHighBuffer[i] = haLow;
            ExtHighLowBuffer[i] = haHigh;
        } else {
            ExtLowHighBuffer[i] = haHigh;
            ExtHighLowBuffer[i] = haLow;
        }

        ExtOpenBuffer[i] = haOpen;
        ExtCloseBuffer[i] = haClose;
    }

    for (pos=limit-1; pos>=0; pos--){ 
    
      signal=MathAbs(((ExtHighLowBuffer[pos]+ExtLowHighBuffer[pos]+ExtCloseBuffer[pos])/3)-((ExtHighLowBuffer[pos+periodAMA]+ExtLowHighBuffer[pos+periodAMA]+ExtCloseBuffer[pos+periodAMA])/3)); 
      noise=0; 
      for(i=0;i<periodAMA;i++) { 
         noise=noise+MathAbs(((ExtHighLowBuffer[pos+i]+ExtLowHighBuffer[pos+i]+ExtCloseBuffer[pos+i])/3)-((ExtHighLowBuffer[pos+i+1]+ExtLowHighBuffer[pos+i+1]+ExtCloseBuffer[pos+i+1])/3)); 
      } 
      if (noise!=0) ER =signal/noise; //Efficiency Ratio
      ERSC=ER*dSC; 
      SSC=ERSC+slowSC;
      SSC=MathPow(SSC,2); //Smoothing Factor
      Price=(ExtHighLowBuffer[pos]+ExtLowHighBuffer[pos]+ExtCloseBuffer[pos])/3; //Price Median
      kAMAbuffer[pos]=kAMAbuffer[pos+1]+SSC*(Price-kAMAbuffer[pos+1]);
      price1 = kAMAbuffer[pos]; // Close price, or change to your preference
      price2 = (High[pos]+Low[pos]+Close[pos])/3;
      if (pos == Bars - 1) {
            // First value is just the price itself
            EMABuffer[pos] = price1;
            EMABuffer1[pos] = price2;
        } else {
            // EMA(t) = alpha * Price(t) + (1 - alpha) * EMA(t-1)
            EMABuffer[pos] = alpha * price1 + (1 - alpha) * EMABuffer[pos + 1];
            EMABuffer1[pos] =  price2;
        }
      //plot something
      bFoundd = false;
 //   if( EMABuffer[pos+2] > EMABuffer1[pos+2] && EMABuffer[pos+1] < EMABuffer1[pos+1])
      if( EMABuffer[pos+1] < EMABuffer1[pos+1])
        {
         bFoundd = true;
         ExtUpFractalsBuffer[pos+1]=Low[pos+1];
         k1 = 1;
        }
      bFoundu = false;
 //     if( EMABuffer[pos+2] < EMABuffer1[pos+2] && EMABuffer[pos+1] > EMABuffer1[pos+1])
      if( EMABuffer[pos+1] > EMABuffer1[pos+1])
        {
         bFoundu = true;
         ExtDownFractalsBuffer[pos+1]=High[pos+1];
         k1 = -1;
        }

        ExtRSIBuffer[pos]=iRSI(NULL,0,InpRSIPeriod,PRICE_CLOSE,pos);
        
     
        double sum = 0.0;
        for (int m = 0; m < InpRSIPeriod; m++)
        {
            sum += ExtRSIBuffer[pos + m];
        }
        ExtRSIBufferSMA[pos] = sum / InpRSIPeriod; 


      cFoundd = false;
 //     if( ExtRSIBuffer[pos+2] > ExtRSIBufferSMA[pos+2] && ExtRSIBuffer[pos+1] < ExtRSIBufferSMA[pos+1])
      if(ExtRSIBuffer[pos+1] < ExtRSIBufferSMA[pos+1])
        {
         cFoundd = true;
         ExtRSIDownFractalsBuffer[pos+1]=High[pos+1]*1.01;
         r1=-1;
        }
      cFoundu = false;
 //     if( ExtRSIBuffer[pos+2] < ExtRSIBufferSMA[pos+2] && ExtRSIBuffer[pos+1] > ExtRSIBufferSMA[pos+1])
      if( ExtRSIBuffer[pos+1] > ExtRSIBufferSMA[pos+1])
        {
         cFoundu = true;
         ExtRSIUpFractalsBuffer[pos+1]=Low[pos+1]*0.99;
         r1=1;
        }
        
      t1=k1+r1;
      if (ExtRSIDownFractalsBuffer[pos+1]==High[pos+1]*1.01 && ExtDownFractalsBuffer[pos+1]==High[pos+1] )
      {
      ExtTotalScore[pos+1]=High[pos+1];
      }
      else 
      {
      if (ExtRSIUpFractalsBuffer[pos+1]==Low[pos+1]*0.99 &&   ExtUpFractalsBuffer[pos+1]==Low[pos+1])
      {
      ExtTotalScore[pos+1]=Low[pos+1];
      }
      else 
      {
      ExtTotalScore[pos+1]=-0.1;      
      }
      }
      
      if (ExtTotalScore[1]==High[1] && Close[0] > High[1]&& now > expiryTimeArraybear)
      {
      string alertMessage = Symbol() + ": Bearish, Close above previous high";
      Alert(alertMessage);
      SendNotification(alertMessage);
      expiryTimeArraybear = now + 3600; // 1 means 1 second
      }

      if (ExtTotalScore[1]==Low[1] && Close[0] < Low[1]&& now > expiryTimeArraybull)
      {
      string alertMessage1 = Symbol() + ": Bullish, Close below previous low";
      Alert(alertMessage1);
      SendNotification(alertMessage1);
      expiryTimeArraybull = now + 3600; // 1 means 1 second
      }



//    string alertMessage3 = Symbol() + ": The Bull chance has come (OB)";








      fc=false;
   } 
   return(0); 
} 


