#property indicator_chart_window
#property indicator_buffers 7
// Define an enumeration for arrow directions
enum ArrowDirection { UP_ARROW = 0, DOWN_ARROW = 1 };

// Define global variables for arrow properties
color arrowColor = clrRed;
int arrowSize = 50;
int arrowCode = SYMBOL_ARROWUP;


double ExtCloseBuffer[];


double bullOBup[];
double bullOBdown[];
double bearOBup[];
double bearOBdown[];
datetime expiryTimeArraybull;
datetime expiryTimeArraybear;
int bullltftag;
int bearltftag;
int bulllltftag;
int bearlltftag;
int bullllltftag;
int bearllltftag;
double bulldobup;
double bulldobdown;
double beardobup;
double beardobdown;
double bullonehobup;
double bullonehobdown;
double bearonehobup;
double bearonehobdown;
double bullfivemobup;
double bullfivemobdown;
double bearfivemobup;
double bearfivemobdown;
double bullfivemlastob;
double bearfivemlastob;

double bullOBBup[];
double bullOBBdown[];
double bearOBBup[];
double bearOBBdown[];
double bullFVGup[];
double bullFVGdown[];
double bearFVGup[];
double bearFVGdown[];

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
 
    //Locate all Daily FVG+OB
    for (int j = rates_total-2; j > 1; j--)
    {

    if((iLow(NULL,PERIOD_D1,j) > iHigh(NULL,PERIOD_D1,j+2)) && (iClose(NULL,PERIOD_D1,j+1)>iHigh(NULL,PERIOD_D1,j+2)))
    {
    bullOBup[j+2] = iLow(NULL,PERIOD_D1,j);
    bullOBdown[j+2] =iLow(NULL,PERIOD_D1,j+2);
    //20240725: newly add OB&FVG
    bullOBBup[j+2] = iHigh(NULL,PERIOD_D1,j+2);
    bullOBBdown[j+2] =iLow(NULL,PERIOD_D1,j+2);
    
    bullFVGup[j+2] = iLow(NULL,PERIOD_D1,j);
    bullFVGdown[j+2] =iHigh(NULL,PERIOD_D1,j+2);
    }
    
    if((iHigh(NULL,PERIOD_D1,j) < iLow(NULL,PERIOD_D1,j+2)) && (iClose(NULL,PERIOD_D1,j+1) < iLow(NULL,PERIOD_D1,j+2)))
    {
    bearOBup[j+2] =iHigh(NULL,PERIOD_D1,j+2);
    bearOBdown[j+2] =iHigh(NULL,PERIOD_D1,j);
    //20240725: newly add OB&FVG
    bearOBBup[j+2] = iHigh(NULL,PERIOD_D1,j+2);
    bearOBBdown[j+2] =iLow(NULL,PERIOD_D1,j+2);
    
    bearFVGup[j+2] = iLow(NULL,PERIOD_D1,j+2);
    bearFVGdown[j+2] =iHigh(NULL,PERIOD_D1,j); 
    }    
       
    }
    
    //Remove all mitigated FVG+OB
    for (int i = 0; i < rates_total; i++)
    {
    if ( bearOBup[i] >0)
    {
    double tempup = bearFVGup[i];
    double tempdown = bearOBdown[i];
    for (int  h = 1; h<i-2; h++) //plotting h=1 here is very important which it doesn't include current candle
    {
    if ((iClose(NULL,PERIOD_D1,h)>tempdown) || (iHigh(NULL,PERIOD_D1,h)>tempdown) || (iLow(NULL,PERIOD_D1,h)>tempdown) || (iOpen(NULL,PERIOD_D1,h)>tempdown))
    {
    bearOBup[i] =0;
    bearOBdown[i] =0;
    bearFVGup[i] =0;
    bearFVGdown[i] =0;
    }
    if ((iClose(NULL,PERIOD_D1,h)>tempup) || (iHigh(NULL,PERIOD_D1,h)>tempup) || (iLow(NULL,PERIOD_D1,h)>tempup) || (iOpen(NULL,PERIOD_D1,h)>tempup))
    {
    bearOBBup[i] =0;
    bearOBBdown[i] =0;
    }    
    
    
    
    
    }
    }
    
    if ( bullOBup[i] >0)
    {
    double temp2up = bullOBup[i];
    double temp2down = bullFVGdown[i];
    for (int  g = 1; g<i-2; g++) //plotting g=1 here is very important which it doesn't include current candle
    {
    if ((iClose(NULL,PERIOD_D1,g)<temp2up) || (iHigh(NULL,PERIOD_D1,g)< temp2up) || (iLow(NULL,PERIOD_D1,g)<temp2up) || (iOpen(NULL,PERIOD_D1,g)<temp2up))
    {
    bullOBup[i] =0;
    bullOBdown[i] =0;
    bullFVGup[i] =0;
    bullFVGdown[i] =0;
    }
    if ((iClose(NULL,PERIOD_D1,g)<temp2down) || (iHigh(NULL,PERIOD_D1,g)< temp2down) || (iLow(NULL,PERIOD_D1,g)<temp2down) || (iOpen(NULL,PERIOD_D1,g)<temp2down))
    {
    bullOBBup[i] =0;
    bullOBBdown[i] =0;
    }    
    
    
    }
    }
    
    }
    
    //Validate if current price is into Daily FVG+OB
    for (int f = 0; f < rates_total; f++)
    {
    if (((iClose(NULL,PERIOD_D1,0)< bearOBup[f]) &&(iClose(NULL,PERIOD_D1,0)> bearOBdown[f])&& beardobup !=bearOBup[f] && beardobdown !=bearOBdown[f]))
    {
    //if (now > expiryTimeArraybear)
    //{
    
    string alertMessage = Symbol()+ ": The Bear chance has come";
    //string alertMessage = Symbol()+", "+ Period() + ": The Bull chance has come";
    //Alert(alertMessage);
    //SendNotification(alertMessage);
    SendMail("Alert",alertMessage);
    //expiryTimeArraybear = now + 4*60 * 60; // Convert minutes to seconds
    bearltftag = 1; //might need to trigger another indicator on 15M chart then 1M chart
    beardobup=bearOBup[f];
    beardobdown=bearOBdown[f];
    
    
    //}
    }
    
    
    if (((iClose(NULL,PERIOD_D1,0)< bullOBup[f]) &&(iClose(NULL,PERIOD_D1,0)> bullOBdown[f])&& bulldobup !=bullOBup[f] && bulldobdown !=bullOBdown[f]))
    {
    //if (now > expiryTimeArraybull)
    //{
    string alertMessage1 = Symbol() + ": The Bull chance has come";
    //Alert(alertMessage1);
    //SendNotification(alertMessage1);
    SendMail("Alert",alertMessage1);
    //expiryTimeArraybull = now + 4*60 * 60; // Convert minutes to seconds
    bullltftag = 1; //might need to trigger another indicator on 15M chart then 1M chart
    bulldobup=bullOBup[f];
    bulldobdown=bullOBdown[f];
    //}
    }
    }
    
    
    
    
    
    /*
    //Cancel all signal if price penetrates the Daily FVG+OB
    if (iClose(NULL,PERIOD_D1,0)>beardobup)
    {
    bearltftag = 0;
    }
    if (iClose(NULL,PERIOD_D1,0)<bulldobdown)
    {
    bullltftag = 0;
    }
    
    
    
    
    //Price forms FVG+OB in 1H Chart which direction is same with Daily Chart
    if (bearltftag==1)
    {
    if((iHigh(NULL,PERIOD_H1,1) < iLow(NULL,PERIOD_H1,3)) && (iClose(NULL,PERIOD_H1,2) < iLow(NULL,PERIOD_H1,3)))
    {
    //string alertMessage2 = Symbol() + ": The Bear chance has come even nearer";
    //Alert(alertMessage2);
    //SendNotification(alertMessage2);
    //bearlltftag=1;
    bearonehobup=iHigh(NULL,PERIOD_H1,3);
    bearonehobdown=iHigh(NULL,PERIOD_H1,1);
    }
    }
    if (bullltftag==1)
    {
    if((iLow(NULL,PERIOD_H1,1) > iHigh(NULL,PERIOD_H1,3)) && (iClose(NULL,PERIOD_H1,2)>iHigh(NULL,PERIOD_H1,3)))
    {
    //string alertMessage3 = Symbol() + ": The Bear chance has come even nearer";
    //Alert(alertMessage3);
    //SendNotification(alertMessage3);
    //bulllltftag=1;
    bullonehobup=iLow(NULL,PERIOD_H1,1);
    bullonehobdown=iLow(NULL,PERIOD_H1,3);
    }    
    }
    
    //Validate if current price is into 1H FVG+OB
    //TBD - add notifiycation here, or print something 
    if ((iClose(NULL,PERIOD_H1,0)< bearonehobup) &&(iClose(NULL,PERIOD_H1,0)> bearonehobdown))    
    {
    bearlltftag=1;
    }
    if ((iClose(NULL,PERIOD_H1,0)< bullonehobup) &&(iClose(NULL,PERIOD_H1,0)> bullonehobdown))    
    {
    bulllltftag=1;
    }
    
    
    //Cancel all signal if price penetrates the 1H FVG+OB
    if (iClose(NULL,PERIOD_H1,0)>bearonehobup)
    {
    bearlltftag = 0;
    }
    if (iClose(NULL,PERIOD_H1,0)<bullonehobdown)
    {
    bulllltftag = 0;
    }
  
  
    //Price forms FVG+OB in 5M Chart which direction is same with 1H Chart
    if (bearlltftag==1)
    {
    if((iHigh(NULL,PERIOD_M5,1) < iLow(NULL,PERIOD_M5,3)) && (iClose(NULL,PERIOD_M5,2) < iLow(NULL,PERIOD_M5,3)))
    {
    //string alertMessage2 = Symbol() + ": The Bear chance has come even nearer";
    //Alert(alertMessage2);
    //SendNotification(alertMessage2);
    //bearlltftag=1;
    bearfivemobup=iHigh(NULL,PERIOD_M5,3);
    bearfivemobdown=iHigh(NULL,PERIOD_M5,1);
    }
    }
    if (bulllltftag==1)
    {
    if((iLow(NULL,PERIOD_M5,1) > iHigh(NULL,PERIOD_M5,3)) && (iClose(NULL,PERIOD_M5,2)>iHigh(NULL,PERIOD_M5,3)))
    {
    //string alertMessage3 = Symbol() + ": The Bear chance has come even nearer";
    //Alert(alertMessage3);
    //SendNotification(alertMessage3);
    //bulllltftag=1;
    bullfivemobup=iLow(NULL,PERIOD_M5,1);
    bullfivemobdown=iLow(NULL,PERIOD_M5,3);
    }    
    }

    //Validate if current price is into 5M FVG+OB
    if ((iClose(NULL,PERIOD_M5,0)< bearfivemobup) &&(iClose(NULL,PERIOD_M5,0)> bearfivemobdown) && (bearfivemlastob != bearfivemobdown))    
    {
    string alertMessagelast1 = Symbol() + ": Sniper Bear Entry";
    Alert(alertMessagelast1);
    SendNotification(alertMessagelast1);
    SendMail("Alert",alertMessagelast1);
    bearfivemlastob = bearfivemobdown; // Convert minutes to seconds
    }
    if ((iClose(NULL,PERIOD_M5,0)< bullfivemobup) &&(iClose(NULL,PERIOD_M5,0)> bullfivemobdown)&& (bullfivemlastob  != bullfivemobup))    
    {
    string alertMessagelast = Symbol() + ": Sniper Bull Entry";
    Alert(alertMessagelast);
    SendNotification(alertMessagelast);
    SendMail("Alert",alertMessagelast);
    bullfivemlastob = bullfivemobup; // Convert minutes to seconds
    }
*/




    
    
    
    
    
    
    






    return rates_total;
}
