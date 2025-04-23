//+------------------------------------------------------------------+
//|                   Multi_Pair_Pivot_Point_Scanner_Alerts_v2.7.mq4 |
//|                                         Copyright 2019, NickBixy |Cross_Alerts
//|             https://www.forexfactory.com/showthread.php?t=904734 |
//+------------------------------------------------------------------+
//v1.0 - 1H version
//v1.0a - 4H version
//v1.0b - 1D version
#property copyright "Maokor"
#property link      "https://www.forexfactory.com/showthread.php?t=904734"
//#property version   "2.0"
#property strict
#property description "Indicator Scans Multiple Symbol Pairs Looking For When The Price Crosses A Pivot Point or xx points near or bounced off pivot Then It Alerts The Trader."
#property indicator_chart_window
#define HR2400 (PERIOD_D1 * 60)
enum pivotTypes
  {
   Standard,//Standard(Floor) Pivot Formula
   Fibonacci,//Fibonacci Pivot Formula
   Camarilla,//Camarilla Pivot Formula
   Woodie,//Woodie Pivot Formula
   FVG//FVG
  };
enum yesnoChoiceToggle
  {
   No,
   Yes
  };
enum timeChoice
  {
   Server,
   Local
  };
enum symbolTypeChoice
  {
   MarketWatch,//Market Watch
   SymbolList//Symbols In List
  };
enum alertMode
  {
   Cross_Alerts,//Crossed Pivot Alerts
   Near_Alerts,//Near Pivot Alerts
   Cross_And_Bounce_Alerts,//Crossed And Bounced Alerts
   Near_And_Bounce_Alerts,//Near And Bounced Alerts
   Bounce_Only_Alerts//Bounced Only Alerts
  };
enum enabledisableChoiceToggle
  {
   Disable,
   Enable
  };
input string info="Put Scanner On A Separate Chart Tab From Trading Strategy";//Put Scanner On A Separate Chart Tab From Trading Stategy
//input string indiLink="https://www.forexfactory.com/showthread.php?t=904734";//Indicator's thread on Forex Factory
input int refreshTime=5;//Refresh check every x Seconds
input string pivotPointHeader="-----------------Pivot Point Settings------------------------------------------";//----- Pivot Point Settings
input pivotTypes pivotSelection=FVG;//Pivot Point Formula
input ENUM_TIMEFRAMES pivotTimeframe=PERIOD_D1;//Pivot Point Timeframe
input alertMode alertModeSelection= Cross_Alerts;//Alert Mode to use
input int xxPoints=50;//Points Near Pivot - For Alert Mode Near only
string pointsNearMessage="is Near";//PointsNear Alert Msg
string crossedMessage="Crossed";//Cross Alert Msg
input string symbolHeader="-----------------Symbol Settings------------------------------------------";//----- Symbol Settings
input symbolTypeChoice symTypeChoice=SymbolList;//Symbols To Scan- Market Watch/Symbol List Below
input string symbols="AUDCAD,AUDCHF,AUDJPY,AUDNZD,AUDUSD,CADCHF,CADJPY,CHFJPY,EURAUD,EURCAD,EURCHF,EURGBP,EURJPY,EURNZD,EURUSD,GBPAUD,GBPCAD,GBPCHF,GBPJPY,GBPNZD,GBPUSD,NZDCAD,NZDCHF,NZDJPY,NZDUSD,USDCAD,USDCHF,USDJPY"; //Symbols To Scan
input string symbolPrefix=""; //Symbol Prefix
input string symbolSuffix=""; //Symbol Suffix
input string printoutAndAlertHeader="-----------------Alert/Printout Settings--------------------------------------";//----- Alert/Printout Settings
input int alertInternalMinutes=15;//Alert Wait Time In Min for same Pivot alert Msg
input yesnoChoiceToggle popupAlerts=No;//Use Popup Alerts?
input yesnoChoiceToggle notificationAlerts=Yes;//Use Notification Alerts?
input yesnoChoiceToggle emailAlerts=Yes;//Use Email Alerts?
input yesnoChoiceToggle showBidPriceOnAlert=No;//Show Bid Price in Alert Msg
input yesnoChoiceToggle printOutPivotPoints=No;//Print Out Pivot Values - For Testing Values
input int printOutPivotPointsSymbolIndex=0;//Index Value Of Symbol To Print Out
input string bouncedHeader="-----------------Bounced Mode Alerts Settings------------------------------------------";//----- Bounce Settings
input ENUM_TIMEFRAMES bouncedCandleTF=PERIOD_M15;//Time Frame Candles For Bounced Alerts
input yesnoChoiceToggle candleColorFilter=Yes;//Use Candle Color Filter
input int bounceXBarsWait=0;//Alert Wait Time In Bars for same Pivot alert Msg
input string offResistanceBounceMSG=" - Price Crossed Then Closed Below";//Msg For Bounce Off Resistance
input string offSupportBounceMSG=" - Price Crossed Then Closed Above";//Msg For Bounce Off Support
input string bbFilterHeader="-----------------Bollinger Bands Filter Settings------------------------------------------";//----- Bollinger Bands Filter
input string note="Near/Cross/Bounce Alerts only when price is above upper band or when price is below lower band";//Filter note
input yesnoChoiceToggle useBollingerBands=No;//Use BollingerBands upper/lower Filter
input ENUM_TIMEFRAMES BBtimeFrame=PERIOD_M30;//Bollinger Bands: Timeframe
input int BBperiod=20;//Bollinger Bands: Period
input double BBdeviation=2;//Bollinger Bands: Deviations
input int BBShift=0;//Bollinger Bands: Shift
input ENUM_APPLIED_PRICE BBAppliedPrice=PRICE_CLOSE;//Bollinger Bands: Apply to
input string showAlertsHeader="-----------------Enable/Disable Alerts For Specified Pivot Point----------------------------------------------";//----- Will Affect All the Alert Modes
input string showAlertsStandardPivotHeader="Standard Pivot Point--------------------------------------------";//----- Standard Pivot Point Settings
input enabledisableChoiceToggle MidPointAlerts=Disable;//Mid Pivot Point Alerts
input enabledisableChoiceToggle showStandardPivotR6=Enable;//Standard Pivot R6
input enabledisableChoiceToggle showStandardPivotR5=Enable;//Standard Pivot R5
input enabledisableChoiceToggle showStandardPivotR4=Enable;//Standard Pivot R4
input enabledisableChoiceToggle showStandardPivotR3=Enable;//Standard Pivot R3
input enabledisableChoiceToggle showStandardPivotR2=Enable;//Standard Pivot R2
input enabledisableChoiceToggle showStandardPivotR1=Enable;//Standard Pivot R1
input enabledisableChoiceToggle showStandardPivotPP=Enable;//Standard Pivot PP
input enabledisableChoiceToggle showStandardPivotS1=Enable;//Standard Pivot S1
input enabledisableChoiceToggle showStandardPivotS2=Enable;//Standard Pivot S2
input enabledisableChoiceToggle showStandardPivotS3=Enable;//Standard Pivot S3
input enabledisableChoiceToggle showStandardPivotS4=Enable;//Standard Pivot S4
input enabledisableChoiceToggle showStandardPivotS5=Enable;//Standard Pivot S5
input enabledisableChoiceToggle showStandardPivotS6=Enable;//Standard Pivot S6
input string StandardMidPivotHeader="-----------------Standard Mid Pivot Points";//----- Standard Mid PP
input enabledisableChoiceToggle showStandardPivotMR4=Enable;//Standard Pivot mR4
input enabledisableChoiceToggle showStandardPivotMR3=Enable;//Standard Pivot mR3
input enabledisableChoiceToggle showStandardPivotMR2=Enable;//Standard Pivot mR2
input enabledisableChoiceToggle showStandardPivotMR1=Enable;//Standard Pivot mR1
input enabledisableChoiceToggle showStandardPivotMS1=Enable;//Standard Pivot mS1
input enabledisableChoiceToggle showStandardPivotMS2=Enable;//Standard Pivot mS2
input enabledisableChoiceToggle showStandardPivotMS3=Enable;//Standard Pivot mS3
input enabledisableChoiceToggle showStandardPivotMS4=Enable;//Standard Pivot mS4
input string showAlertsFibonacciPivotHeader="Fibonacci Pivot Point--------------------------------------------";//----- Fibonacci Pivot Point Settings
input enabledisableChoiceToggle showFibonacciPivotR200=Disable;//Fibonacci Pivot R200
input enabledisableChoiceToggle showFibonacciPivotR161=Disable;//Fibonacci Pivot R161
input enabledisableChoiceToggle showFibonacciPivotR138=Disable;//Fibonacci Pivot R138
input enabledisableChoiceToggle showFibonacciPivotR100=Enable;//Fibonacci Pivot R100
input enabledisableChoiceToggle showFibonacciPivotR78=Enable;//Fibonacci Pivot R78
input enabledisableChoiceToggle showFibonacciPivotR61=Enable;//Fibonacci Pivot R61
input enabledisableChoiceToggle showFibonacciPivotR38=Enable;//Fibonacci Pivot R38
input enabledisableChoiceToggle showFibonacciPivotPP=Enable;//Fibonacci Pivot PP
input enabledisableChoiceToggle showFibonacciPivotS38=Enable;//Fibonacci Pivot S38
input enabledisableChoiceToggle showFibonacciPivotS61=Enable;//Fibonacci Pivot S61
input enabledisableChoiceToggle showFibonacciPivotS78=Enable;//Fibonacci Pivot S78
input enabledisableChoiceToggle showFibonacciPivotS100=Enable;//Fibonacci Pivot S100
input enabledisableChoiceToggle showFibonacciPivotS138=Disable;//Fibonacci Pivot S138
input enabledisableChoiceToggle showFibonacciPivotS161=Disable;//Fibonacci Pivot S161
input enabledisableChoiceToggle showFibonacciPivotS200=Disable;//Fibonacci Pivot S200
input string showAlertsWoodiePivotHeader="Woodie Pivot Point--------------------------------------------";//----- Woodie Pivot Point Settings
input enabledisableChoiceToggle showWoodieR1=Enable;//Woodie Pivot R1
input enabledisableChoiceToggle showWoodieR2=Enable;//Woodie Pivot R2
input enabledisableChoiceToggle showWoodiePP=Enable;//Woodie Pivot PP
input enabledisableChoiceToggle showWoodieS1=Enable;//Woodie Pivot S1
input enabledisableChoiceToggle showWoodieS2=Enable;//Woodie Pivot S2
input string showAlertsCamarillaPivotHeader="Camarilla Pivot Point--------------------------------------------";//----- Camarilla Pivot Point Settings
input enabledisableChoiceToggle showCamarillaR1=Enable;//Camarilla Pivot R1
input enabledisableChoiceToggle showCamarillaR2=Enable;//Camarilla Pivot R2
input enabledisableChoiceToggle showCamarillaR3=Enable;//Camarilla Pivot R3
input enabledisableChoiceToggle showCamarillaR4=Enable;//Camarilla Pivot R4
input enabledisableChoiceToggle showCamarillaR5=Enable;//Camarilla Pivot R5
input enabledisableChoiceToggle showCamarillaPP=Enable;//Camarilla Pivot PP
input enabledisableChoiceToggle showCamarillaS1=Enable;//Camarilla Pivot S1
input enabledisableChoiceToggle showCamarillaS2=Enable;//Camarilla Pivot S2
input enabledisableChoiceToggle showCamarillaS3=Enable;//Camarilla Pivot S3
input enabledisableChoiceToggle showCamarillaS4=Enable;//Camarilla Pivot S4
input enabledisableChoiceToggle showCamarillaS5=Enable;//Camarilla Pivot S5
input int InpRSIPeriod=7; // RSI Period

int numSymbols=0; //the number of symbols to scan
int alertIntervalTimeSeconds; //wait time between same alert message for pivot point

string symbolList[]; // array of symbols
string symbolListFinal[]; // array of symbols after merging post and prefix
datetime symbolTimeframeTimeP[]; //array of symbol dates today used for checking for new day for each symbol
double Pivots[][21]; //stores all the pivot points for each timeframe
double PivotsCheck[][21]; //stores all the pivot points for each timeframe
double TRDACheck[][21]; //stores all the pivot points for each timeframe
double FVGCheck[][21]; //stores all the pivot points for each timeframe
//stores all the bool flags to help detect price cross pivot point for each timeframe
bool PivotsFlag[][21];
//stores the time to wait for alert time interval for each pivot points timeframe
datetime   PivotsWaitTill[][21];
datetime   PivotsWaitTillB[][21];
double   FVGWaitTill[][21];
double   FVGWaitTillB[][21];
//stores all the bool flags to help detect price cross pivot point for each timeframe
bool PivotsZoneFlag[][21];
//num of pivots for each formula
int numPPStandard=21;
int numPPCamarilla=11;
int numPPWoodie=5;
int numPPFibonacci=15;
int numPPFVG=1;
double ExtStrengthEUR;
double ExtStrengthUSD;
double ExtStrengthGBP;
double ExtStrengthAUD;
double ExtStrengthNZD;
double ExtStrengthCHF;
double ExtStrengthCAD;
double ExtStrengthJPY;
double ExtStrength[8];
string CurrStrength[8];    
double indexmap[30][8];
double AfExtStrength[8];
string AfCurrStrength[8]; 
int firstS[30][8];
int secondS[30][8];
double firstSV[30][8];
double secondSV[30][8];

double bullOBup[30][10000];
double bullOBdown[30][10000];
double bearOBup[30][10000];
double bearOBdown[30][10000];
datetime bullOBtime[30][10000];
datetime bearOBtime[30][10000];
    
//bool for the enable/disables specified pivot alerts and thier pivot names in correct index order
bool showStandard[21];
string standardPivotNames[]=
  {
   "Pivot",
   "S1",
   "S2",
   "S3",
   "R1",
   "R2",
   "R3",
   "R4",
   "S4",
   "R5",
   "S5",
   "R6",
   "S6",
   "mR4",
   "mR3",
   "mR2",
   "mR1",
   "mS1",
   "mS2",
   "mS3",
   "mS4",
  };
bool showCamarilla[11];
string camarillaPivotNames[]=
  {
   "Pivot",
   "S1",
   "S2",
   "S3",
   "S4",
   "R1",
   "R2",
   "R3",
   "R4",
   "R5",
   "S5",
  };
bool showWoodie[5];
string woodiePivotNames[]=
  {
   "Pivot",
   "S1",
   "S2",
   "R1",
   "R2"
  };
bool showFibonacci[15];
string fibonacciPivotNames[]=
  {
   "Pivot",
   "R38",
   "R61",
   "R78",
   "R100",
   "R138",
   "R161",
   "R200",
   "S38",
   "S61",
   "S78",
   "S100",
   "S138",
   "S161",
   "S200",
  };
bool showFVG[1];
string FVGPivotNames[]=
  {
   "Pivot",
  };  
  
string pivotTimeframeName;
/////////////////////////////////////////////////////////////////////////////////////////////
//variables for bounced check alerts
datetime symbolNewCandleCheck[][1];//keep track of current candle time so will know if new candle starts
datetime bouncedWaitTill[][25];
int symbolPPIndex[][1];//keep track of the pivot point index that was crossed for all symbols in list, they start all set to -1
//keep track of the symbol pivot cross state, they start all set to 0 when bull candle cross pp from below set to 1 for opposite set 2
//hold that state untill a oppposite candle closses above or below then reset ot reset when new pivot cross update state
int PivotState[][1] ;
string indiName="MPPPSA"+EnumToString(pivotTimeframe)+EnumToString(pivotSelection);

input string dashBoardHeader="-----------------Dashboard Settings--------------------------------------";//----- Dashboard Settings
input yesnoChoiceToggle useDashboard=Yes;//Use DashBoard?
input int widthX=28;//X Dashboard +Moves right, -Moves left
input int widthY=28;//Y Dashboard +Moves down, -Moves up
input int symbolPivotXSpacing=85;//X  Between Columns Symbol-PP Nearest
input int pivotPivotAlertXSpacing=50;//X  Between Columns PP Nearest-PP Alert
input int pivotAlertTimeLastXSpacing=35;//X  Between Columns PP Alert-Time Last
input string FontHeader="Arial Bold";//Font of the headers
input string Font="Arial";//font of the labels
input int fontText=9;//Font Size Labels
input int textH=14;//Y Spacing Between Rows
input color headerColors=clrViolet;//Color of Header
input color symbolColor=clrWhite;//Color of Symbol Rows
int textHEnd=0;
input timeChoice timeChoiceOption=Local;//Local/Server Time For Time Last Alert
input color resistantColor=clrOrangeRed;//Resistant PP Color
input color supportColor=clrLawnGreen;//Support PP Color
input color pivotColor=clrGold;//Pivot Color

