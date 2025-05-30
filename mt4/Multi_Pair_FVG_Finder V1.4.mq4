//v1.2 - chartopen
//v1.3 - plus bear
//v1.4 - plus mitigated parameter


#property indicator_chart_window
#property strict

input string symbols = "EURUSD,GBPUSD,USDCAD,USDJPY,EURAUD,AUDCHF,GBPJPY,GBPNZD,NAS100";

struct FVG {
   double low;
   double high;
   double distance;
   bool mitigated; // New field
};

datetime lastCheckedTime = 0;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {
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
                const int &spread[]) {
   datetime currentTime = iTime(_Symbol, PERIOD_D1, 0);
   if (currentTime == lastCheckedTime)
      return(rates_total);

   lastCheckedTime = currentTime;

   SaveAllSymbolsFVGToFile();

   return(rates_total);
}

//+------------------------------------------------------------------+
//| Process all symbols and write their FVGs to file                 |
//+------------------------------------------------------------------+
void SaveAllSymbolsFVGToFile() {
   string symbolList[];
   StringSplit(symbols, ',', symbolList);

   string fileName = "satetrading/fvg_levels.txt";
   int fileHandle = FileOpen(fileName, FILE_WRITE | FILE_TXT);

   if (fileHandle == INVALID_HANDLE) {
      Print("Failed to write FVGs to file. Error: ", GetLastError());
      return;
   }

   string timestamp = TimeToString(TimeCurrent(), TIME_DATE | TIME_SECONDS);

   for (int s = 0; s < ArraySize(symbolList); s++) {
      string sym = StringTrim(symbolList[s]);

      // 🔄 Force history preload via ChartOpen and iBars
      long chartID = ChartOpen(sym, PERIOD_D1);
      if (chartID == 0) {
         Print("Failed to open chart for symbol ", sym);
         continue;
      }

      int retries = 0;
      while (iBars(sym, PERIOD_D1) < 100 && retries < 20) {
         Sleep(500); // Give time for data to load
         retries++;
      }

      if (iBars(sym, PERIOD_D1) < 100) {
         Print("Not enough history for symbol: ", sym);
         continue;
      }

      FVG fvgList[10];
      string fvgLabels[10];
      int found = FindTop5BullAndBearFVGs(sym, fvgList, fvgLabels);
      
      for (int i = 0; i < found; i++) {
                                
         string line = StringFormat("%s|%s|%s|%.5f|%.5f|%s",
                                    timestamp,
                                    sym,
                                    fvgLabels[i],
                                    fvgList[i].low,
                                    fvgList[i].high,
                                    fvgList[i].mitigated ? "Y" : "N");


                                    
         FileWrite(fileHandle, line);
      }

   }

   FileClose(fileHandle);
   Print("FVG log written with timestamped format.");
}

//+------------------------------------------------------------------+
//| Find top 5 FVGs for a given symbol                               |
//+------------------------------------------------------------------+
int FindTop5BullAndBearFVGs(string symbol, FVG &fvgOut[10], string &labelsOut[10]) {
   MqlRates rates[1000];
   if (CopyRates(symbol, PERIOD_D1, 0, 1000, rates) <= 0) {
      Print("Failed to load rates for ", symbol);
      return 0;
   }

   int maxBars = 200;
   double currentPrice = SymbolInfoDouble(symbol, SYMBOL_BID);

   FVG bullList[100], bearList[100];
   int bullCount = 0, bearCount = 0;

   for (int i = 1; i < maxBars; i++) {
      double low0 = iLow(symbol, PERIOD_D1, i);
      double high0 = iHigh(symbol, PERIOD_D1, i);
      double high2 = iHigh(symbol, PERIOD_D1, i + 2);
      double low2 = iLow(symbol, PERIOD_D1, i + 2);
      double close1 = iClose(symbol, PERIOD_D1, i + 1);


      // Bullish FVG
      if (low0 > high2 && close1 > high2) {
         bool mitigated = false;
         for (int j = i; j >= 1; j--) {
            double testLow = iLow(symbol, PERIOD_D1, j);
            if (testLow <= low0) {
               mitigated = true;
               break;
            }
         }
         bullList[bullCount].low = high2;
         bullList[bullCount].high = low0;
         bullList[bullCount].distance = MathAbs(currentPrice - (low0 + high2) / 2.0);
         bullList[bullCount].mitigated = mitigated;
         bullCount++;
      }
   
      // Bearish FVG
      if (high0 < low2 && close1 < low2) {
         bool mitigated = false;
         for (int j = i; j >= 1; j--) {
            double testHigh = iHigh(symbol, PERIOD_D1, j);
            if (testHigh >= high0) {
               mitigated = true;
               break;
            }
         }
         bearList[bearCount].low = high0;
         bearList[bearCount].high = low2;
         bearList[bearCount].distance = MathAbs(currentPrice - (high0 + low2) / 2.0);
         bearList[bearCount].mitigated = mitigated;
         bearCount++;
      }
   }

   // Sort bullList
   for (int i = 0; i < bullCount - 1; i++) {
      for (int j = i + 1; j < bullCount; j++) {
         if (bullList[j].distance < bullList[i].distance) {
            FVG tmp = bullList[i];
            bullList[i] = bullList[j];
            bullList[j] = tmp;
         }
      }
   }

   // Sort bearList
   for (int i = 0; i < bearCount - 1; i++) {
      for (int j = i + 1; j < bearCount; j++) {
         if (bearList[j].distance < bearList[i].distance) {
            FVG tmp = bearList[i];
            bearList[i] = bearList[j];
            bearList[j] = tmp;
         }
      }
   }

   int total = 0;

   int bullLimit = MathMin(5, bullCount);
   for (int i = 0; i < bullLimit; i++) {
      fvgOut[total] = bullList[i];
      labelsOut[total] = "^";
      total++;
   }

   int bearLimit = MathMin(5, bearCount);
   for (int i = 0; i < bearLimit; i++) {
      fvgOut[total] = bearList[i];
      labelsOut[total] = "v";
      total++;
   }

   return total;
}



string StringTrim(string str) {
   int start = 0;
   int end = StringLen(str) - 1;

   while (start <= end && StringGetCharacter(str, start) == ' ') start++;
   while (end >= start && StringGetCharacter(str, end) == ' ') end--;

   if (start > end)
      return "";
Print(str, start, end - start + 1); 
   return StringSubstr(str, start, end - start + 1);
}
