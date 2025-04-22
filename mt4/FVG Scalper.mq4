#property indicator_chart_window
#property indicator_buffers 5
// Define an enumeration for arrow directions
enum ArrowDirection { UP_ARROW = 0, DOWN_ARROW = 1 };

// Define global variables for arrow properties
color arrowColor = clrRed;
int arrowSize = 50;
int arrowCode = SYMBOL_ARROWUP;


double ExtCloseBuffer[];
double ExtHighBuffer[];
double ExtLowBuffer[];
double dailyclose[];
double dailyhigh[];
double dailylow[];
double dailytime[];
double bullOBup[];
double bullOBdown[];
double bearOBup[];
double bearOBdown[];
datetime expiryTimeArraybull;
datetime expiryTimeArraybear;
int bullltftag;
int bearltftag;
double bullscalpprice;
double bearscalpprice;

int OnInit(void)
  {

//--- 2 additional buffers are used for counting.
   //IndicatorBuffers(5);
   SetIndexStyle(0,DRAW_ARROW);
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexStyle(2,DRAW_ARROW);
   SetIndexStyle(3,DRAW_ARROW);
   SetIndexStyle(4,DRAW_ARROW);
   SetIndexBuffer(0,bullOBup);
   SetIndexBuffer(1,bullOBdown);
   SetIndexBuffer(2,bearOBup);
   SetIndexBuffer(3,bearOBdown);
   SetIndexBuffer(4,ExtCloseBuffer);
  // ArraySetAsSeries(ExtCloseBuffer,false);
  // ArraySetAsSeries(ExtHighBuffer,false);
  // ArraySetAsSeries(ExtLowBuffer,false);
//--- indicator line

//--- name for DataWindow and indicator subwindow label
 
  // SetIndexDrawBegin(0,InpRSIPeriod);
//--- initialization done
   return(INIT_SUCCEEDED);
  }

int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])


{
   datetime now = TimeCurrent();
    // Loop through the historical data to identify the end of each trading day
    datetime currentDay = 0;
    datetime lastCandleTime = 0;
    datetime currentDate = 0;
    double HighBuffer = 0;
    double LowBuffer = 1000000;
  //  for (int j = 0; j < rates_total; j++)
  //  {
    
  //   ExtCloseBuffer[j] = iHigh(NULL,0,j);
    
   // }
 
    for (int j = rates_total-2; j > 1; j--)
    {

    if((iLow(NULL,0,j) > iHigh(NULL,0,j+2)) && (iClose(NULL,0,j+1)>iHigh(NULL,0,j+2)))
    {
    bullOBup[j+2] = iLow(NULL,0,j);
    bullOBdown[j+2] =iHigh(NULL,0,j+2);
    }
    
    if((iHigh(NULL,0,j) < iLow(NULL,0,j+2)) && (iClose(NULL,0,j+1) < iLow(NULL,0,j+2)))
    {
    bearOBup[j+2] =iLow(NULL,0,j+2);
    bearOBdown[j+2] =iHigh(NULL,0,j);
    }    
       
    }

    for (int i = 0; i < rates_total; i++)
    {
    if ( bearOBup[i] >0)
    {
    double tempup = bearOBup[i];
    double tempdown = bearOBdown[i];
    for (int  h = 1; h<i-2; h++)
    {
    if ((iClose(NULL,0,h)>tempup) || (iHigh(NULL,0,h)>tempup) || (iLow(NULL,0,h)>tempup) || (iOpen(NULL,0,h)>tempup))
    {
    bearOBup[i] =0;
    bearOBdown[i] =0;
    }
    }
    }
    
    if ( bullOBup[i] >0)
    {
    double temp2up = bullOBup[i];
    double temp2down = bullOBdown[i];
    for (int  g = 1; g<i-2; g++)
    {
    if ((iClose(NULL,0,g)<temp2down) || (iHigh(NULL,0,g)< temp2down) || (iLow(NULL,0,g)<temp2down) || (iOpen(NULL,0,g)<temp2down))
    {
    bullOBup[i] =0;
    bullOBdown[i] =0;
    }
    }
    }
    
    }
    
    for (int f = 0; f < rates_total; f++)
    {
    if (((iClose(NULL,0,0)< bearOBup[f]) &&(iClose(NULL,0,0)> bearOBdown[f])))
    {
    if (now > expiryTimeArraybear)
    {
    string alertMessage = Symbol()+", "+ Period() + ": Price into Bear FVG";
    //Alert(alertMessage);
    //SendNotification(alertMessage);
    expiryTimeArraybear = now + 1 * 60; // Convert minutes to seconds
    bearltftag = 1;
    
    
    }
    }
    
    
    if (((iClose(NULL,0,0)< bullOBup[f]) &&(iClose(NULL,0,0)> bullOBdown[f])))
    {
    if (now > expiryTimeArraybull)
    {
    string alertMessage1 = Symbol() +", "+ Period()+ ": Price into Bull FVG";
    //Alert(alertMessage1);
    //SendNotification(alertMessage1);
    expiryTimeArraybull = now + 1 * 60; // Convert minutes to seconds
    bullltftag = 1;
    }
    }
    
    
    if (bearltftag==1)
    {
    
    if((iHigh(NULL,PERIOD_M1,1) < iLow(NULL,PERIOD_M1,3)) && (iClose(NULL,PERIOD_M1,2) < iLow(NULL,PERIOD_M1,3)))
    {
    string alertMessage2 = Symbol() + ": Accurate SHORT Entry at 1M";
    Alert(alertMessage2);
    SendNotification(alertMessage2);
    bearltftag=0;
    }
    }
    
    if (bullltftag==1)
    {
    
    if((iLow(NULL,PERIOD_M1,1) > iHigh(NULL,PERIOD_M1,3)) && (iClose(NULL,PERIOD_M1,2)>iHigh(NULL,PERIOD_M1,3)))
    {
    
    string alertMessage3 = Symbol() + ": Accurate LONG Entry at 1M";
    Alert(alertMessage3);
    SendNotification(alertMessage3);
    bullltftag=0;
    }    
    
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    }






    return rates_total;
}