input int listLabelSize=40;//Num Of Alert Msg In List Below
input bool usePivotColor=False;//Label Color use res/sup/piv colors for alerts
input color listLabelColor=clrAquamarine;//List Label Color
input color timeLastAlertColor=clrAquamarine;//Time Last Alert Label Color
input ENUM_TIMEFRAMES openChartTimeFrame=PERIOD_H1;//Open Chart TimeFrame
string listLabelNames[];
//initial start
int OnInit()
  {
   if(EventSetTimer(refreshTime)==false)
     {
      Alert("ERROR CODE: "+(string)GetLastError());//check error code for timer
     }
   IndicatorSetString(INDICATOR_SHORTNAME,indiName);//name of indicator used for when symbol not found error will remove indicator from chart

   ObjectsDeleteAll(0,indiName,0,OBJ_LABEL) ;

   alertIntervalTimeSeconds=alertInternalMinutes*60;//waiting time between alerts
   updateSpecifiedPivotPointAlerts();//set the bool for the show pivot alerts
   if(symTypeChoice==MarketWatch)
     {
      int numSymbolsMarketWatch=SymbolsTotal(true);
      numSymbols=numSymbolsMarketWatch;
      ArrayResize(symbolListFinal,numSymbolsMarketWatch);
      for(int i=0; i<numSymbolsMarketWatch; i++)
        {
         symbolListFinal[i]=SymbolName(i,true);
        }
     }
   else
      if(symTypeChoice==SymbolList)
        {
         getSymbols();//converts the symbol string to list of symbols
        }
   if(testSymbols())//checks if all symbols exits, if not removes indicator from chart and alert message
     {
      if(useDashboard==Yes)
        {
         ArrayResize(listLabelNames,listLabelSize);
         for(int k=0; k<ArraySize(listLabelNames); k++)
           {
            listLabelNames[k]=(string)k;
           }
         CreateLabels();
        }


      initializePivotPoints();
      switch(pivotTimeframe)
        {
         case PERIOD_M1:
           {
            pivotTimeframeName="M1 ";
            break;
           }
         case PERIOD_M5:
           {
            pivotTimeframeName="M5 ";
            break;
           }
         case PERIOD_M15:
           {
            pivotTimeframeName="M15 ";
            break;
           }
         case PERIOD_M30:
           {
            pivotTimeframeName="M30 ";
            break;
           }
         case PERIOD_H1:
           {
            pivotTimeframeName="H1 ";
            break;
           }
         case PERIOD_H4:
           {
            pivotTimeframeName="H4 ";
            break;
           }
         case PERIOD_D1:
           {
            pivotTimeframeName="D1 ";
            break;
           }
         case PERIOD_W1:
           {
            pivotTimeframeName="W1 ";
            break;
           }
         case PERIOD_MN1:
           {
            pivotTimeframeName="MN1 ";
            break;
           }
        }
     }
     
   return(INIT_SUCCEEDED);
  }
//ondenit
void  OnDeinit(const int  reason)
  {
   ObjectsDeleteAll(0,indiName,0,OBJ_LABEL) ;
   Print(__FUNCTION__," Deinitialization reason code = ",reason);
  }
//use to force symbols to download lastest chart data
bool download_history(string symbol, ENUM_TIMEFRAMES period=PERIOD_CURRENT)
  {
   if(period == PERIOD_CURRENT)
      period = (ENUM_TIMEFRAMES)_Period;
   ResetLastError();
   datetime other = iTime(symbol, period, 0);
   if(_LastError == 0 && other != 0)
      return true;
   if(_LastError != ERR_HISTORY_WILL_UPDATED
      && _LastError != ERR_NO_HISTORY_DATA
     )
      PrintFormat("iTime(%s,%i) Failed: %i", symbol, period, _LastError);
   return false;
  }
//main loop to check for alert conditions every xx seconds
void OnTimer()//this one loops every x seconds checking each symbol for the alert conditions or when new day to refresh new pivot point values
  {
//check each symbol if thier is a new day , if true recalculate pivot points
   for(int symbolIndex=0; symbolIndex<numSymbols; symbolIndex++)
     {
      if(!download_history(symbolListFinal[symbolIndex],pivotTimeframe))
        {
         continue;
        }
      else
        {
         if(symbolTimeframeTimeP[symbolIndex]==NULL || symbolTimeframeTimeP[symbolIndex]!=iTime(symbolListFinal[symbolIndex],pivotTimeframe,0))//check if times match
           {
            symbolTimeframeTimeP[symbolIndex]=NULL;
            switch(pivotSelection)
              {
               case Standard :
                  initializePivotPoints(symbolIndex,numPPStandard);
                  break;
               case Camarilla :
                  initializePivotPoints(symbolIndex,numPPCamarilla);
                  break;
               case Woodie :
                  initializePivotPoints(symbolIndex,numPPWoodie);
                  break;
               case Fibonacci :
                  initializePivotPoints(symbolIndex,numPPFibonacci);
                  break;
               case FVG :
                  initializePivotPoints(symbolIndex,numPPFVG);
                  break;
              }
           }
         else
           {

            switch(pivotSelection)
              {
               case Standard :
                  checkValuesForValid(symbolIndex,numPPStandard);
                  break;
               case Camarilla :
                  checkValuesForValid(symbolIndex,numPPCamarilla);
                  break;
               case Woodie :
                  checkValuesForValid(symbolIndex,numPPWoodie);
                  break;
               case Fibonacci :
                  checkValuesForValid(symbolIndex,numPPFibonacci);
                  break;
               case FVG :
                  checkValuesForValid(symbolIndex,numPPFVG);
                  break;
              }
            //check flags
            switch(pivotSelection)//main looping for when checking for the pivot alerts for trader
              {
               case Standard :
                  PivotCheck(symbolIndex,numPPStandard,showStandard,standardPivotNames);
                  break;
               case Camarilla :
                  PivotCheck(symbolIndex,numPPCamarilla,showCamarilla,camarillaPivotNames);
                  break;
               case Woodie :
                  PivotCheck(symbolIndex,numPPWoodie,showWoodie,woodiePivotNames);
                  break;
               case Fibonacci :
                  PivotCheck(symbolIndex,numPPFibonacci,showFibonacci,fibonacciPivotNames);
                  break;
               case FVG :
                  PivotCheck(symbolIndex,numPPFVG,showFVG,FVGPivotNames);
                  break;
              }
            if(useDashboard==Yes)
              {
               LabelPivot(symbolIndex);
              }

           }
        }
     }//end of for loop
  }
//using onTimer instead
int start()
  {
   return 0;
  }
//prepares the pivot points arrays
void initializePivotPoints()//this method just prepares the arrays correct index size then call method to get the pivot points values/flags
  {
   ArrayResize(symbolTimeframeTimeP,numSymbols);//resize to the number of symbols being used
   for(int i=0; i<numSymbols; i++)
     {
      symbolTimeframeTimeP[i]=NULL;
     }
   if(pivotSelection==Standard && MidPointAlerts==Enable)
     {
      numPPStandard=21;
     }
   else
     {
      numPPStandard=13;
     }
//if using bounced alerts resize array to number of symbols being used
   if(alertModeSelection==Cross_And_Bounce_Alerts ||
      alertModeSelection==Near_And_Bounce_Alerts  ||
      alertModeSelection==Bounce_Only_Alerts)
     {
      ArrayResize(symbolNewCandleCheck,numSymbols);
      ArrayResize(symbolPPIndex,numSymbols);
      ArrayResize(PivotState,numSymbols);
      ArrayResize(bouncedWaitTill,numSymbols);
     }
   ArrayResize(Pivots,numSymbols);
   ArrayResize(PivotsCheck,numSymbols);
   ArrayResize(TRDACheck,numSymbols);
   ArrayResize(FVGCheck,numSymbols);
   ArrayResize(PivotsFlag,numSymbols);
   ArrayResize(PivotsWaitTill,numSymbols);
   ArrayResize(PivotsWaitTillB,numSymbols);
   ArrayResize(FVGWaitTill,numSymbols);
   ArrayResize(FVGWaitTillB,numSymbols);
   ArrayResize(PivotsZoneFlag,numSymbols);
  }
//gets the symbol if using list
void getSymbols()//method extracts the symbols from the string turns it to a list then adds on the correct prefix and suffix so can find symbols
  {
   string sep=",";
   ushort u_sep;
   u_sep=StringGetCharacter(sep,0);
   StringSplit(symbols,u_sep,symbolList);
   numSymbols=ArraySize(symbolList);//get the number of how many symbols are in the symbolList array
   ArrayResize(symbolListFinal,numSymbols);//resize finals symbol list to correct size
   for(int i=0; i<numSymbols; i++) //combines postfix , symbol , prefix names together
     {
      symbolListFinal[i]=symbolPrefix+symbolList[i]+symbolSuffix;
     }
  }
//test the symbols to make sure it can find them
bool testSymbols()//try to find all the symbols from list if not error message
  {
   bool result=true;
   for(int i=0; i<numSymbols; i++)
     {
      double bid=MarketInfo(symbolListFinal[i],MODE_BID);
      if(GetLastError()==4106) // unknown symbol
        {
         result=false;
         Alert("Can't find this symbol: "+symbolListFinal[i]+",\nPut symbols in Market Watch,\nDouble Check Prefix Or Suffix Settings,\nREMOVING INDICATOR FROM CHART.");

         ChartIndicatorDelete(0,0,indiName);
         break;
        }
     }
   return result;
  }
//reset variables
void resetVariables(int symbolIndex)//resets all pivot wait tills when new day
  {
//if using bounced alerts resize array to number of symbols being used
   if(alertModeSelection==Cross_And_Bounce_Alerts ||
      alertModeSelection==Near_And_Bounce_Alerts  ||
      alertModeSelection==Bounce_Only_Alerts)
     {
      symbolNewCandleCheck[symbolIndex][0]=NULL;
      symbolPPIndex[symbolIndex][0]=NULL;
      PivotState[symbolIndex][0]=NULL;
      for(int k=0; k<21; k++)
        {
         bouncedWaitTill[symbolIndex][k]=NULL;
        }
     }
   for(int k=0; k<20; k++)
     {
      Pivots[symbolIndex][k]=NULL;
      PivotsFlag[symbolIndex][k]=NULL;
      PivotsZoneFlag[symbolIndex][k]=NULL;
      PivotsWaitTill[symbolIndex][k]=NULL;
      PivotsWaitTillB[symbolIndex][k]=NULL;
      FVGWaitTill[symbolIndex][k]=NULL;
      FVGWaitTillB[symbolIndex][k]=NULL;
     // FVGCheck[symbolIndex][k]=NULL;
     }
  }
