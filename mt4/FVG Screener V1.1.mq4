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
datetime expiryTimeArray;

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
    for (int  h = 0; h<i-2; h++)
    {
    if (iClose(NULL,0,h)>tempup)
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
    for (int  g = 0; g<i-2; g++)
    {
    if (iClose(NULL,0,g)<temp2down)
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
    if (now > expiryTimeArray)
    {
    string alertMessage = Symbol() + ": Price into Bear FVG";
    Alert(alertMessage);
    SendNotification(alertMessage);
    expiryTimeArray = now + 240 * 60; // Convert minutes to seconds
    }
    }
    
    
    if (((iClose(NULL,0,0)< bullOBup[f]) &&(iClose(NULL,0,0)> bullOBdown[f])))
    {
    if (now > expiryTimeArray)
    {
    string alertMessage1 = Symbol() + ": Price into Bull FVG";
    Alert(alertMessage1);
    SendNotification(alertMessage1);
    expiryTimeArray = now + 240 * 60; // Convert minutes to seconds
    }
    }
    
    
        
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    }






    return rates_total;
}


