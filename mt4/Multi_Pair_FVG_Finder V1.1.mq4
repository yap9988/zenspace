#property indicator_chart_window
#property strict

input string symbols = "EURUSD,GBPUSD,USDCAD,USDJPY,EURAUD,AUDCHF,GBPJPY,GBPNZD,NAS100";

struct FVG
{
   double low;
   double high;
   double distance;
};

datetime lastCheckedTime = 0;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
   IndicatorShortName("Multi-Symbol FVG Finder");
   Print("FVG Indicator Initialized for symbols: ", symbols);
   return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
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
   datetime currentTime = iTime(_Symbol, PERIOD_H1, 0);
   if (currentTime == lastCheckedTime)
      return(rates_total);

   lastCheckedTime = currentTime;

   SaveAllSymbolsFVGToFile();

   return(rates_total);
}

//+------------------------------------------------------------------+
//| Process all symbols and write their FVGs to file                 |
//+------------------------------------------------------------------+
void SaveAllSymbolsFVGToFile()
{
   string symbolList[];
   StringSplit(symbols, ',', symbolList);

   string fileName = "fvg_levels.txt";
   int fileHandle = FileOpen(fileName, FILE_WRITE | FILE_TXT);

   if (fileHandle == INVALID_HANDLE)
   {
      Print("Failed to write FVGs to file. Error: ", GetLastError());
      return;
   }

   string timestamp = TimeToString(TimeCurrent(), TIME_DATE | TIME_SECONDS);

   for (int s = 0; s < ArraySize(symbolList); s++)
   {
      string sym = StringTrim(symbolList[s]);
      FVG fvgList[5];
      int found = FindNearest5DailyFVGs(sym, fvgList);

      for (int i = 0; i < found; i++)
      {
         string line = StringFormat("%s|%s|%.5f|%.5f",
                                    timestamp,
                                    sym,
                                    fvgList[i].high,
                                    fvgList[i].low);
         FileWrite(fileHandle, line);
      }
   }

   FileClose(fileHandle);
   Print("FVG log written with timestamped format.");
}


//+------------------------------------------------------------------+
//| Find top 5 FVGs for a given symbol                               |
//+------------------------------------------------------------------+
int FindNearest5DailyFVGs(string symbol, FVG &fvgOut[5])
{
MqlRates rates[1000];  // Array to store the historical data
int barsLoaded = CopyRates(symbol, PERIOD_D1, 0, 1000, rates); // Corrected CopyRates usage

   int maxBars = 200;
   double currentPrice = SymbolInfoDouble(symbol, SYMBOL_BID);
   FVG tempList[100];
   int count = 0;

   for (int i = 2; i < maxBars; i++)
   {
      double low     = iLow(symbol, PERIOD_D1, i);
      double high2   = iHigh(symbol, PERIOD_D1, i + 2);
      double close1  = iClose(symbol, PERIOD_D1, i + 1);

      if (low > high2 && close1 > high2)
      {


      
      

         tempList[count].low = low;
         tempList[count].high = high2;
         tempList[count].distance = MathAbs(currentPrice - (low + high2) / 2.0);
      
         // Print values to log for debugging
         Print("FVG[", count, "] ", 
               "Symbol=", symbol, 
               " | Low=", DoubleToString(tempList[count].low, Digits),
               " | High=", DoubleToString(tempList[count].high, Digits),
               " | Distance=", DoubleToString(tempList[count].distance, Digits));
      
         count++;
           
      
      
      
      }
   }

   // Sort by distance
   for (int i = 0; i < count - 1; i++)
   {
      for (int j = i + 1; j < count; j++)
      {
         if (tempList[j].distance < tempList[i].distance)
         {
            FVG tmp = tempList[i];
            tempList[i] = tempList[j];
            tempList[j] = tmp;
         }
      }
   }

   int limit = MathMin(5, count);
   for (int i = 0; i < limit; i++)
      fvgOut[i] = tempList[i];

   return limit;
}

string StringTrim(string str)
{
   int start = 0;
   int end = StringLen(str) - 1;

   while (start <= end && StringGetCharacter(str, start) == ' ') start++;
   while (end >= start && StringGetCharacter(str, end) == ' ') end--;

   if (start > end)
      return "";

   return StringSubstr(str, start, end - start + 1);
}
