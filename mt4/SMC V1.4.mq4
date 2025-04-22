#property indicator_chart_window
#property indicator_buffers 8
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
datetime expiryTimeArraybull1;
datetime expiryTimeArraybear;
datetime expiryTimeArraybear1;
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
double bulldobbup;
double bulldobbdown;
double beardobbup;
double beardobbdown;

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

int counting;
int looponceA=0;


int OnInit(void)
  {

//--- 2 additional buffers are used for counting.
   //IndicatorBuffers(5);
   SetIndexStyle(0,DRAW_NONE);
   SetIndexStyle(1,DRAW_NONE);
   SetIndexStyle(2,DRAW_NONE);
   SetIndexStyle(3,DRAW_NONE);
   SetIndexStyle(4,DRAW_ARROW);
   SetIndexStyle(5,DRAW_ARROW);
   SetIndexStyle(6,DRAW_ARROW);
   SetIndexStyle(7,DRAW_ARROW);
   SetIndexBuffer(0,bullOBup);
   SetIndexBuffer(1,bullOBdown);
   SetIndexBuffer(2,bearOBup);
   SetIndexBuffer(3,bearOBdown);
   SetIndexBuffer(4,bullOBBup);
   SetIndexBuffer(5,bullOBBdown);
   SetIndexBuffer(6,bearOBBup);
   SetIndexBuffer(7,bearOBBdown);
   
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
 
    if(rates_total<1000)
    {
    counting = rates_total;
    }
    else
    {
    counting = 1000;
    } 
 
    if(looponceA==0)
    {
    //Locate all Daily FVG+OB
    for (int j = counting-2; j > 1; j--)
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
    for (int i = 0; i < counting; i++)
    {
    if ( bearOBup[i] >0)
    {
    double tempup = bearOBBdown[i];
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
    double temp2down = bullOBBup[i];
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
    looponceA=1;
    }
    
    
    //check if there is any new FVG+OB
    if((iLow(NULL,PERIOD_D1,1) > iHigh(NULL,PERIOD_D1,3)) && (iClose(NULL,PERIOD_D1,2)>iHigh(NULL,PERIOD_D1,3)))
    {
    bullOBup[3] = iLow(NULL,PERIOD_D1,1);
    bullOBdown[3] =iLow(NULL,PERIOD_D1,3);
    //20240725: newly add OB&FVG
    bullOBBup[3] = iHigh(NULL,PERIOD_D1,3);
    bullOBBdown[3] =iLow(NULL,PERIOD_D1,3);
    
    bullFVGup[3] = iLow(NULL,PERIOD_D1,1);
    bullFVGdown[3] =iHigh(NULL,PERIOD_D1,3);
    }
    
    if((iHigh(NULL,PERIOD_D1,1) < iLow(NULL,PERIOD_D1,3)) && (iClose(NULL,PERIOD_D1,2) < iLow(NULL,PERIOD_D1,3)))
    {
    bearOBup[3] =iHigh(NULL,PERIOD_D1,3);
    bearOBdown[3] =iHigh(NULL,PERIOD_D1,1);

    bearOBBup[3] = iHigh(NULL,PERIOD_D1,3);
    bearOBBdown[3] =iLow(NULL,PERIOD_D1,3);
    
    bearFVGup[3] = iLow(NULL,PERIOD_D1,3);
    bearFVGdown[3] =iHigh(NULL,PERIOD_D1,1); 
    }     
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //Validate if current price is into Daily FVG+OB
    for (int f = 0; f < counting; f++)
    {
    
    if(bearOBup[f]==0)
    {
    }
    else
    {
    
    if (((iClose(NULL,PERIOD_D1,0)< bearOBup[f]) &&(iClose(NULL,PERIOD_D1,0)> bearOBdown[f])&& beardobup !=bearOBup[f] && beardobdown !=bearOBdown[f] && now > expiryTimeArraybear))
    {
    //if (now > expiryTimeArraybear)
    //{
    
    string alertMessage = Symbol()+ ": The Bear chance has come (FVG)";
    //string alertMessage = Symbol()+", "+ Period() + ": The Bull chance has come";
    Alert(alertMessage);
    SendNotification(alertMessage);
    //SendMail("Alert",alertMessage);
    expiryTimeArraybear = now + 30; // 1 means 1 second
    bearltftag = 1; //might need to trigger another indicator on 15M chart then 1M chart
    beardobup=bearOBup[f];
    beardobdown=bearOBdown[f];
    bearOBup[f]=0;
    bearOBdown[f]=0;
    //}
    }
    }





    if(bearOBBup[f]==0)
    {
    }
    else
    {
    
    if (((iClose(NULL,PERIOD_D1,0)< bearOBBup[f]) &&(iClose(NULL,PERIOD_D1,0)> bearOBBdown[f])&& beardobbup !=bearOBBup[f] && beardobbdown !=bearOBBdown[f] && now > expiryTimeArraybear1))
    {
    //if (now > expiryTimeArraybear)
    //{
    
    string alertMessage2 = Symbol()+ ": The Bear chance has come (OB)";
    //string alertMessage = Symbol()+", "+ Period() + ": The Bull chance has come";
    Alert(alertMessage2);
    SendNotification(alertMessage2);
    //SendMail("Alert",alertMessage2);
    expiryTimeArraybear1 = now + 30; // 1 means 1 second
    //bearltftag = 1; //might need to trigger another indicator on 15M chart then 1M chart
    beardobbup=bearOBBup[f];
    beardobbdown=bearOBBdown[f];
    bearOBBup[f]=0;
    bearOBBdown[f]=0;
    //}
    }
    }











    
    if(bullOBup[f]==0)
    {
    }
    else
    {
    if (((iClose(NULL,PERIOD_D1,0)< bullOBup[f]) &&(iClose(NULL,PERIOD_D1,0)> bullOBdown[f])&& bulldobup !=bullOBup[f] && bulldobdown !=bullOBdown[f] && now > expiryTimeArraybull))
    {
    //if (now > expiryTimeArraybull)
    //{
    string alertMessage1 = Symbol() + ": The Bull chance has come (FVG)";
    Alert(alertMessage1);
    SendNotification(alertMessage1);
    //SendMail("Alert",alertMessage1);
    //expiryTimeArraybull = now + 4*60 * 60; // Convert minutes to seconds, here means 4 hours
    expiryTimeArraybull = now + 30; // Convert minutes to seconds, here means 4 hours
    bullltftag = 1; //might need to trigger another indicator on 15M chart then 1M chart
    bulldobup=bullOBup[f];
    bulldobdown=bullOBdown[f];
    bullOBup[f]=0;
    bullOBdown[f]=0;
    //}
    }
    }
    
    
    
    

    
    if(bullOBBup[f]==0)
    {
    }
    else
    {
    if (((iClose(NULL,PERIOD_D1,0)< bullOBBup[f]) &&(iClose(NULL,PERIOD_D1,0)> bullOBBdown[f])&& bulldobbup !=bullOBBup[f] && bulldobbdown !=bullOBBdown[f] && now > expiryTimeArraybull1))
    {
    //if (now > expiryTimeArraybull)
    //{
    string alertMessage3 = Symbol() + ": The Bull chance has come (OB)";
    Alert(alertMessage3);
    SendNotification(alertMessage3);
    //SendMail("Alert",alertMessage3);
    //expiryTimeArraybull = now + 4*60 * 60; // Convert minutes to seconds, here means 4 hours
    expiryTimeArraybull1 = now + 30; // Convert minutes to seconds, here means 4 hours
    //bullltftag = 1; //might need to trigger another indicator on 15M chart then 1M chart
    bulldobbup=bullOBBup[f];
    bulldobbdown=bullOBBdown[f];
    bullOBBup[f]=0;
    bullOBBdown[f]=0;
    //}
    }
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