//handles the alerts
void doAlert(string symbol,string timeFrameName,string pivotLevelName)//handles all the alert messages
  {
   datetime timeOfAlert=NULL;
   if(useDashboard==Yes)
     {
      if(timeChoiceOption==Local)
        {
         timeOfAlert=TimeLocal();
        }
      else
         if(timeChoiceOption==Server)
           {
            timeOfAlert=TimeCurrent();
           }

      TimeOfAlertLabelUpdate(symbol,timeOfAlert,pivotLevelName);
     }


   if(alertModeSelection==Cross_Alerts ||
      alertModeSelection==Cross_And_Bounce_Alerts)
     {
      if(showBidPriceOnAlert==No)
        {
         if(useDashboard==Yes)
           {
            string message=symbol+" "+timeFrameName+pivotLevelName;
            ListLabels(symbol,message,pivotLevelName);
           }


         string messageAlert=symbol+" "+timeFrameName+pivotLevelName+" "+crossedMessage+"\n"+EnumToString(pivotSelection);
         if(popupAlerts==Yes)
           {
            Alert(messageAlert);
           }
         if(notificationAlerts==Yes)
           {
            SendNotification(messageAlert);
           }
         if(emailAlerts==Yes)
           {
            SendMail(messageAlert,messageAlert);
           }
        }
      else
        {
         if(useDashboard==Yes)
           {
            string message=symbol+" "+timeFrameName+pivotLevelName+" @ "+DoubleToString(SymbolInfoDouble(symbol,SYMBOL_BID),(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
            ListLabels(symbol,message,pivotLevelName);
           }

         string messageAlert=symbol+" "+timeFrameName+pivotLevelName+" "+crossedMessage+" @ "+DoubleToString(SymbolInfoDouble(symbol,SYMBOL_BID),(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS))+"\n"+EnumToString(pivotSelection);
         if(popupAlerts==Yes)
           {
            Alert(messageAlert);
           }
         if(notificationAlerts==Yes)
           {
            SendNotification(messageAlert);
           }
         if(emailAlerts==Yes)
           {
            SendMail(messageAlert,messageAlert);
           }
        }
     }
   if(alertModeSelection==Near_Alerts ||
      alertModeSelection==Near_And_Bounce_Alerts)
     {
      if(showBidPriceOnAlert==No)
        {
         if(useDashboard==Yes)
           {
            string message=symbol+" "+timeFrameName+pivotLevelName;
            ListLabels(symbol,message,pivotLevelName);
           }

         string messageAlert=symbol+" "+timeFrameName+pivotLevelName+" "+pointsNearMessage+"\n"+EnumToString(pivotSelection);
         if(popupAlerts==Yes)
           {
            Alert(messageAlert);
           }
         if(notificationAlerts)
           {
            SendNotification(messageAlert);
           }
         if(emailAlerts==Yes)
           {
            SendMail(messageAlert,messageAlert);
           }
        }
      else
        {
         if(useDashboard==Yes)
           {
            string message=symbol+" "+pivotLevelName+" @ "+DoubleToString(SymbolInfoDouble(symbol,SYMBOL_BID),(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
            ListLabels(symbol,message,pivotLevelName);
           }

         string messageAlert=symbol+" "+pivotLevelName+pointsNearMessage+" @ "+DoubleToString(SymbolInfoDouble(symbol,SYMBOL_BID),(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS))+"\n"+EnumToString(pivotSelection);
         if(popupAlerts==Yes)
           {
            Alert(messageAlert);
           }
         if(notificationAlerts)
           {
            SendNotification(messageAlert);
           }
         if(emailAlerts==Yes)
           {
            SendMail(messageAlert,messageAlert);
           }
        }
     }
  }
           string pType;
         double pEntry;
         double pSL;
  
//handles the alerts
void doAlertFVG(string symbol,string timeFrameName,string pivotLevelName, int bb, int symbolIndex)//handles all the alert messages
  {
string st1;
string st2;

int stt1=0;
int stt2=0;
int stt=0;


         if (bb == 1)
         {
         pEntry = iLow(symbol,PERIOD_M15,1);
         pSL = iLow(symbol,PERIOD_M15,3);
         pType = "^";
         currencystrength(pivotTimeframe,firstS,secondS,firstSV,secondSV,1,symbolIndex,symbol);
         if (firstS[symbolIndex][0] <=4)
         {
         if (firstS[symbolIndex][0] <=2)
         {
         st1 = "(VG)";
         stt1 +=2;
         }
         else
         {
         st1 = "(G)";
         stt1 +=1;
         }
         }
         else
         {
         
         if (firstS[symbolIndex][0] >=7)
         {
         st1 = "(VB)";
         stt1 -=2;
         }
         else
         {
         st1 = "(B)";
         stt1 -=1;
         }         

         }
         if (secondS[symbolIndex][0] >=5)
         {
         if (secondS[symbolIndex][0] >=7)
         {
         st2 = "(VG)";
         stt2 +=2;
         }
         else
         {
         st2 = "(G)";
         stt2 +=1;
         }
         }
         else
         {
         

         if (secondS[symbolIndex][0] <=2)
         {
         st2 = "(VB)";
         stt2 -=2;
         }
         else
         {
         st2 = "(B)";
         stt2 -=1;
         }                  
         
     


         }
         }
         
         
         if (bb == -1)
         {
         pEntry = iHigh(symbol,PERIOD_M15,1);
         pSL = iHigh(symbol,PERIOD_M15,3);
         pType = "v";
         currencystrength(pivotTimeframe,firstS,secondS,firstSV,secondSV,-1,symbolIndex,symbol);
         if (firstS[symbolIndex][0] >=5)
         {
         if (firstS[symbolIndex][0] >=7)
         {
         st1 = "(VG)";
         stt1 +=1;
         }
         else
         {
         st1 = "(G)";
         stt1 +=1;
         }
         }
         else
         {
         
         if (firstS[symbolIndex][0] <=2)
         {
         st1 = "(VB)";
         stt1 -=1;
         }
         else
         {
         st1 = "(B)";
         stt1 -=1;
         }           
         
         
         
         }
         if (secondS[symbolIndex][0] <=4)
         {
         if (secondS[symbolIndex][0] <=2)
         {
         st2 = "(VG)";
         stt2 +=1;
         }
         else
         {
         st2 = "(G)";
         stt2 +=1;
         }
         }
         else
         {
         st2 = "(B)";
         stt2 -=1;
         }
         }  
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      string firstc = StringSubstr(symbol, 0, 3);
      string lastc = StringSubstr(symbol, 3, 3); 
      
      
      stt=stt1+stt2;
      
         if(useDashboard==Yes)
           {
            string message=symbol+" "+timeFrameName+pivotLevelName+" @ "+DoubleToString(SymbolInfoDouble(symbol,SYMBOL_BID),(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
            ListLabels(symbol,message,pivotLevelName);
           }

         //string messageAlert=symbol+" "+timeFrameName+pivotLevelName+" "+crossedMessage+" @ "+DoubleToString(SymbolInfoDouble(symbol,SYMBOL_BID),(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS))+"\n"+EnumToString(pivotSelection);
       //  string messageAlert=symbol+" FVG "+pType+". Entry is: "+DoubleToString(pEntry,(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS))+". SL is: "+DoubleToString(pSL,(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS))+". ";
         string messageAlert=symbol+" FVG "+pType+". "+firstc+": "+firstS[symbolIndex][0]+st1+", "+lastc+": "+secondS[symbolIndex][0]+st2+". "+"Score: "+stt+". ";

         
         if(popupAlerts==Yes)
           {
            Alert(messageAlert);
           }
         if(notificationAlerts==Yes)
           {
            SendNotification(messageAlert);
           }
         if(emailAlerts==Yes)
           {
            SendMail(messageAlert,messageAlert);
           }
        
  }
  
   
  //handles the alerts
void doAlertFVG2(string symbol,string timeFrameName,string pivotLevelName, int bb, int symbolIndex, double power, datetime power2)//handles all the alert messages
  {
string st1;
string st2;

int stt1=0;
int stt2=0;
int stt=0;

double kamadd1,kamadu1,kamadd2,kamadu2;
string pTypeD;
 kamadu1=iCustom(symbol,PERIOD_D1,"Limaocanfly\\KAMA V1.6",7,1);
   kamadd1=iCustom(symbol,PERIOD_D1,"Limaocanfly\\KAMA V1.6",8,1);
   kamadu2=iCustom(symbol,PERIOD_D1,"Limaocanfly\\KAMA V1.6",7,2);
   kamadd2=iCustom(symbol,PERIOD_D1,"Limaocanfly\\KAMA V1.6",8,2);

 if (kamadd1 == iHigh(symbol, PERIOD_D1, 1) )
    {
    if (kamadd2 == iHigh(symbol, PERIOD_D1, 2) )
    {
           pTypeD="-1";
    }
    else
    {
           pTypeD="0";
    }
    }
    
    

 if (kamadu1 == iLow(symbol, PERIOD_D1, 1) )
    {
    if (kamadu2 == iLow(symbol, PERIOD_D1, 2) )
    {
           pTypeD="1";
    }
    else
    {
           pTypeD="0";
    }
    }
    







         if (bb == 1)
         {
         pEntry = iLow(symbol,PERIOD_M15,1);
         pSL = iLow(symbol,PERIOD_M15,3);
         pType = " ^";
         
         /*
         currencystrength(pivotTimeframe,firstS,secondS,firstSV,secondSV,1,symbolIndex,symbol);
         if (firstS[symbolIndex][0] <=4)
         {
         if (firstS[symbolIndex][0] <=2)
         {
         st1 = "(VB)";
         stt1 -=4;
         }
         else
         {
         st1 = "(B)";
         stt1 -=3;
         }
         }
         else
         {
         
         if (firstS[symbolIndex][0] >=7)
         {
         st1 = "(VG)";
         stt1 +=2;
         
         if (firstS[symbolIndex][0] ==8)
         {
         st1 = "(VGG)";
         stt1 +=2;         
         
         }
         
         
         if (firstSV[symbolIndex][0] >=50)
         {
         stt1 -=20;
         }
         
         
         }
         else
         {
         st1 = "(G)";
         stt1 +=1;
         
         if (firstSV[symbolIndex][0] >=50)
         {
         stt1 -=20;
         }
         
         }         

         }
         
         if (secondS[symbolIndex][0] >=5)
         {
         if (secondS[symbolIndex][0] >=7)
         {
         st2 = "(VB)";
         stt2 -=4;
         }
         else
         {
         st2 = "(B)";
         stt2 -=3;
         }
         }
         else
         {
         

         if (secondS[symbolIndex][0] <=2)
         {
         st2 = "(VG)";
         stt2 +=2;
         
         if (secondS[symbolIndex][0] ==1)      
         st2 = "(VGG)";
         stt2 +=2;
         
         
         if (secondSV[symbolIndex][0] <=50)         
         {
         stt2 -=20;
         }         
         
         
         }
         else
         {
         st2 = "(G)";
         stt2 +=1;
         
         if (secondSV[symbolIndex][0] <=50)         
         {
         stt2 -=20;
         }  
         }                  
         
     


         }
         
         
         
         
         
         */
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         }
         
         
         
         
         
         
         if (bb == -1)
         {
         pEntry = iHigh(symbol,PERIOD_M15,1);
         pSL = iHigh(symbol,PERIOD_M15,3);
         pType = " v";
         
         /*
         
         currencystrength(pivotTimeframe,firstS,secondS,firstSV,secondSV,-1,symbolIndex,symbol);
         if (firstS[symbolIndex][0] >=5)
         {
         if (firstS[symbolIndex][0] >=7)
         {
         st1 = "(VB)";
         stt1 -=4;
         }
         else
         {
         st1 = "(B)";
         stt1 -=3;
         }
         }
         else
         {
         
         if (firstS[symbolIndex][0] <=2)
         {
         st1 = "(VG)";
         stt1 +=2;
         
         if (firstS[symbolIndex][0] ==1)         
         {
         st1 = "(VGG)";
         stt1 +=2;
         
         if (firstSV[symbolIndex][0] <=50)
         {
         stt1 -=20;
         }         
         
         }
         }
         else
         {
         st1 = "(G)";
         stt1 +=1;
         
         
         if (firstSV[symbolIndex][0] <=50)
         {
         stt1 -=20;
         } 
         }           
         
         
         
         }
         if (secondS[symbolIndex][0] <=4)
         {
         if (secondS[symbolIndex][0] <=2)
         {
         st2 = "(VB)";
         stt2 -=4;
         }
         else
         {
         st2 = "(B)";
         stt2 -=3;
         }
         }
         else
         if (secondS[symbolIndex][0] >=7)
         {
         st2 = "(VG)";
         stt2 +=2;
         
         if (secondS[symbolIndex][0] ==8)         
         st2 = "(VGG)";
         stt2 +=2;     
         
         if (secondSV[symbolIndex][0] >=50)            
         {
         stt2 -=20;
         }              
         
         }
         else
         {
         st2 = "(G)";
         stt2 +=1;
         
         
         if (secondSV[symbolIndex][0] >=50)            
         {
         stt2 -=20;
         }              
         
         }           
         */
         
         }  
      
     // string firstc = StringSubstr(symbol, 0, 3);
     // string lastc = StringSubstr(symbol, 3, 3); 
      
      power = NormalizeDouble(power,5);
      //stt=stt1+stt2;
      
         if(useDashboard==Yes)
           {
            string message=symbol+" "+timeFrameName+pivotLevelName+" @ "+DoubleToString(SymbolInfoDouble(symbol,SYMBOL_BID),(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
            ListLabels(symbol,message,pivotLevelName);
           }

         //string messageAlert=symbol+" "+timeFrameName+pivotLevelName+" "+crossedMessage+" @ "+DoubleToString(SymbolInfoDouble(symbol,SYMBOL_BID),(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS))+"\n"+EnumToString(pivotSelection);
       //  string messageAlert=symbol+" FVG "+pType+". Entry is: "+DoubleToString(pEntry,(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS))+". SL is: "+DoubleToString(pSL,(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS))+". ";
       //  string messageAlert=symbol+" FVG "+pType+". "+firstc+": "+firstS[symbolIndex][0]+st1+", "+lastc+": "+secondS[symbolIndex][0]+st2+". "+"Score: "+stt+". V: "+power+". "; last known good config
         string timepower;
          timepower = TimeToString(power2, TIME_SECONDS | TIME_DATE);
        //  string messageAlert=symbol+pType+"S:"+power+","+timepower+"(SMC1H)"+"D: "+pTypeD+"|S:"+stt+"|"+firstc+":"+firstS[symbolIndex][0]+st1+","+lastc+":"+secondS[symbolIndex][0]+st2;
            //string messageAlert=symbol+pType+" (15M) S:"+power+","+timepower+"(SMC1H)";
           string messageAlert=symbol+pType+" (15M) S:"+power+","+timepower;
         
         if(popupAlerts==Yes)
           {
            Alert(messageAlert);
           }
         if(notificationAlerts==Yes)
           {
            SendNotification(messageAlert);
           }
         if(emailAlerts==Yes)
           {
            SendMail(messageAlert,messageAlert);
           }
        
  }
  
  //handles the alerts
void doAlertFVG1(string symbol,string timeFrameName,string pivotLevelName, int bb, int symbolIndex, double power)//handles all the alert messages
  {
string st1;
string st2;

int stt1=0;
int stt2=0;
int stt=0;

double kamadd1,kamadu1,kamadd2,kamadu2;
string pTypeD;
 kamadu1=iCustom(symbol,PERIOD_D1,"Limaocanfly\\KAMA V1.6",7,1);
   kamadd1=iCustom(symbol,PERIOD_D1,"Limaocanfly\\KAMA V1.6",8,1);
   kamadu2=iCustom(symbol,PERIOD_D1,"Limaocanfly\\KAMA V1.6",7,2);
   kamadd2=iCustom(symbol,PERIOD_D1,"Limaocanfly\\KAMA V1.6",8,2);

 if (kamadd1 == iHigh(symbol, PERIOD_D1, 1) )
    {
    if (kamadd2 == iHigh(symbol, PERIOD_D1, 2) )
    {
           pTypeD="-1";
    }
    else
    {
           pTypeD="0";
    }
    }
    
    

 if (kamadu1 == iLow(symbol, PERIOD_D1, 1) )
    {
    if (kamadu2 == iLow(symbol, PERIOD_D1, 2) )
    {
           pTypeD="1";
    }
    else
    {
           pTypeD="0";
    }
    }
    







         if (bb == 1)
         {
         pEntry = iLow(symbol,PERIOD_M15,1);
         pSL = iLow(symbol,PERIOD_M15,3);
         pType = " ^";
         currencystrength(pivotTimeframe,firstS,secondS,firstSV,secondSV,1,symbolIndex,symbol);
         if (firstS[symbolIndex][0] <=4)
         {
         if (firstS[symbolIndex][0] <=2)
         {
         st1 = "(VB)";
         stt1 -=4;
         }
         else
         {
         st1 = "(B)";
         stt1 -=3;
         }
         }
         else
         {
         
         if (firstS[symbolIndex][0] >=7)
         {
         st1 = "(VG)";
         stt1 +=2;
         
         if (firstS[symbolIndex][0] ==8)
         {
         st1 = "(VGG)";
         stt1 +=2;         
         
         }
         
         
         if (firstSV[symbolIndex][0] >=50)
         {
         stt1 -=20;
         }
         
         
         }
         else
         {
         st1 = "(G)";
         stt1 +=1;
         
         if (firstSV[symbolIndex][0] >=50)
         {
         stt1 -=20;
         }
         
         }         

         }
         
         if (secondS[symbolIndex][0] >=5)
         {
         if (secondS[symbolIndex][0] >=7)
         {
         st2 = "(VB)";
         stt2 -=4;
         }
         else
         {
         st2 = "(B)";
         stt2 -=3;
         }
         }
         else
         {
         

         if (secondS[symbolIndex][0] <=2)
         {
         st2 = "(VG)";
         stt2 +=2;
         
         if (secondS[symbolIndex][0] ==1)      
         st2 = "(VGG)";
         stt2 +=2;
         
         
         if (secondSV[symbolIndex][0] <=50)         
         {
         stt2 -=20;
         }         
         
         
         }
         else
         {
         st2 = "(G)";
         stt2 +=1;
         
         if (secondSV[symbolIndex][0] <=50)         
         {
         stt2 -=20;
         }  
         }                  
         
     


         }
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         }
         
         
         
         
         
         
         if (bb == -1)
         {
         pEntry = iHigh(symbol,PERIOD_M15,1);
         pSL = iHigh(symbol,PERIOD_M15,3);
         pType = " v";
         currencystrength(pivotTimeframe,firstS,secondS,firstSV,secondSV,-1,symbolIndex,symbol);
         if (firstS[symbolIndex][0] >=5)
         {
         if (firstS[symbolIndex][0] >=7)
         {
         st1 = "(VB)";
         stt1 -=4;
         }
         else
         {
         st1 = "(B)";
         stt1 -=3;
         }
         }
         else
         {
         
         if (firstS[symbolIndex][0] <=2)
         {
         st1 = "(VG)";
         stt1 +=2;
         
         if (firstS[symbolIndex][0] ==1)         
         {
         st1 = "(VGG)";
         stt1 +=2;
         
         if (firstSV[symbolIndex][0] <=50)
         {
         stt1 -=20;
         }         
         
         }
         }
         else
         {
         st1 = "(G)";
         stt1 +=1;
         
         
         if (firstSV[symbolIndex][0] <=50)
         {
         stt1 -=20;
         } 
         }           
         
         
         
         }
         if (secondS[symbolIndex][0] <=4)
         {
         if (secondS[symbolIndex][0] <=2)
         {
         st2 = "(VB)";
         stt2 -=4;
         }
         else
         {
         st2 = "(B)";
         stt2 -=3;
         }
         }
         else
         if (secondS[symbolIndex][0] >=7)
         {
         st2 = "(VG)";
         stt2 +=2;
         
         if (secondS[symbolIndex][0] ==8)         
         st2 = "(VGG)";
         stt2 +=2;     
         
         if (secondSV[symbolIndex][0] >=50)            
         {
         stt2 -=20;
         }              
         
         }
         else
         {
         st2 = "(G)";
         stt2 +=1;
         
         
         if (secondSV[symbolIndex][0] >=50)            
         {
         stt2 -=20;
         }              
         
         }           
         
         
         }  
      
      string firstc = StringSubstr(symbol, 0, 3);
      string lastc = StringSubstr(symbol, 3, 3); 
      
      power = NormalizeDouble(power,5);
      stt=stt1+stt2;
      
         if(useDashboard==Yes)
           {
            string message=symbol+" "+timeFrameName+pivotLevelName+" @ "+DoubleToString(SymbolInfoDouble(symbol,SYMBOL_BID),(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
            ListLabels(symbol,message,pivotLevelName);
           }

         //string messageAlert=symbol+" "+timeFrameName+pivotLevelName+" "+crossedMessage+" @ "+DoubleToString(SymbolInfoDouble(symbol,SYMBOL_BID),(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS))+"\n"+EnumToString(pivotSelection);
       //  string messageAlert=symbol+" FVG "+pType+". Entry is: "+DoubleToString(pEntry,(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS))+". SL is: "+DoubleToString(pSL,(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS))+". ";
       //  string messageAlert=symbol+" FVG "+pType+". "+firstc+": "+firstS[symbolIndex][0]+st1+", "+lastc+": "+secondS[symbolIndex][0]+st2+". "+"Score: "+stt+". V: "+power+". "; last known good config
          
          string messageAlert=symbol+pType+"(15M)"+"D: "+pTypeD+"|S:"+stt+"|"+firstc+":"+firstS[symbolIndex][0]+st1+","+lastc+":"+secondS[symbolIndex][0]+st2+"|V:"+power;
         
         if(popupAlerts==Yes)
           {
            Alert(messageAlert);
           }
         if(notificationAlerts==Yes)
           {
            SendNotification(messageAlert);
           }
         if(emailAlerts==Yes)
           {
            SendMail(messageAlert,messageAlert);
           }
        
  }
  
  
  
//do alert for bounce
void doAlertBounce(string symbolName,string ppTimeFrame,string PivotName,char rOrS)
  {
   datetime timeOfAlert=NULL;
   if(useDashboard==Yes)
     {
      if(timeChoiceOption==Local)
        {
         timeOfAlert=TimeLocal();
        }
      else
         if(timeChoiceOption==Server)
           {
            timeOfAlert=TimeCurrent();
           }

      TimeOfAlertLabelUpdate(symbolName,timeOfAlert,PivotName);
     }

   if('R'==rOrS)
     {
      if(showBidPriceOnAlert==No)
        {
         if(useDashboard==Yes)
           {
            string message=symbolName+" "+ppTimeFrame+PivotName+" " + offResistanceBounceMSG;
            ListLabels(symbolName,message,PivotName);
           }

         string messageAlert=symbolName+" "+ppTimeFrame+PivotName+" " + offResistanceBounceMSG+"\n" + EnumToString(pivotSelection) + " " +EnumToString(bouncedCandleTF);
         if(popupAlerts==Yes)
           {
            Alert(messageAlert);
           }
         if(notificationAlerts==Yes)
           {
            SendNotification(messageAlert);
           }
         if(emailAlerts==Yes)
           {
            SendMail(messageAlert,messageAlert);
           }
        }
      else
        {
         if(useDashboard==Yes)
           {
            string message=symbolName+" "+ppTimeFrame+PivotName+" " + offResistanceBounceMSG+" @ "+DoubleToString(SymbolInfoDouble(symbolName,SYMBOL_BID),(int)SymbolInfoInteger(symbolName,SYMBOL_DIGITS));
            ListLabels(symbolName,message,PivotName);
           }

         string messageAlert=symbolName+" "+ppTimeFrame+PivotName+" " + offResistanceBounceMSG+" @ "+DoubleToString(SymbolInfoDouble(symbolName,SYMBOL_BID),(int)SymbolInfoInteger(symbolName,SYMBOL_DIGITS))+"\n" + EnumToString(pivotSelection) + " " +EnumToString(bouncedCandleTF);
         if(popupAlerts==Yes)
           {
            Alert(messageAlert);
           }
         if(notificationAlerts==Yes)
           {
            SendNotification(messageAlert);
           }
         if(emailAlerts==Yes)
           {
            SendMail(messageAlert,messageAlert);
           }
        }
     }
   if('S'==rOrS)
     {
      if(showBidPriceOnAlert==No)
        {
         if(useDashboard==Yes)
           {
            string message=symbolName+" "+ppTimeFrame+PivotName+" " + offSupportBounceMSG;
            ListLabels(symbolName,message,PivotName);
           }

         string messageAlert=symbolName+" "+ppTimeFrame+PivotName+" " + offSupportBounceMSG+"\n" + EnumToString(pivotSelection) + " " +EnumToString(bouncedCandleTF);
         if(popupAlerts==Yes)
           {
            Alert(messageAlert);
           }
         if(notificationAlerts==Yes)
           {
            SendNotification(messageAlert);
           }
         if(emailAlerts==Yes)
           {
            SendMail(messageAlert,messageAlert);
           }
        }
      else
        {
         if(useDashboard==Yes)
           {
            string message=symbolName+" "+ppTimeFrame+PivotName+" " + offSupportBounceMSG+" @ "+DoubleToString(SymbolInfoDouble(symbolName,SYMBOL_BID),(int)SymbolInfoInteger(symbolName,SYMBOL_DIGITS));
            ListLabels(symbolName,message,PivotName);
           }

         string messageAlert=symbolName+" "+ppTimeFrame+PivotName+" " + offSupportBounceMSG+" @ "+DoubleToString(SymbolInfoDouble(symbolName,SYMBOL_BID),(int)SymbolInfoInteger(symbolName,SYMBOL_DIGITS))+"\n" + EnumToString(pivotSelection) + " " +EnumToString(bouncedCandleTF);
         if(popupAlerts==Yes)
           {
            Alert(messageAlert);
           }
         if(notificationAlerts==Yes)
           {
            SendNotification(messageAlert);
           }
         if(emailAlerts==Yes)
           {
            SendMail(messageAlert,messageAlert);
           }
        }
     }
  }
//standard pivot point formula
void standardPivotPoint(ENUM_TIMEFRAMES timeFrame,double &ppArrayRef[][],int symbolIndex,string symbolName)//the formula for the standard floor pivot points
  {
  
   int shift=1;
   /*
   Returned value
   The zero-based day of week (0 means Sunday,1,2,3,4,5,6) of the specified date.
   */
   if(timeFrame==PERIOD_D1)
     {
      datetime dayCheck1=iTime(symbolName,PERIOD_D1,shift);
      if(TimeDayOfWeek(dayCheck1) == 0)//found sunday - skip over
        {
         shift+=1;
        }

      datetime dayCheck2=iTime(symbolName,PERIOD_D1,shift);
      if(TimeDayOfWeek(dayCheck2) == 6)//found saturday - skip over
        {
         shift+=1;
        }
     }
  
   int symbolDigits=(int)MarketInfo(symbolName,MODE_DIGITS);
   double prevRange= iHigh(symbolName,timeFrame,shift)-iLow(symbolName,timeFrame,shift);
   double prevHigh = iHigh(symbolName,timeFrame,shift);
   double prevLow=iLow(symbolName,timeFrame,shift);
   double prevClose=iClose(symbolName,timeFrame,shift);
   double PP = (prevHigh+prevLow+prevClose)/3;
   double R1 = (PP * 2)-prevLow;
   double S1 = (PP * 2)-prevHigh;
   double R2 = PP + prevHigh - prevLow;
   double S2 = PP - prevHigh + prevLow;
   double R3 = R1 + (prevHigh-prevLow);
   double S3 = prevLow - 2 * (prevHigh-PP);
   double R4 = R3+(R2-R1);
   double S4 = S3-(S1-S2);
   double R5 = R4+(R3-R2);
   double S5 = S4-(S2-S3);
   double R6 = R5+(R4-R3);
   double S6 = S5-(S3-S4);
   ppArrayRef[symbolIndex][0]=PP;
   ppArrayRef[symbolIndex][1]=S1;
   ppArrayRef[symbolIndex][2]=S2;
   ppArrayRef[symbolIndex][3]=S3;
   ppArrayRef[symbolIndex][4]=R1;
   ppArrayRef[symbolIndex][5]=R2;
   ppArrayRef[symbolIndex][6]=R3;
   ppArrayRef[symbolIndex][7]=R4;
   ppArrayRef[symbolIndex][8]=S4;
   ppArrayRef[symbolIndex][9]=R5;
   ppArrayRef[symbolIndex][10]=S5;
   ppArrayRef[symbolIndex][11]=R6;
   ppArrayRef[symbolIndex][12]=S6;
   if(MidPointAlerts==Enable)
     {
      //mid pivots
      ppArrayRef[symbolIndex][13]=(R3+R4)/2;
      ppArrayRef[symbolIndex][14]=(R2+R3)/2;
      ppArrayRef[symbolIndex][15]=(R1+R2)/2;
      ppArrayRef[symbolIndex][16]=(PP+R1)/2;
      ppArrayRef[symbolIndex][17]=(PP+S1)/2;
      ppArrayRef[symbolIndex][18]=(S1+S2)/2;
      ppArrayRef[symbolIndex][19]=(S2+S3)/2;
      ppArrayRef[symbolIndex][20]=(S3+S4)/2;
     }
//if enable mid point alert get all the midpoint and label array for standard pivot points only day week month
  }
  
  
    
//NEW: calculate TR &DA
void calculatetrda(ENUM_TIMEFRAMES timeFrame,double &trdaArrayRef[][],int symbolIndex,string symbolName)
 {


   int shift=1;
   /*
   Returned value
   The zero-based day of week (0 means Sunday,1,2,3,4,5,6) of the specified date.
   */
   if(timeFrame==PERIOD_D1)
     {
      datetime dayCheck1=iTime(symbolName,PERIOD_D1,shift);
      if(TimeDayOfWeek(dayCheck1) == 0)//found sunday - skip over
        {
         shift+=1;
        }

      datetime dayCheck2=iTime(symbolName,PERIOD_D1,shift);
      if(TimeDayOfWeek(dayCheck2) == 6)//found saturday - skip over
        {
         shift+=1;
        }
     }

   int symbolDigits=(int)MarketInfo(symbolName,MODE_DIGITS);
   double da = ((iHigh(symbolName, timeFrame, 0) - iLow(symbolName, timeFrame, 0)) + (iHigh(symbolName, timeFrame, 1) - iLow(symbolName, timeFrame, 1)) + (iHigh(symbolName, timeFrame, 2) - iLow(symbolName, timeFrame, 2)) + (iHigh(symbolName, timeFrame, 3) - iLow(symbolName, timeFrame, 3)) + (iHigh(symbolName, timeFrame, 4) - iLow(symbolName, timeFrame, 4)) + (iHigh(symbolName, timeFrame, 5) - iLow(symbolName, timeFrame, 5)) + (iHigh(symbolName, timeFrame, 6) - iLow(symbolName, timeFrame, 6)) + (iHigh(symbolName, timeFrame, 7) - iLow(symbolName, timeFrame, 7)) + (iHigh(symbolName, timeFrame, 8) - iLow(symbolName, timeFrame, 8)) + (iHigh(symbolName, timeFrame, 9) - iLow(symbolName, timeFrame, 9)) + (iHigh(symbolName, timeFrame, 10) - iLow(symbolName, timeFrame, 10)) + (iHigh(symbolName, timeFrame, 11) - iLow(symbolName, timeFrame, 11)) + (iHigh(symbolName, timeFrame, 12) - iLow(symbolName, timeFrame, 12)) + 
(iHigh(symbolName, timeFrame, 13) - iLow(symbolName, timeFrame, 13)) + (iHigh(symbolName, timeFrame, 14) - iLow(symbolName, timeFrame, 14)) + (iHigh(symbolName, timeFrame, 15) - iLow(symbolName, timeFrame, 15)) + (iHigh(symbolName, timeFrame, 16) - iLow(symbolName, timeFrame, 16)) + (iHigh(symbolName, timeFrame, 17) - iLow(symbolName, timeFrame, 17)) + (iHigh(symbolName, timeFrame, 18) - iLow(symbolName, timeFrame, 18)) + (iHigh(symbolName, timeFrame, 19) - iLow(symbolName, timeFrame, 19)) + (iHigh(symbolName, timeFrame, 20) - iLow(symbolName, timeFrame, 20)) + (iHigh(symbolName, timeFrame, 21) - iLow(symbolName, timeFrame, 21)) + (iHigh(symbolName, timeFrame, 22) - iLow(symbolName, timeFrame, 22)) + (iHigh(symbolName, timeFrame, 23) - iLow(symbolName, timeFrame, 23)) + (iHigh(symbolName, timeFrame, 24) - iLow(symbolName, timeFrame, 24)) + (iHigh(symbolName, timeFrame, 25) - iLow(symbolName, timeFrame, 25)) + (iHigh(symbolName, timeFrame, 26) - iLow(symbolName, timeFrame, 26)) + (iHigh(symbolName, timeFrame, 27) - iLow(symbolName, timeFrame, 27)) + (iHigh(symbolName, timeFrame, 28) - iLow(symbolName, timeFrame, 28)) + (iHigh(symbolName, timeFrame, 29) - iLow(symbolName, timeFrame, 29))  
) / 30;
   double tr = iHigh(symbolName, timeFrame, 0) - iLow(symbolName, timeFrame, 0);
   trdaArrayRef[symbolIndex][0]=tr-da;
 }

void calculatekama(ENUM_TIMEFRAMES timeFrame,double &FVGArrayRef[][],int symbolIndex,string symbolName)
 {




  for (int j = 500; j > 1; j--)
    {

    if((iLow(symbolName,0,j) > iHigh(symbolName,0,j+2)) && (iClose(symbolName,0,j+1)>iHigh(symbolName,0,j+2)))
    {
    bullOBup[symbolIndex][j+2] = iLow(symbolName,0,j);
    bullOBdown[symbolIndex][j+2] =iLow(symbolName,0,j+2);
    bullOBtime[symbolIndex][j+2] =iTime(symbolName,0,j+2);
   // Print("Formatted TimeA: ", TimeToString(bullOBtime[symbolIndex][j+2],TIME_SECONDS | TIME_DATE));
    }
    
    if((iHigh(symbolName,0,j) < iLow(symbolName,0,j+2)) && (iClose(symbolName,0,j+1) < iLow(symbolName,0,j+2)))
    {
    bearOBup[symbolIndex][j+2] =iHigh(symbolName,0,j+2);
    bearOBdown[symbolIndex][j+2] =iHigh(symbolName,0,j);
    bearOBtime[symbolIndex][j+2] =iTime(symbolName,0,j+2);
    }    
       
    }




    for (int i = 0; i < 500+2; i++)
    {
    if ( bearOBup[symbolIndex][i] >0)
    {
    double tempup = bearOBup[symbolIndex][i];
    double tempdown = bearOBdown[symbolIndex][i];
    for (int  h = 1; h<i-2; h++)
    {
    if (iHigh(symbolName,0,h)>=tempup)
    {
    bearOBup[symbolIndex][i] =0;
    bearOBdown[symbolIndex][i] =0;
    bearOBtime[symbolIndex][i] =0;
    }
    }
    }
    
    if ( bullOBup[symbolIndex][i] >0)
    {
    double temp2up = bullOBup[symbolIndex][i];
    double temp2down = bullOBdown[symbolIndex][i];
    for (int  g = 1; g<i-2; g++)
    {
    if (iLow(symbolName,0,g)<=temp2down)
    {
    bullOBup[symbolIndex][i] =0;
    bullOBdown[symbolIndex][i] =0;
    bullOBtime[symbolIndex][i] =0;
    }
    }
    }
    
    }



    for (int f = 0; f < 500; f++)
    {
   // if (((iClose(symbolName,0,0)< bearOBup[symbolIndex][f]) &&(iClose(symbolName,0,0)> bearOBdown[symbolIndex][f])))
    if ((iHigh(symbolName,0,0)>= bearOBup[symbolIndex][f]) && (iOpen(symbolName,0,0)<bearOBup[symbolIndex][f] || iClose(symbolName,0,1)<bearOBup[symbolIndex][f] ))
    {


    //string alertMessage = Symbol() + ": Price into Bear FVG";
   // Alert(alertMessage);
   // SendNotification(alertMessage);

       FVGArrayRef[symbolIndex][0]=1;
       FVGArrayRef[symbolIndex][1]=bearOBup[symbolIndex][f];
       FVGArrayRef[symbolIndex][2]=bearOBtime[symbolIndex][f];
       break;
    }
    }
    
   for (int e = 0; e < 500; e++)
    {
    //if (((iClose(symbolName,0,0)< bullOBup[symbolIndex][f]) &&(iClose(symbolName,0,0)> bullOBdown[symbolIndex][f])))
    if (iLow(symbolName,0,0)<= bullOBdown[symbolIndex][e]&& (iOpen(symbolName,0,0)>bullOBdown[symbolIndex][e] || iClose(symbolName,0,1)>bullOBdown[symbolIndex][e] ))
    {
   
  
    //string alertMessage1 = Symbol() + ": Price into Bull FVG";
    //Alert(alertMessage1);
   // SendNotification(alertMessage1);
       FVGArrayRef[symbolIndex][0]=-1;
       FVGArrayRef[symbolIndex][1]=bullOBdown[symbolIndex][e];
       FVGArrayRef[symbolIndex][2]=bullOBtime[symbolIndex][e];
    break;
    }
    
    
    
    }






     
     
         
  
  

 }
 
 
void currencystrength(ENUM_TIMEFRAMES timeFrame,int &first[][],int &last[][],double &firstV[][],double &lastV[][],int bb,int symbolIndex,string symbolName)
 {
 
 
CurrStrength[0]="EUR";
CurrStrength[1]="USD";
CurrStrength[2]="GBP";
CurrStrength[3]="AUD";
CurrStrength[4]="NZD";
CurrStrength[5]="CHF";
CurrStrength[6]="CAD";
CurrStrength[7]="JPY";
 
 
 ExtStrength[0] = (iRSI("EURUSD",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1)
+iRSI("EURGBP",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1)
+iRSI("EURAUD",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1)
+iRSI("EURCHF",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1)
+iRSI("EURCAD",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1)
+iRSI("EURNZD",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1)
+iRSI("EURJPY",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1))/7;

ExtStrength[1] = ((100-iRSI("AUDUSD",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1))
+(100-iRSI("GBPUSD",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1))
+(100-iRSI("EURUSD",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1))
+iRSI("USDCHF",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1)
+iRSI("USDCAD",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1)
+iRSI("USDJPY",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1)
+(100-iRSI("NZDUSD",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1)))/7;

ExtStrength[2] = (iRSI("GBPUSD",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1)
+iRSI("GBPCHF",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1)
+iRSI("GBPCAD",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1)
+iRSI("GBPAUD",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1)
+iRSI("GBPJPY",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1)
+iRSI("GBPNZD",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1)
+(100-iRSI("EURGBP",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1)))/7;

ExtStrength[3]= ((100-iRSI("EURAUD",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1))
+iRSI("AUDUSD",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1)
+(100-iRSI("GBPAUD",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1))
+iRSI("AUDNZD",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1)
+iRSI("AUDCHF",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1)
+iRSI("AUDJPY",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1)
+iRSI("AUDCAD",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1))/7;

ExtStrength[4] = ((100-iRSI("AUDNZD",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1))
+(100-iRSI("GBPNZD",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1))
+iRSI("NZDUSD",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1)
+(100-iRSI("EURNZD",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1))
+iRSI("NZDCHF",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1)
+iRSI("NZDJPY",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1)
+iRSI("NZDCAD",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1))/7;

ExtStrength[5] = ((100-iRSI("EURCHF",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1))
+(100-iRSI("NZDCHF",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1))
+(100-iRSI("AUDCHF",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1))
+(100-iRSI("GBPCHF",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1))
+(100-iRSI("USDCHF",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1))
+iRSI("CHFJPY",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1)
+(100-iRSI("CADCHF",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1)))/7;

ExtStrength[6] = (iRSI("CADCHF",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1)
+(100-iRSI("NZDCAD",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1))
+(100-iRSI("AUDCAD",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1))
+(100-iRSI("GBPCAD",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1))
+(100-iRSI("USDCAD",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1))
+iRSI("CADJPY",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1)
+(100-iRSI("EURCAD",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1)))/7;

ExtStrength[7]= ((100-iRSI("EURJPY",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1))
+(100-iRSI("USDJPY",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1))
+(100-iRSI("GBPJPY",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1))
+(100-iRSI("CHFJPY",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1))
+(100-iRSI("CADJPY",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1))
+(100-iRSI("AUDJPY",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1))
+(100-iRSI("NZDJPY",PERIOD_H1,InpRSIPeriod,PRICE_CLOSE,1)))/7;
 

 for(int i=0; i<8; i++)
     {
      indexmap[i][0]=ExtStrength[i];
      indexmap[i][1]=i;
     }

 
 ArraySort(indexmap,WHOLE_ARRAY,0,MODE_DESCEND);
 
 
  for(int i=0; i<8; i++)
     {
     AfCurrStrength[i] = CurrStrength[(int)indexmap[i][1]];
    AfExtStrength[i] = indexmap[i][0];
     //Print(AfCurrStrength[i],AfExtStrength[i] ); 
     }
     
 string firstc = StringSubstr(symbolName, 0, 3);
 string lastc = StringSubstr(symbolName, 3, 3);
 
 
  
 for(int i=0; i<8; i++)
     {
     if (firstc == AfCurrStrength[i])
     {
     first[symbolIndex][0] = i+1;
     firstV[symbolIndex][0] = AfExtStrength[i];
     }      
     if (lastc == AfCurrStrength[i])
     {
     last[symbolIndex][0] = i+1;
     lastV[symbolIndex][0] = AfExtStrength[i];
     }       
     
     
     
     }

 
 //definefurther 
 
   
   
 }
 


  
  
  
  
  //NEW: calculateFVG
void calculateFVG(ENUM_TIMEFRAMES timeFrame,double &FVGArrayRef[][],int symbolIndex,string symbolName)
 {
FVGArrayRef[symbolIndex][0]=0;



   
   
   
   if(iLow(symbolName,PERIOD_M15,1)>iHigh(symbolName,PERIOD_M15,3) && iClose(symbolName,PERIOD_M15,2)>iHigh(symbolName,PERIOD_M15,3))
   {
   
 //BullFVG 15M here
         for(int l=1 ; l<24; l++)
        {
        if(iMA(symbolName,PERIOD_M5,50,0,MODE_SMA,PRICE_CLOSE,l)>iMA(symbolName,PERIOD_M5,20,0,MODE_SMA,PRICE_CLOSE,l) && iOpen(symbolName,PERIOD_M5,l)<iMA(symbolName,PERIOD_M5,20,0,MODE_SMA,PRICE_CLOSE,l) && iClose(symbolName,PERIOD_M5,l)>iMA(symbolName,PERIOD_M5,20,0,MODE_SMA,PRICE_CLOSE,l))
        {
        FVGArrayRef[symbolIndex][0]+=1;
        }
        }
   
   }
   
   
   if(iHigh(symbolName,PERIOD_M15,1)<iLow(symbolName,PERIOD_M15,3) && iClose(symbolName,PERIOD_M15,2)<iLow(symbolName,PERIOD_M15,3))
   {
   //BearFVG 15M here
         for(int l=1 ; l<24; l++)
        {
        if(iMA(symbolName,PERIOD_M5,50,0,MODE_SMA,PRICE_CLOSE,l)<iMA(symbolName,PERIOD_M5,20,0,MODE_SMA,PRICE_CLOSE,l) && iOpen(symbolName,PERIOD_M5,l)>iMA(symbolName,PERIOD_M5,20,0,MODE_SMA,PRICE_CLOSE,l) && iClose(symbolName,PERIOD_M5,l)<iMA(symbolName,PERIOD_M5,20,0,MODE_SMA,PRICE_CLOSE,l))
        {
        FVGArrayRef[symbolIndex][0]-=1;
        }
        }
   }
      
   
   
   
   
 }

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
//camarilla formula
void camarillaPivotPoint(ENUM_TIMEFRAMES timeFrame,double &ppArrayRef[][],int symbolIndex,string symbolName)//camrilla pivot point formula
  {
   int shift=1;
   /*
   Returned value
   The zero-based day of week (0 means Sunday,1,2,3,4,5,6) of the specified date.
   */
   if(timeFrame==PERIOD_D1)
     {
      datetime dayCheck1=iTime(symbolName,PERIOD_D1,shift);
      if(TimeDayOfWeek(dayCheck1) == 0)//found sunday - skip over
        {
         shift+=1;
        }

      datetime dayCheck2=iTime(symbolName,PERIOD_D1,shift);
      if(TimeDayOfWeek(dayCheck2) == 6)//found saturday - skip over
        {
         shift+=1;
        }
     }
  
   double camRange= iHigh(symbolName,timeFrame,shift)-iLow(symbolName,timeFrame,shift);
   double prevHigh=iHigh(symbolName,timeFrame,shift);
   double prevLow=iLow(symbolName,timeFrame,shift);
   double prevClose=iClose(symbolName,timeFrame,shift);
   int symbolDigits=(int)MarketInfo(symbolName,MODE_DIGITS);
   double R1 = ((1.1 / 12) * camRange) + prevClose;
   double R2 = ((1.1 / 6) * camRange) + prevClose;
   double R3 = ((1.1 / 4) * camRange) + prevClose;
   double R4= ((1.1/2) * camRange)+prevClose;
   double S1= prevClose -((1.1/12) * camRange);
   double S2= prevClose -((1.1/6) * camRange);
   double S3 = prevClose - ((1.1 / 4) * camRange);
   double S4 = prevClose - ((1.1 / 2) * camRange);
   double PP = (R4+S4)/2;
   double R5=((prevHigh/prevLow)*prevClose);
   double S5=(prevClose-(R5-prevClose));
   ppArrayRef[symbolIndex][0]=PP;
   ppArrayRef[symbolIndex][1]=S1;
   ppArrayRef[symbolIndex][2]=S2;
   ppArrayRef[symbolIndex][3]=S3;
   ppArrayRef[symbolIndex][4]=S4;
   ppArrayRef[symbolIndex][5]=R1;
   ppArrayRef[symbolIndex][6]=R2;
   ppArrayRef[symbolIndex][7]=R3;
   ppArrayRef[symbolIndex][8]=R4;
   ppArrayRef[symbolIndex][9]=R5;
   ppArrayRef[symbolIndex][10]=S5;
  }
//woodie formula
void woodiePivotPoint(ENUM_TIMEFRAMES timeFrame,double &ppArrayRef[][],int symbolIndex,string symbolName)//woodie pivot point formula
  {
  
   int shift=1;
   /*
   Returned value
   The zero-based day of week (0 means Sunday,1,2,3,4,5,6) of the specified date.
   */
   if(timeFrame==PERIOD_D1)
     {
      datetime dayCheck1=iTime(symbolName,PERIOD_D1,shift);
      if(TimeDayOfWeek(dayCheck1) == 0)//found sunday - skip over
        {
         shift+=1;
        }

      datetime dayCheck2=iTime(symbolName,PERIOD_D1,shift);
      if(TimeDayOfWeek(dayCheck2) == 6)//found saturday - skip over
        {
         shift+=1;
        }
     }
  
   double prevRange= iHigh(symbolName,timeFrame,shift)-iLow(symbolName,timeFrame,shift);
   double prevHigh = iHigh(symbolName,timeFrame,shift);
   double prevLow=iLow(symbolName,timeFrame,shift);
   double prevClose = iClose(symbolName, timeFrame,shift);
   double todayOpen = iOpen(symbolName, timeFrame,shift-1);
   int symbolDigits=(int)MarketInfo(symbolName,MODE_DIGITS);
   double PP = (prevHigh+prevLow+(todayOpen*2))/4;
   double R1 = (PP * 2)-prevLow;
   double R2 = PP + prevRange;
   double S1 = (PP * 2)-prevHigh;
   double S2 = PP - prevRange;
   ppArrayRef[symbolIndex][0]=PP;
   ppArrayRef[symbolIndex][1]=S1;
   ppArrayRef[symbolIndex][2]=S2;
   ppArrayRef[symbolIndex][3]=R1;
   ppArrayRef[symbolIndex][4]=R2;
  }
//fibonacci formula
void fibonacciPivotPoint(ENUM_TIMEFRAMES timeFrame,double &ppArrayRef[][],int symbolIndex,string symbolName)//fibonacchi pivot point formula
  {
  
   int shift=1;
   /*
   Returned value
   The zero-based day of week (0 means Sunday,1,2,3,4,5,6) of the specified date.
   */
   if(timeFrame==PERIOD_D1)
     {
      datetime dayCheck1=iTime(symbolName,PERIOD_D1,shift);
      if(TimeDayOfWeek(dayCheck1) == 0)//found sunday - skip over
        {
         shift+=1;
        }

      datetime dayCheck2=iTime(symbolName,PERIOD_D1,shift);
      if(TimeDayOfWeek(dayCheck2) == 6)//found saturday - skip over
        {
         shift+=1;
        }
     }
  
   double prevRange= iHigh(symbolName,timeFrame,shift)-iLow(symbolName,timeFrame,shift);
   double prevHigh = iHigh(symbolName,timeFrame,shift);
   double prevLow=iLow(symbolName,timeFrame,shift);
   double prevClose=iClose(symbolName,timeFrame,shift);
   int symbolDigits=(int)MarketInfo(symbolName,MODE_DIGITS);
   double Pivot=(prevHigh+prevLow+prevClose)/3;

//   double R38=  Pivot + ((prevRange) * 0.382);
//   double R61=  Pivot + ((prevRange) * 0.618);
//   double R78=  Pivot + ((prevRange) * 0.786);
//   double R100= Pivot + ((prevRange) * 1.000);
//   double R138= Pivot + ((prevRange) * 1.382);
//   double R161= Pivot + ((prevRange) * 1.618);
//   double R200= Pivot + ((prevRange) * 2.000);
//   double S38 = Pivot - ((prevRange) * 0.382);
//   double S61 = Pivot - ((prevRange) * 0.618);
//   double S78 = Pivot -((prevRange)  * 0.786);
//   double S100= Pivot - ((prevRange) * 1.000);
//   double S138= Pivot - ((prevRange) * 1.382);
//   double S161= Pivot - ((prevRange) * 1.618);
//   double S200= Pivot - ((prevRange) * 2.000);
   
   
   double R38=  Pivot + ((prevRange) * 1.000);
   double R61=  Pivot + ((prevRange) * 1.618);
   double R78=  Pivot + ((prevRange) * 2.618);
   double R100= Pivot + ((prevRange) * 4.236);
   double R138= Pivot + ((prevRange) * 5.382);
   double R161= Pivot + ((prevRange) * 6.618);
   double R200= Pivot + ((prevRange) * 7.000);
   double S38 = Pivot - ((prevRange) * 1.000);
   double S61 = Pivot - ((prevRange) * 1.618);
   double S78 = Pivot -((prevRange)  * 2.618);
   double S100= Pivot - ((prevRange) * 4.236);
   double S138= Pivot - ((prevRange) * 5.382);
   double S161= Pivot - ((prevRange) * 6.618);
   double S200= Pivot - ((prevRange) * 7.000);


   
   ppArrayRef[symbolIndex][0]=Pivot;
   ppArrayRef[symbolIndex][1]=R38;
   ppArrayRef[symbolIndex][2]=R61;
   ppArrayRef[symbolIndex][3]=R78;
   ppArrayRef[symbolIndex][4]=R100;
   ppArrayRef[symbolIndex][5]=R138;
   ppArrayRef[symbolIndex][6]=R161;
   ppArrayRef[symbolIndex][7]=R200;
   ppArrayRef[symbolIndex][8]=S38;
   ppArrayRef[symbolIndex][9]=S61;
   ppArrayRef[symbolIndex][10]=S78;
   ppArrayRef[symbolIndex][11]=S100;
   ppArrayRef[symbolIndex][12]=S138;
   ppArrayRef[symbolIndex][13]=S161;
   ppArrayRef[symbolIndex][14]=S200;
  }
  
  
//FVG dummy
void FVGPP(ENUM_TIMEFRAMES timeFrame,double &ppArrayRef[][],int symbolIndex,string symbolName)//FVG pivot point formula
  {
  
   int shift=1;
   /*
   Returned value
   The zero-based day of week (0 means Sunday,1,2,3,4,5,6) of the specified date.
   */
   if(timeFrame==PERIOD_D1)
     {
      datetime dayCheck1=iTime(symbolName,PERIOD_D1,shift);
      if(TimeDayOfWeek(dayCheck1) == 0)//found sunday - skip over
        {
         shift+=1;
        }

      datetime dayCheck2=iTime(symbolName,PERIOD_D1,shift);
      if(TimeDayOfWeek(dayCheck2) == 6)//found saturday - skip over
        {
         shift+=1;
        }
     }
  
   double prevRange= iHigh(symbolName,timeFrame,shift)-iLow(symbolName,timeFrame,shift);
   double prevHigh = iHigh(symbolName,timeFrame,shift);
   double prevLow=iLow(symbolName,timeFrame,shift);
   double prevClose=iClose(symbolName,timeFrame,shift);
   int symbolDigits=(int)MarketInfo(symbolName,MODE_DIGITS);
   double Pivot=(prevHigh+prevLow+prevClose)/3;

   
   ppArrayRef[symbolIndex][0]=Pivot;

  }
  
  
  
  
  
////sets the pivot flags used for when detecting a cross over or when xx points near
void initializePivotPoints(int symbolIndex,int numOfPivotPoints)//sets the pivot flags used for when detecting a cross over or when xx points near
  {
   if(symbolTimeframeTimeP[symbolIndex]==NULL)
     {
      resetVariables(symbolIndex);
      symbolTimeframeTimeP[symbolIndex]=iTime(symbolListFinal[symbolIndex],pivotTimeframe,0);//used to find out new day
      string symbol = symbolListFinal[symbolIndex];
      //set the flags using if bid>pivot set to true else false, used to dectect price cross pivot point
      double bid=MarketInfo(symbol,MODE_BID);
      //if using bounced alert get the current time of that symbol m15 TF candle so when new candle open we will know its a new candle
      if(alertModeSelection==Cross_And_Bounce_Alerts ||
         alertModeSelection==Near_And_Bounce_Alerts  ||
         alertModeSelection==Bounce_Only_Alerts)
        {
         symbolNewCandleCheck[symbolIndex][0]=iTime(symbol,bouncedCandleTF,0);
        }
      double points=MarketInfo(symbol,MODE_POINT);
      double pipPoints=xxPoints*points;
      switch(pivotSelection)//initalize seleted pivot point forumula
        {
         case Standard :
            standardPivotPoint(pivotTimeframe,Pivots,symbolIndex,symbol);//Gets the values
            calculatetrda(pivotTimeframe,TRDACheck,symbolIndex,symbol);
            break;
         case Camarilla :
            camarillaPivotPoint(pivotTimeframe,Pivots,symbolIndex,symbol);//Gets the values
            break;
         case Woodie :
            woodiePivotPoint(pivotTimeframe,Pivots,symbolIndex,symbol);//Gets the values
            break;
         case Fibonacci :
            fibonacciPivotPoint(pivotTimeframe,Pivots,symbolIndex,symbol);//Gets the values
            calculatetrda(pivotTimeframe,TRDACheck,symbolIndex,symbol);
            break;
         case FVG :
            FVGPP(pivotTimeframe,Pivots,symbolIndex,symbol);//Gets the values
            //calculateFVG(pivotTimeframe,FVGCheck,symbolIndex,symbol);
            calculatekama(pivotTimeframe,FVGCheck,symbolIndex,symbol);
            break;
        }
      for(int l=0; l<numOfPivotPoints; l++)
        {
         if(Pivots[symbolIndex][l]==NULL ||
            iClose(symbolListFinal[symbolIndex], pivotTimeframe,0)==0 ||
            iTime(symbolListFinal[symbolIndex], pivotTimeframe, 0)==0)
           {
            symbolTimeframeTimeP[symbolIndex]=NULL;
            Print(symbolListFinal[symbolIndex]+" "+"History Still Downloading");
            return;
           }
        }
      if(alertModeSelection==Cross_Alerts ||
         alertModeSelection==Cross_And_Bounce_Alerts)
        {
         for(int i=0; i<numOfPivotPoints; i++) //sets the initial flags
           {
            if(bid>=Pivots[symbolIndex][i])
               PivotsFlag[symbolIndex][i]=true;
            else
               PivotsFlag[symbolIndex][i]=false;
           }
        }
      else
         if(alertModeSelection==Near_Alerts ||
            alertModeSelection==Near_And_Bounce_Alerts)
           {
            for(int i=0; i<numOfPivotPoints; i++) //sets the initial flags
              {
               double pivotHigh=Pivots[symbolIndex][i]+pipPoints;
               double pivotLow=Pivots[symbolIndex][i]-pipPoints;

               if(bid<=pivotHigh && bid>=pivotLow)//check if inzone == false
                 {
                  PivotsZoneFlag[symbolIndex][i]=true;
                 }
               else
                 {
                  PivotsZoneFlag[symbolIndex][i]=false;
                 }
              }
           }
      if(printOutPivotPoints==Yes && printOutPivotPointsSymbolIndex==symbolIndex)// if yes will call the print out method to show the pivot point values in alert pop up
        {
         printOutPivotPoint(printOutPivotPointsSymbolIndex);
        }
     }
  }
//check for alert conditions
void PivotCheck(int symbolIndex, int numOfPivotPoints,bool &showRef[],string &pivotNamesRef[])//method to look for the alert conditions using the pivot flags or bounced check method
  {
   if(symbolTimeframeTimeP[symbolIndex]!=NULL)
     {
      bool result;//bool for bid>pivot test with flag
      double bid;
      double points;
      double pipPoints;
      int digits;
      string ppTimeFrame;
      string symbolName;
      symbolName=symbolListFinal[symbolIndex];
      bid=MarketInfo(symbolName,MODE_BID);
      points=MarketInfo(symbolName,MODE_POINT);
      digits=(int)MarketInfo(symbolName,MODE_DIGITS);
      pipPoints=xxPoints*points;
      ppTimeFrame=pivotTimeframeName;
      if(alertModeSelection!=Bounce_Only_Alerts)
        {
         for(int j=0; j<numOfPivotPoints; j++)
           {
            if(alertModeSelection==Cross_Alerts ||
               alertModeSelection==Cross_And_Bounce_Alerts)
              {
               result=bid>=Pivots[symbolIndex][j];
               if(result!=PivotsFlag[symbolIndex][j])
                 {
                  PivotsFlag[symbolIndex][j]=result;
                  if(useBollingerBands==Yes)
                    {
                     if(isUpperLowerBollinger(symbolIndex)==true && TimeCurrent()>=PivotsWaitTill[symbolIndex][j] && showRef[j]==true)
                       {
                        PivotsWaitTill[symbolIndex][j]=(TimeCurrent()+alertIntervalTimeSeconds);
                        doAlert(symbolName,ppTimeFrame,pivotNamesRef[j]);
                       }
                    }
                  else
                     if(useBollingerBands==No)
                       {
                        if(TimeCurrent()>=PivotsWaitTill[symbolIndex][j] && showRef[j]==true && pivotSelection!=FVG)
                        //if(TimeCurrent()>=PivotsWaitTill[symbolIndex][j] && showRef[j]==true && TRDACheck[symbolIndex][0]>=0)
                          {
                           PivotsWaitTill[symbolIndex][j]=(TimeCurrent()+alertIntervalTimeSeconds);
                           doAlert(symbolName,ppTimeFrame,pivotNamesRef[j]);
                          }
                       }
                 }
              }
            else
               if(alertModeSelection==Near_Alerts ||
                  alertModeSelection==Near_And_Bounce_Alerts)
                 {
                  double pivotHigh=Pivots[symbolIndex][j]+pipPoints;
                  double pivotLow=Pivots[symbolIndex][j]-pipPoints;

                  result=((bid<=pivotHigh) && (bid>=pivotLow));//get 1 or 0
                  if(result!=PivotsZoneFlag[symbolIndex][j])
                    {
                     PivotsZoneFlag[symbolIndex][j]=result;
                     if(useBollingerBands==Yes)
                       {
                        if(isUpperLowerBollinger(symbolIndex)==true && TimeCurrent()>=PivotsWaitTill[symbolIndex][j] && showRef[j]==true && PivotsZoneFlag[symbolIndex][j]==true)
                          {
                           PivotsWaitTill[symbolIndex][j]=(TimeCurrent()+alertIntervalTimeSeconds);
                           doAlert(symbolName,ppTimeFrame,pivotNamesRef[j]);
                          }
                       }
                     else
                        if(useBollingerBands==No)
                          {
                           if(TimeCurrent()>=PivotsWaitTill[symbolIndex][j] && showRef[j]==true && PivotsZoneFlag[symbolIndex][j]==true)
                             {
                              PivotsWaitTill[symbolIndex][j]=(TimeCurrent()+alertIntervalTimeSeconds);
                              doAlert(symbolName,ppTimeFrame,pivotNamesRef[j]);
                             }
                          }
                    }
                 }
                 //ADDFVGCHECKHERE
                 
                 
                 
                 
                 if (pivotSelection == FVG && Time[0] != PivotsWaitTill[symbolIndex][j]  && FVGCheck[symbolIndex][0] > 0 && FVGWaitTill[symbolIndex][j] != FVGCheck[symbolIndex][1])
                 //if (pivotSelection==FVG && TimeCurrent()>=PivotsWaitTill[symbolIndex][j] && FVGCheck[symbolIndex][0]>0 && FVGWaitTill[symbolIndex][j] != FVGCheck[symbolIndex][1]) //something logic checking here, try revising trdacheck/calculatetrda
                 {
                        PivotsWaitTill[symbolIndex][j] = Time[0]; // Save this candle time

                       // PivotsWaitTill[symbolIndex][j]=(TimeCurrent()+alertIntervalTimeSeconds);
                        FVGWaitTill[symbolIndex][j] = FVGCheck[symbolIndex][1];
                        doAlertFVG2(symbolName,ppTimeFrame,pivotNamesRef[j],1,symbolIndex,FVGCheck[symbolIndex][1],FVGCheck[symbolIndex][2]); 
                        //doAlertFVG(symbolName,ppTimeFrame,pivotNamesRef[j],1,symbolIndex); 
                        Print(symbolName,"Bull",FVGCheck[symbolIndex][1]); 
                        FVGCheck[symbolIndex][0]=0;
                        FVGCheck[symbolIndex][1]=0;
                        FVGCheck[symbolIndex][2]=0;
                 }
                 if (pivotSelection == FVG && Time[0] != PivotsWaitTillB[symbolIndex][j]  && FVGCheck[symbolIndex][0] < 0 && FVGWaitTillB[symbolIndex][j] != FVGCheck[symbolIndex][1])
                 //if (pivotSelection==FVG && TimeCurrent()>=PivotsWaitBTill[symbolIndex][j]&& FVGCheck[symbolIndex][0]<0&& FVGWaitTill[symbolIndex][j] != FVGCheck[symbolIndex][1]) //something logic checking here, try revising trdacheck/calculatetrda
                 {
                        PivotsWaitTillB[symbolIndex][j] = Time[0]; // Save this candle time

                        //PivotsWaitBTill[symbolIndex][j]=(TimeCurrent()+alertIntervalTimeSeconds);
                        FVGWaitTillB[symbolIndex][j] = FVGCheck[symbolIndex][1];
                        doAlertFVG2(symbolName,ppTimeFrame,pivotNamesRef[j],-1,symbolIndex,FVGCheck[symbolIndex][1],FVGCheck[symbolIndex][2]); 
                        //doAlertFVG(symbolName,ppTimeFrame,pivotNamesRef[j],-1,symbolIndex); 
                        Print(symbolName,"Bear",FVGCheck[symbolIndex][1]); 
                        FVGCheck[symbolIndex][0]=0;
                        FVGCheck[symbolIndex][1]=0;
                        FVGCheck[symbolIndex][2]=0;
                 }
                 
           }//end of
        }
      //code for bounce check
      if(useBollingerBands==Yes && isUpperLowerBollinger(symbolIndex)==true)
        {
         BouncedCheck(symbolIndex,numOfPivotPoints,symbolPPIndex,Pivots,PivotState,ppTimeFrame,pivotNamesRef,showRef);
        }
      else
         if(useBollingerBands==No)
           {
            BouncedCheck(symbolIndex,numOfPivotPoints,symbolPPIndex,Pivots,PivotState,ppTimeFrame,pivotNamesRef,showRef);
           }
     }
  }
//printout values
void printOutPivotPoint(int index)//prints out the values of all the pivot points and names used for testing and seeing the values to compare
  {
   if(index>numSymbols-1 || index<0)
     {
      Alert("printOutPivotPointsSymbolIndex invalid index number");
     }
   else
     {
      string printMessage="";
      if(pivotSelection==Standard)
        {
         string pivotLevelName=pivotTimeframeName;
         int digits=(int)MarketInfo(symbolListFinal[index],MODE_DIGITS);
         for(int j=0; j<numPPStandard; j++) //sets the initial flags
           {
            printMessage+=(pivotLevelName+standardPivotNames[j]+" "+DoubleToString(Pivots[index][j],digits)+"\n");
           }
         Alert("PRINT OUT TEST "+symbolListFinal[index]+" VALUES BELOW "+EnumToString(pivotSelection)+"\n"+printMessage);
        }
      else
         if(pivotSelection==Camarilla)
           {
            string pivotLevelName=pivotTimeframeName;
            int digits=(int)MarketInfo(symbolListFinal[index],MODE_DIGITS);
            for(int j=0; j<numPPCamarilla; j++) //sets the initial flags
              {
               printMessage+=(pivotLevelName+camarillaPivotNames[j]+" "+DoubleToString(Pivots[index][j],digits)+"\n");
              }
            Alert("PRINT OUT TEST "+symbolListFinal[index]+" VALUES BELOW "+EnumToString(pivotSelection)+"\n"+printMessage);
           }
         else
            if(pivotSelection==Woodie)
              {
               string pivotLevelName=pivotTimeframeName;
               int digits=(int)MarketInfo(symbolListFinal[index],MODE_DIGITS);
               for(int j=0; j<numPPWoodie; j++) //sets the initial flags
                 {
                  printMessage+=(pivotLevelName+woodiePivotNames[j]+" "+DoubleToString(Pivots[index][j],digits)+"\n");
                 }
               Alert("PRINT OUT TEST "+symbolListFinal[index]+" VALUES BELOW "+EnumToString(pivotSelection)+"\n"+printMessage);
              }
            else
               if(pivotSelection==Fibonacci)
                 {
                  string pivotLevelName=pivotTimeframeName;
                  int digits=(int)MarketInfo(symbolListFinal[index],MODE_DIGITS);
                  for(int j=0; j<numPPFibonacci; j++) //sets the initial flags
                    {
                     printMessage+=(pivotLevelName+fibonacciPivotNames[j]+" "+DoubleToString(Pivots[index][j],digits)+"\n");
                    }
                  Alert("PRINT OUT TEST "+symbolListFinal[index]+" VALUES BELOW "+EnumToString(pivotSelection)+"\n"+printMessage);
                 }
     }
  }
//method for bounce check
void BouncedCheck(int i,int numPP,int &correctPivotIndexRef[][],double &ppArrayRef[][], int &pivotStateRef[][],string ppTimeFrame,string &PivotNamesRef[],
                  bool &showRef[])//to look for when price crosses a pivot but then bounces back and closses opposite candle color send alerts
  {
   if(alertModeSelection==Cross_And_Bounce_Alerts ||
      alertModeSelection==Near_And_Bounce_Alerts  ||
      alertModeSelection==Bounce_Only_Alerts)
     {
      string symbolName=symbolListFinal[i];
      if(symbolNewCandleCheck[i][0]!=iTime(symbolName,bouncedCandleTF,0))//if true new candle detected
        {
         symbolNewCandleCheck[i][0]=iTime(symbolName,bouncedCandleTF,0);//update candle check to new candle date.
         double high=iHigh(symbolName,bouncedCandleTF,1);//shift 1 candle left from current to get prev candle info
         double open=iOpen(symbolName,bouncedCandleTF,1);
         double close=iClose(symbolName,bouncedCandleTF,1);
         double low=iLow(symbolName,bouncedCandleTF,1);
         int correctPivotIndex=-1;//
         // this block code just looks if a pivot was crossed
         ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         //just to check more than 1 pivot was crossed select the most approite one
         double PivotIndexCrossed[];
         ArrayResize(PivotIndexCrossed,numPP);
         for(int m=0; m<numPP; m++)
           {
            PivotIndexCrossed[m]=0;
           }
         int countFound=0;//count how many pivots crossed
         for(int k=0; k<numPP; k++)//use high and low and checks to find the pivots that were crossed
           {
            if(open<ppArrayRef[i][k] &&
               ppArrayRef[i][k]<=high &&
               ppArrayRef[i][k]>=low)//if true means a pivot point was between the high and low so there was a cross
              {
               countFound++;//increments 1 evertime enter if statement
               PivotIndexCrossed[k]=1;//set to 1 mean was crossed
               correctPivotIndex=k;//set that pivot index so we know which pivot point that was
              }
            else
               if(open>ppArrayRef[i][k] &&
                  ppArrayRef[i][k]<=high &&
                  ppArrayRef[i][k]>=low)//if true means a pivot point was between the high and low so there was a cross and Beasrish open candle price greater than pivot
                 {
                  countFound++;
                  PivotIndexCrossed[k]=1;
                  correctPivotIndex=k;
                 }
           }
         bool isBullishCandle=false;
         if(open<close)//find out if it's a bullish candle or bearish, true = bullish , false bearish
           {
            isBullishCandle=true;
           }

         bool isBearishCandle=false;
         if(open>close)//bearish
           {
            isBearishCandle=true;
           }
         //if countFound more than 1 pivot it must of been a huge move so check if was bullish or bearish candle then get the best level
         bool firstNumberGrabed=false;
         double highest=0;
         double lowest=0;
         if(countFound>1)
           {
            if(isBullishCandle==true)//bullish candle and found multiple pivot crossing so look for highest priced pivot point and use that one
              {
               for(int n=0; n<numPP; n++)
                 {
                  if(PivotIndexCrossed[n]==1)
                    {
                     if(firstNumberGrabed=false)
                       {
                        firstNumberGrabed=true;
                        highest=ppArrayRef[i][n];
                        correctPivotIndex=n;//index of the pivot to get name and price
                       }
                     else
                       {
                        if(ppArrayRef[i][n]>highest)
                          {
                           highest=ppArrayRef[i][n];
                           correctPivotIndex=n;//index of the pivot to get name and price
                          }
                       }
                    }
                 }
              }
            else
               if(isBearishCandle==true)
                 {
                  for(int n=0; n<numPP; n++)//Bearish  candle and found multiple pivot crossing so look for lowest priced pivot point and use that one
                    {
                     if(PivotIndexCrossed[n]==1)
                       {
                        if(firstNumberGrabed=false)
                          {
                           firstNumberGrabed=true;
                           lowest=ppArrayRef[i][n];
                           correctPivotIndex=n;//index of the pivot to get name and price
                          }
                        else
                          {
                           if(ppArrayRef[i][n]<lowest)
                             {
                              lowest=ppArrayRef[i][n];
                              correctPivotIndex=n;//index of the pivot to get name and price
                             }
                          }
                       }
                    }
                 }
           }//end of count found > 1 loop
         ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         bool foundR=false;
         bool foundP=false;
         bool foundS=false;
         if(countFound>=1)
           {
            if('R'==StringGetChar(PivotNamesRef[correctPivotIndex],0))
              {
               foundR=true;
              }
            else
               if('P'==StringGetChar(PivotNamesRef[correctPivotIndex],0))
                 {
                  foundP=true;
                 }
               else
                  if('S'==StringGetChar(PivotNamesRef[correctPivotIndex],0))
                    {
                     foundS=true;
                    }
                  else
                     if('m'==StringGetChar(PivotNamesRef[correctPivotIndex],0))
                       {
                        if('R'==StringGetChar(PivotNamesRef[correctPivotIndex],1))
                          {
                           foundR=true;
                          }
                        else
                          {
                           foundS=true;
                          }
                       }
           }
         //if pivot state is not zero but priced crossed new pivot reset to 0
         if(pivotStateRef[i][0]!=0 && countFound>=1 &&
            pivotStateRef[i][0]!=correctPivotIndex)
           {
            pivotStateRef[i][0]=0;
            correctPivotIndexRef[i][0]=-1;
           }
         //ALERT TYPE 1
         if(pivotStateRef[i][0]==0 && countFound>=1)
           {
            if(foundR==true &&
               close<ppArrayRef[i][correctPivotIndex])
              {
               if(candleColorFilter==Yes  && isBullishCandle==false && isBearishCandle==true)//bounced off of R has to close Bearish color Candle Below R
                 {

                  if(showRef[correctPivotIndex] &&(iTime(symbolName,bouncedCandleTF,bounceXBarsWait) >= bouncedWaitTill[i][correctPivotIndex]))
                    {
                     bouncedWaitTill[i][correctPivotIndex]=iTime(symbolName,bouncedCandleTF,0);
                     doAlertBounce(symbolName,ppTimeFrame,PivotNamesRef[correctPivotIndex],'R');
                    }
                 }
               else
                  if(candleColorFilter==No)
                    {
                     if(showRef[correctPivotIndex] &&(iTime(symbolName,bouncedCandleTF,bounceXBarsWait) >= bouncedWaitTill[i][correctPivotIndex]))
                       {
                        bouncedWaitTill[i][correctPivotIndex]=iTime(symbolName,bouncedCandleTF,0);
                        doAlertBounce(symbolName,ppTimeFrame,PivotNamesRef[correctPivotIndex],'R');
                       }
                    }
              }
            else
               if(foundS==true &&
                  close>ppArrayRef[i][correctPivotIndex])
                 {
                  if(candleColorFilter==Yes  && isBullishCandle==true && isBearishCandle==false)//bounced off of S has to close Bullish color Candle Above S
                    {
                     if(showRef[correctPivotIndex] &&(iTime(symbolName,bouncedCandleTF,bounceXBarsWait) >= bouncedWaitTill[i][correctPivotIndex]))
                       {
                        bouncedWaitTill[i][correctPivotIndex]=iTime(symbolName,bouncedCandleTF,0);
                        doAlertBounce(symbolName,ppTimeFrame,PivotNamesRef[correctPivotIndex],'S');
                       }
                    }
                  else
                     if(candleColorFilter==No)
                       {
                        if(showRef[correctPivotIndex] &&(iTime(symbolName,bouncedCandleTF,bounceXBarsWait) >= bouncedWaitTill[i][correctPivotIndex]))
                          {
                           bouncedWaitTill[i][correctPivotIndex]=iTime(symbolName,bouncedCandleTF,0);
                           doAlertBounce(symbolName,ppTimeFrame,PivotNamesRef[correctPivotIndex],'S');
                          }
                       }
                 }
               else
                  if(foundP==true &&
                     close>ppArrayRef[i][correctPivotIndex])
                    {
                     if(candleColorFilter==Yes  && isBullishCandle==true && isBearishCandle==false)//bounced off of S has to close Bullish color Candle Above S
                       {
                        if(showRef[correctPivotIndex] &&(iTime(symbolName,bouncedCandleTF,bounceXBarsWait) >= bouncedWaitTill[i][correctPivotIndex]))
                          {
                           bouncedWaitTill[i][correctPivotIndex]=iTime(symbolName,bouncedCandleTF,0);
                           doAlertBounce(symbolName,ppTimeFrame,PivotNamesRef[correctPivotIndex],'S');
                          }
                       }
                     else
                        if(candleColorFilter==No)
                          {
                           if(showRef[correctPivotIndex] &&(iTime(symbolName,bouncedCandleTF,bounceXBarsWait) >= bouncedWaitTill[i][correctPivotIndex]))
                             {
                              bouncedWaitTill[i][correctPivotIndex]=iTime(symbolName,bouncedCandleTF,0);
                              doAlertBounce(symbolName,ppTimeFrame,PivotNamesRef[correctPivotIndex],'S');
                             }
                          }
                    }
                  else
                     if(foundP==true &&
                        close<ppArrayRef[i][correctPivotIndex])
                       {
                        if(candleColorFilter==Yes  && isBullishCandle==false && isBearishCandle==true)//bounced off of S has to close Bullish color Candle Above S
                          {
                           if(showRef[correctPivotIndex] &&(iTime(symbolName,bouncedCandleTF,bounceXBarsWait) >= bouncedWaitTill[i][correctPivotIndex]))
                             {
                              bouncedWaitTill[i][correctPivotIndex]=iTime(symbolName,bouncedCandleTF,0);
                              doAlertBounce(symbolName,ppTimeFrame,PivotNamesRef[correctPivotIndex],'R');
                             }
                          }
                        else
                           if(candleColorFilter==No)
                             {
                              if(showRef[correctPivotIndex] &&(iTime(symbolName,bouncedCandleTF,bounceXBarsWait) >= bouncedWaitTill[i][correctPivotIndex]))
                                {
                                 bouncedWaitTill[i][correctPivotIndex]=iTime(symbolName,bouncedCandleTF,0);
                                 doAlertBounce(symbolName,ppTimeFrame,PivotNamesRef[correctPivotIndex],'R');
                                }
                             }
                       }
           }
         //ALERT TYPE 2
         if(pivotStateRef[i][0]==0 && countFound>=1)
           {
            if(foundR==true &&
               close>ppArrayRef[i][correctPivotIndex])
              {
               pivotStateRef[i][0]=1;
               correctPivotIndexRef[i][0]=correctPivotIndex;
              }
            else
               if(foundS==true &&
                  close<ppArrayRef[i][correctPivotIndex])
                 {
                  pivotStateRef[i][0]=2;
                  correctPivotIndexRef[i][0]=correctPivotIndex;
                 }
           }
         //ALERT TYPE 2a
         if(pivotStateRef[i][0]!=0)
           {
            if('R'==StringGetChar(PivotNamesRef[correctPivotIndexRef[i][0]],0))
              {
               foundR=true;
              }
            else
               if('P'==StringGetChar(PivotNamesRef[correctPivotIndexRef[i][0]],0))
                 {
                  foundP=true;
                 }
               else
                  if('S'==StringGetChar(PivotNamesRef[correctPivotIndexRef[i][0]],0))
                    {
                     foundS=true;
                    }
                  else
                     if('m'==StringGetChar(PivotNamesRef[correctPivotIndex],0))
                       {
                        if('R'==StringGetChar(PivotNamesRef[correctPivotIndex],1))
                          {
                           foundR=true;
                          }
                        else
                          {
                           foundS=true;
                          }
                       }

            if(foundR==true &&
               close<ppArrayRef[i][correctPivotIndexRef[i][0]])
              {
               if(candleColorFilter==Yes  && isBullishCandle==false && isBearishCandle==true)//bounced off of R has to close Bearish color Candle Below R
                 {
                  pivotStateRef[i][0]=0;
                  if(showRef[correctPivotIndexRef[i][0]] &&(iTime(symbolName,bouncedCandleTF,bounceXBarsWait) >= bouncedWaitTill[i][correctPivotIndexRef[i][0]]))
                    {
                     bouncedWaitTill[i][correctPivotIndexRef[i][0]]=iTime(symbolName,bouncedCandleTF,0);
                     doAlertBounce(symbolName,ppTimeFrame,PivotNamesRef[correctPivotIndexRef[i][0]],'R');
                    }
                 }
               else
                  if(candleColorFilter==No)
                    {
                     pivotStateRef[i][0]=0;
                     if(showRef[correctPivotIndexRef[i][0]] &&(iTime(symbolName,bouncedCandleTF,bounceXBarsWait) >= bouncedWaitTill[i][correctPivotIndexRef[i][0]]))
                       {
                        bouncedWaitTill[i][correctPivotIndexRef[i][0]]=iTime(symbolName,bouncedCandleTF,0);
                        doAlertBounce(symbolName,ppTimeFrame,PivotNamesRef[correctPivotIndexRef[i][0]],'R');
                       }
                    }
              }
            else
               if(foundS==true &&
                  close>ppArrayRef[i][correctPivotIndexRef[i][0]])
                 {
                  if(candleColorFilter==Yes  && isBullishCandle==true && isBearishCandle==false)//bounced off of S has to close Bullish color Candle Above S
                    {
                     pivotStateRef[i][0]=0;
                     if(showRef[correctPivotIndexRef[i][0]] &&(iTime(symbolName,bouncedCandleTF,bounceXBarsWait) >= bouncedWaitTill[i][correctPivotIndexRef[i][0]]))
                       {
                        bouncedWaitTill[i][correctPivotIndexRef[i][0]]=iTime(symbolName,bouncedCandleTF,0);
                        doAlertBounce(symbolName,ppTimeFrame,PivotNamesRef[correctPivotIndexRef[i][0]],'S');
                       }
                    }
                  else
                     if(candleColorFilter==No)
                       {
                        pivotStateRef[i][0]=0;
                        if(showRef[correctPivotIndexRef[i][0]] &&(iTime(symbolName,bouncedCandleTF,bounceXBarsWait) >= bouncedWaitTill[i][correctPivotIndexRef[i][0]]))
                          {
                           bouncedWaitTill[i][correctPivotIndexRef[i][0]]=iTime(symbolName,bouncedCandleTF,0);
                           doAlertBounce(symbolName,ppTimeFrame,PivotNamesRef[correctPivotIndexRef[i][0]],'S');
                          }
                       }
                 }
               else
                  if(foundP==true &&
                     close>ppArrayRef[i][correctPivotIndexRef[i][0]])
                    {
                     if(candleColorFilter==Yes  && isBullishCandle==true && isBearishCandle==false)//bounced off of S has to close Bullish color Candle Above S
                       {
                        pivotStateRef[i][0]=0;
                        if(showRef[correctPivotIndexRef[i][0]] &&(iTime(symbolName,bouncedCandleTF,bounceXBarsWait) >= bouncedWaitTill[i][correctPivotIndexRef[i][0]]))
                          {
                           bouncedWaitTill[i][correctPivotIndexRef[i][0]]=iTime(symbolName,bouncedCandleTF,0);
                           doAlertBounce(symbolName,ppTimeFrame,PivotNamesRef[correctPivotIndexRef[i][0]],'S');
                          }
                       }
                     else
                        if(candleColorFilter==No)
                          {
                           pivotStateRef[i][0]=0;
                           if(showRef[correctPivotIndexRef[i][0]] &&(iTime(symbolName,bouncedCandleTF,bounceXBarsWait) >= bouncedWaitTill[i][correctPivotIndexRef[i][0]]))
                             {
                              bouncedWaitTill[i][correctPivotIndexRef[i][0]]=iTime(symbolName,bouncedCandleTF,0);
                              doAlertBounce(symbolName,ppTimeFrame,PivotNamesRef[correctPivotIndexRef[i][0]],'S');
                             }
                          }
                    }
                  else
                     if(foundP==true &&
                        close<ppArrayRef[i][correctPivotIndexRef[i][0]])
                       {
                        if(candleColorFilter==Yes  && isBullishCandle==false && isBearishCandle==true)//bounced off of S has to close Bullish color Candle Above S
                          {
                           pivotStateRef[i][0]=0;
                           if(showRef[correctPivotIndexRef[i][0]] &&(iTime(symbolName,bouncedCandleTF,bounceXBarsWait) >= bouncedWaitTill[i][correctPivotIndexRef[i][0]]))
                             {
                              bouncedWaitTill[i][correctPivotIndexRef[i][0]]=iTime(symbolName,bouncedCandleTF,0);
                              doAlertBounce(symbolName,ppTimeFrame,PivotNamesRef[correctPivotIndexRef[i][0]],'R');
                             }
                          }
                        else
                           if(candleColorFilter==No)
                             {
                              pivotStateRef[i][0]=0;
                              if(showRef[correctPivotIndexRef[i][0]] &&(iTime(symbolName,bouncedCandleTF,bounceXBarsWait) >= bouncedWaitTill[i][correctPivotIndexRef[i][0]]))
                                {
                                 bouncedWaitTill[i][correctPivotIndexRef[i][0]]=iTime(symbolName,bouncedCandleTF,0);
                                 doAlertBounce(symbolName,ppTimeFrame,PivotNamesRef[correctPivotIndexRef[i][0]],'R');
                                }
                             }
                       }
           }
        }
      //end of bounce
     }
  }
//used to stop certain pivot points from being alerted
void updateSpecifiedPivotPointAlerts()//used to stop certain pivot points from being alerted
  {
   if(showStandardPivotPP==Disable)//standard
      showStandard[0]=false;
   else
      showStandard[0]=true;
   if(showStandardPivotS1==Disable)
      showStandard[1]=false;
   else
      showStandard[1]=true;
   if(showStandardPivotS2==Disable)
      showStandard[2]=false;
   else
      showStandard[2]=true;
   if(showStandardPivotS3==Disable)
      showStandard[3]=false;
   else
      showStandard[3]=true;
   if(showStandardPivotR1==Disable)
      showStandard[4]=false;
   else
      showStandard[4]=true;
   if(showStandardPivotR2==Disable)
      showStandard[5]=false;
   else
      showStandard[5]=true;
   if(showStandardPivotR3==Disable)
      showStandard[6]=false;
   else
      showStandard[6]=true;
   if(showStandardPivotR4==Disable)
      showStandard[7]=false;
   else
      showStandard[7]=true;
   if(showStandardPivotS4==Disable)
      showStandard[8]=false;
   else
      showStandard[8]=true;
   if(showStandardPivotR5==Disable)
      showStandard[9]=false;
   else
      showStandard[9]=true;
   if(showStandardPivotS5==Disable)
      showStandard[10]=false;
   else
      showStandard[10]=true;
   if(showStandardPivotR6==Disable)
      showStandard[11]=false;
   else
      showStandard[11]=true;
   if(showStandardPivotS6==Disable)
      showStandard[12]=false;
   else
      showStandard[12]=true;





   if(showCamarillaPP==Disable) //Camarilla
      showCamarilla[0]=false;
   else
      showCamarilla[0]=true;
   if(showCamarillaS1==Disable)
      showCamarilla[1]=false;
   else
      showCamarilla[1]=true;
   if(showCamarillaS2==Disable)
      showCamarilla[2]=false;
   else
      showCamarilla[2]=true;
   if(showCamarillaS3==Disable)
      showCamarilla[3]=false;
   else
      showCamarilla[3]=true;
   if(showCamarillaS4==Disable)
      showCamarilla[4]=false;
   else
      showCamarilla[4]=true;
   if(showCamarillaR1==Disable)
      showCamarilla[5]=false;
   else
      showCamarilla[5]=true;
   if(showCamarillaR2==Disable)
      showCamarilla[6]=false;
   else
      showCamarilla[6]=true;
   if(showCamarillaR3==Disable)
      showCamarilla[7]=false;
   else
      showCamarilla[7]=true;
   if(showCamarillaR4==Disable)
      showCamarilla[8]=false;
   else
      showCamarilla[8]=true;
   if(showCamarillaR5==Disable)
      showCamarilla[9]=false;
   else
      showCamarilla[9]=true;
   if(showCamarillaS5==Disable)
      showCamarilla[10]=false;
   else
      showCamarilla[10]=true;

   if(showWoodiePP==Disable)//Woodie
      showWoodie[0]=false;
   else
      showWoodie[0]=true;
   if(showWoodieS1==Disable)
      showWoodie[1]=false;
   else
      showWoodie[1]=true;
   if(showWoodieS2==Disable)
      showWoodie[2]=false;
   else
      showWoodie[2]=true;
   if(showWoodieR1==Disable)
      showWoodie[3]=false;
   else
      showWoodie[3]=true;
   if(showWoodieR2==Disable)
      showWoodie[4]=false;
   else
      showWoodie[4]=true;

   if(showFibonacciPivotPP==Disable)//Fibonacci
      showFibonacci[0]=false;
   else
      showFibonacci[0]=true;
   if(showFibonacciPivotR38==Disable)
      showFibonacci[1]=false;
   else
      showFibonacci[1]=true;
   if(showFibonacciPivotR61==Disable)
      showFibonacci[2]=false;
   else
      showFibonacci[2]=true;
   if(showFibonacciPivotR78==Disable)
      showFibonacci[3]=false;
   else
      showFibonacci[3]=true;
   if(showFibonacciPivotR100==Disable)
      showFibonacci[4]=false;
   else
      showFibonacci[4]=true;
   if(showFibonacciPivotR138==Disable)
      showFibonacci[5]=false;
   else
      showFibonacci[5]=true;
   if(showFibonacciPivotR161==Disable)
      showFibonacci[6]=false;
   else
      showFibonacci[6]=true;
   if(showFibonacciPivotR200==Disable)
      showFibonacci[7]=false;
   else
      showFibonacci[7]=true;
   if(showFibonacciPivotS38==Disable)
      showFibonacci[8]=false;
   else
      showFibonacci[8]=true;
   if(showFibonacciPivotS61==Disable)
      showFibonacci[9]=false;
   else
      showFibonacci[9]=true;
   if(showFibonacciPivotS78==Disable)
      showFibonacci[10]=false;
   else
      showFibonacci[10]=true;
   if(showFibonacciPivotS100==Disable)
      showFibonacci[11]=false;
   else
      showFibonacci[11]=true;
   if(showFibonacciPivotS138==Disable)
      showFibonacci[12]=false;
   else
      showFibonacci[12]=true;
   if(showFibonacciPivotS161==Disable)
      showFibonacci[13]=false;
   else
      showFibonacci[13]=true;
   if(showFibonacciPivotS200==Disable)
      showFibonacci[14]=false;
   else
      showFibonacci[14]=true;
  }
//check if values are correct
void checkValuesForValid(int symbolIndex,int numOfPivotPoints)
  {
   string symbol=symbolListFinal[symbolIndex];
   switch(pivotSelection)//initalize seleted pivot point forumula
     {
      case Standard :
         standardPivotPoint(pivotTimeframe,PivotsCheck,symbolIndex,symbol);//Gets the values
         calculatetrda(pivotTimeframe,TRDACheck,symbolIndex,symbol);
         break;
      case Camarilla :
         camarillaPivotPoint(pivotTimeframe,PivotsCheck,symbolIndex,symbol);//Gets the values
         break;
      case Woodie :
         woodiePivotPoint(pivotTimeframe,PivotsCheck,symbolIndex,symbol);//Gets the values
         break;
      case Fibonacci :
         fibonacciPivotPoint(pivotTimeframe,PivotsCheck,symbolIndex,symbol);//Gets the values
         calculatetrda(pivotTimeframe,TRDACheck,symbolIndex,symbol);
         break;
      case FVG :
         FVGPP(pivotTimeframe,PivotsCheck,symbolIndex,symbol);//Gets the values
         //calculateFVG(pivotTimeframe,FVGCheck,symbolIndex,symbol);
         calculatekama(pivotTimeframe,FVGCheck,symbolIndex,symbol);
         break;
     }
   for(int i=0; i<numOfPivotPoints; i++)
     {
      if(PivotsCheck[symbolIndex][i]!=Pivots[symbolIndex][i])
        {
         symbolTimeframeTimeP[symbolIndex]=NULL;
         Print(symbolListFinal[symbolIndex]+" "+"checkValuesForValid found a outdated value reseting symbol and updating");
        }
     }
  }
//a filter
bool isUpperLowerBollinger(int symbolIndex)
  {
   bool result=false;
   double symbolBidPrice=SymbolInfoDouble(symbolListFinal[symbolIndex],SYMBOL_BID);
//gets the  current upper/lower bands values of selected symbol and bollinger parameters
   double upperBand=iBands(symbolListFinal[symbolIndex],BBtimeFrame,BBperiod,BBdeviation,BBShift,BBAppliedPrice,1,0);
   double lowerBand=iBands(symbolListFinal[symbolIndex],BBtimeFrame,BBperiod,BBdeviation,BBShift,BBAppliedPrice,2,0);
   if(symbolBidPrice>upperBand || symbolBidPrice<lowerBand)
     {
      result=true;
     }
   return result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CreateLabels()
  {
   string timeOfAlertOption=NULL;
   if(timeChoiceOption==Local)
     {
      timeOfAlertOption="(Local)";
     }
   else
      if(timeChoiceOption==Server)
        {
         timeOfAlertOption="(Server)";
        }

//create headers
   LabelCreate(0,indiName+" pivottimeframeH ",0,widthX,widthY-textH,CORNER_LEFT_UPPER,EnumToString(pivotSelection)+" - "+EnumToString(pivotTimeframe)+" - "+EnumToString(alertModeSelection),FontHeader,fontText,headerColors,0.0,ANCHOR_LEFT_UPPER,false,false,true,0);
   LabelCreate(0,indiName+" symbolH ",0,widthX,widthY,CORNER_LEFT_UPPER,"Symbol",FontHeader,fontText,headerColors,0.0,ANCHOR_LEFT_UPPER,false,false,true,0);
   LabelCreate(0,indiName+" pivotH ",0,widthX+symbolPivotXSpacing,widthY,CORNER_LEFT_UPPER,"Near",FontHeader,fontText,headerColors,0.0,ANCHOR_LEFT_UPPER,false,false,true,0);
   LabelCreate(0,indiName+" pivotAlertH ",0,widthX+symbolPivotXSpacing+pivotPivotAlertXSpacing,widthY,CORNER_LEFT_UPPER,"PP",FontHeader,fontText,headerColors,0.0,ANCHOR_LEFT_UPPER,false,false,true,0);
   LabelCreate(0,indiName+" timeAlertH ",0,widthX+symbolPivotXSpacing+pivotPivotAlertXSpacing+pivotAlertTimeLastXSpacing,widthY,CORNER_LEFT_UPPER,"Time Last Alert"+" "+timeOfAlertOption,FontHeader,fontText,headerColors,0.0,ANCHOR_LEFT_UPPER,false,false,true,0);

   int textSpaceing=textH;

   for(int i=0; i<ArraySize(symbolListFinal); i++)
     {
      LabelCreate(0,indiName+" "+symbolListFinal[i]+" symbol ",0,widthX,widthY+textSpaceing,CORNER_LEFT_UPPER,symbolListFinal[i],Font,fontText,symbolColor,0.0,ANCHOR_LEFT_UPPER,false,false,true,0);
      LabelCreate(0,indiName+" "+symbolListFinal[i]+" pivot ",0,widthX+symbolPivotXSpacing,widthY+textSpaceing,CORNER_LEFT_UPPER,"",Font,fontText,symbolColor,0.0,ANCHOR_LEFT_UPPER,false,false,true,0);
      LabelCreate(0,indiName+" "+symbolListFinal[i]+" pivotAlert ",0,widthX+symbolPivotXSpacing+pivotPivotAlertXSpacing,widthY+textSpaceing,CORNER_LEFT_UPPER,"",Font,fontText,symbolColor,0.0,ANCHOR_LEFT_UPPER,false,false,true,0);
      LabelCreate(0,indiName+" "+symbolListFinal[i]+" timeAlert ",0,widthX+symbolPivotXSpacing+pivotPivotAlertXSpacing+pivotAlertTimeLastXSpacing,widthY+textSpaceing,CORNER_LEFT_UPPER,"",Font,fontText,symbolColor,0.0,ANCHOR_LEFT_UPPER,false,false,true,0);

      textSpaceing+=textH;
     }

   textHEnd=textSpaceing+textH;
   LabelCreate(0,indiName+" listAlertsH ",0,widthX,widthY+textHEnd,CORNER_LEFT_UPPER,"List Of Recent Alerts",FontHeader,fontText,headerColors,0.0,ANCHOR_LEFT_UPPER,false,false,true,0);

   textSpaceing=textH;
   for(int k=0; k<ArraySize(listLabelNames); k++)
     {
      LabelCreate(0,indiName+" "+listLabelNames[k],0,widthX,widthY+textHEnd+textSpaceing,CORNER_LEFT_UPPER,"",Font,fontText,clrWhite,0.0,ANCHOR_LEFT_UPPER,false,false,true,0);
      textSpaceing+=textH;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool LabelCreate(const long              chart_ID=0,               // chart's ID
                 const string            name="Label",             // label name
                 const int               sub_window=0,             // subwindow index
                 const int               x=0,// X coordinate
                 const int               y=0,                      // Y coordinate
                 const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // chart corner for anchoring
                 const string            text="Label",             // text
                 const string            font="Arial",             // font
                 const int               font_size=10,             // font size
                 const color             clr=clrRed,               // color
                 const double            angle=0.0,                // text slope
                 const ENUM_ANCHOR_POINT anchor=ANCHOR_LEFT_UPPER, // anchor type
                 const bool              back=false,               // in the background
                 const bool              selection=false,          // highlight to move
                 const bool              hidden=true,              // hidden in the object list
                 const long              z_order=0)                // priority for mouse click
  {
//--- reset the error value
   ResetLastError();
//--- create a text label
   if(!ObjectCreate(chart_ID,name,OBJ_LABEL,sub_window,0,0))
     {
      Print(__FUNCTION__,
            ": failed to create text label! Error code = ",GetLastError());
      return(false);
     }
//--- set label coordinates
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
//--- set the chart's corner, relative to which point coordinates are defined
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
//--- set the text
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
//--- set text font
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
//--- set font size
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
//--- set the slope angle of the text
   ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle);
//--- set anchor type
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
//--- set color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- enable (true) or disable (false) the mode of moving the label by mouse
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void LabelPivot(int symbolIndex)
  {
   double bidPrice=MarketInfo(symbolListFinal[symbolIndex],MODE_BID);
   double otherCompares=0;
   string pivotName="";

   int numPivotPoints=0;

   switch(pivotSelection)
     {
      case Standard :
         numPivotPoints=21;
         break;
      case Camarilla :
         numPivotPoints=11;
         break;
      case Woodie :
         numPivotPoints=5;
         break;
      case Fibonacci :
         numPivotPoints=15;
         break;
      case FVG :
         numPivotPoints=1;
         break;
     }
   int pivotNearestIndex=0;
   double currentSmallest=MathAbs(bidPrice-Pivots[symbolIndex][0]);//weekly pp

   for(int i=1; i<numPivotPoints; i++)
     {
      otherCompares=MathAbs(bidPrice-Pivots[symbolIndex][i]);

      if(otherCompares<currentSmallest)
        {
         currentSmallest=otherCompares;
         pivotNearestIndex=i;
        }
     }

   switch(pivotSelection)
     {
      case Standard :
         pivotName=standardPivotNames[pivotNearestIndex];
         break;
      case Camarilla :
         pivotName=camarillaPivotNames[pivotNearestIndex];
         break;
      case Woodie :
         pivotName=woodiePivotNames[pivotNearestIndex];
         break;
      case Fibonacci :
         pivotName=fibonacciPivotNames[pivotNearestIndex];
         break;
      case FVG :
         pivotName=FVGPivotNames[pivotNearestIndex];
         break;
     }

   if('R'==StringGetChar(pivotName,0))
     {
      ObjectSetText(indiName+" "+symbolListFinal[symbolIndex]+" pivot ",pivotName,fontText,Font,resistantColor);
     }
   else
      if('P'==StringGetChar(pivotName,0))
        {
         ObjectSetText(indiName+" "+symbolListFinal[symbolIndex]+" pivot ",pivotName,fontText,Font,pivotColor);
        }
      else
         if('S'==StringGetChar(pivotName,0))
           {
            ObjectSetText(indiName+" "+symbolListFinal[symbolIndex]+" pivot ",pivotName,fontText,Font,supportColor);
           }

   ChartRedraw(0);
   WindowRedraw();

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TimeOfAlertLabelUpdate(string symbol,datetime timeCurrent,string pivotName)
  {
   if('R'==StringGetChar(pivotName,0))
     {

      if(usePivotColor==false)
        {
         ObjectSetText(indiName+" "+symbol+" timeAlert ",TimeToStr(timeCurrent,TIME_DATE|TIME_SECONDS),fontText,Font,timeLastAlertColor);
        }
      else
        {
         ObjectSetText(indiName+" "+symbol+" timeAlert ",TimeToStr(timeCurrent,TIME_DATE|TIME_SECONDS),fontText,Font,resistantColor);
        }

     }
   else
      if('P'==StringGetChar(pivotName,0))
        {
         if(usePivotColor==false)
           {
            ObjectSetText(indiName+" "+symbol+" timeAlert ",TimeToStr(timeCurrent,TIME_DATE|TIME_SECONDS),fontText,Font,timeLastAlertColor);
           }
         else
           {
            ObjectSetText(indiName+" "+symbol+" timeAlert ",TimeToStr(timeCurrent,TIME_DATE|TIME_SECONDS),fontText,Font,pivotColor);
           }
        }
      else
         if('S'==StringGetChar(pivotName,0))
           {
            if(usePivotColor==false)
              {
               ObjectSetText(indiName+" "+symbol+" timeAlert ",TimeToStr(timeCurrent,TIME_DATE|TIME_SECONDS),fontText,Font,timeLastAlertColor);
              }
            else
              {
               ObjectSetText(indiName+" "+symbol+" timeAlert ",TimeToStr(timeCurrent,TIME_DATE|TIME_SECONDS),fontText,Font,supportColor);
              }
           }

   ChartRedraw(0);
   WindowRedraw();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ListLabels(string symbol,string message,string pivotLevelName)
  {
   color ppColor=clrNONE;

   for(int k=listLabelSize-1; k>=0; k--)
     {
      //      LabelCreate(0,indiName+listLabelNames[k],0,widthX,widthY+textHEnd+textSpaceing,CORNER_LEFT_UPPER,"poop","Arial Bold",fontText,clrWhite,0.0,ANCHOR_LEFT_UPPER,false,false,true,0);
      if(k>=1)
        {
         string oldText=ObjectDescription(indiName+" "+listLabelNames[k-1]);
         color oldColor=(color)ObjectGetInteger(0,indiName+" "+listLabelNames[k-1],OBJPROP_COLOR);
         ObjectSetText(indiName+" "+listLabelNames[k],oldText,fontText,Font,oldColor);
        }

     }

   if('R'==StringGetChar(pivotLevelName,0))
     {
      ppColor=resistantColor;
      if(usePivotColor==false)
        {
         ObjectSetText(indiName+" "+listLabelNames[0],message,fontText,Font,listLabelColor);
        }
      else
        {
         ObjectSetText(indiName+" "+listLabelNames[0],message,fontText,Font,resistantColor);
        }
     }
   else
      if('P'==StringGetChar(pivotLevelName,0))
        {
         ppColor=pivotColor;
         if(usePivotColor==false)
           {
            ObjectSetText(indiName+" "+listLabelNames[0],message,fontText,Font,listLabelColor);
           }
         else
           {
            ObjectSetText(indiName+" "+listLabelNames[0],message,fontText,Font,pivotColor);
           }
        }
      else
         if('S'==StringGetChar(pivotLevelName,0))
           {
            ppColor=supportColor;
            if(usePivotColor==false)
              {
               ObjectSetText(indiName+" "+listLabelNames[0],message,fontText,Font,listLabelColor);
              }
            else
              {
               ObjectSetText(indiName+" "+listLabelNames[0],message,fontText,Font,supportColor);
              }
           }

   ObjectSetText(indiName+" "+symbol+" pivotAlert ",pivotLevelName,fontText,Font,ppColor);


   ChartRedraw(0);
   WindowRedraw();
  }
//open symbol chart when click on symbol name
void OnChartEvent(const int id,         // Event identifier
                  const long& lparam,   // Event parameter of long type
                  const double& dparam, // Event parameter of double type
                  const string& sparam) // Event parameter of string type
  {
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      string sep=" ";                // A separator as a character
      ushort u_sep;                  // The code of the separator character
      string result[];               // An array to get strings

      string resultRecentAlerts[];

      //--- Get the separator code
      u_sep=StringGetCharacter(sep,0);

      int k=StringSplit(sparam,u_sep,result);

      int resultSize=ArraySize(result);


      if(resultSize==4)//Clicked symbol label
        {
         if(result[2]=="symbol" && indiName==result[0])
           {
            long resultChartOpen = ChartOpen(result[1],openChartTimeFrame);
            
           }
        }

/*
      for(int q=0; q<resultSize; q++)
        {
         Alert(q+" "+result[q]);
        }
*/

      if(resultSize==2)//clicked symbol name in recent list alerts
        {

         if(indiName==result[0])
           {
            string symbolName=(string)ObjectGetString(0,result[0]+" "+result[1],OBJPROP_TEXT);
            
            //gets string name from object text
            int j=StringSplit(symbolName,u_sep,resultRecentAlerts);
            int resultRecentAlertsSize=ArraySize(resultRecentAlerts);
/*
            for(int s=0; s<resultRecentAlertsSize; s++)
              {
               Alert(s+" "+resultRecentAlerts[s]);
              }
*/

            if(resultRecentAlertsSize==3)
              {
               long resultChartOpen = ChartOpen(resultRecentAlerts[0],openChartTimeFrame);
               
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
