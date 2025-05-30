#property indicator_chart_window
#property strict

input string symbols = "EURUSD,GBPUSD,USDCAD,USDJPY,EURAUD,AUDCHF,GBPJPY,GBPNZD,NAS100";
input int    MaxFVGsPerSymbol = 5;

struct FVG {
   double low;
   double high;
   double distance;
};

datetime lastExecutionTime = 0;

//+------------------------------------------------------------------+
//|                                                                  |
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
   if (TimeHour(TimeCurrent()) == TimeHour(lastExecutionTime)) return(rates_total);
   lastExecutionTime = TimeCurrent();

   string symbolList[];  int symCount = StringSplit(symbols, ',', symbolList);
   int fileHandle = FileOpen("FVG_Output.txt", FILE_WRITE|FILE_TXT);
   if (fileHandle == INVALID_HANDLE) return(rates_total);

  for (int s = 0; s < symCount; s++) {
     string sym = StringTrim(symbolList[s]);
     if (iBars(sym, PERIOD_D1) == 0) continue;

      double fvgLow[100], fvgHigh[100], fvgDist[100];
      int found = 0;

      for (int i = 0; i < 1000; i++) {
         double l0 = iLow(sym, PERIOD_D1, i);
         double h2 = iHigh(sym, PERIOD_D1, i + 2);
         double c1 = iClose(sym, PERIOD_D1, i + 1);

         if (l0 == 0 || h2 == 0 || c1 == 0) continue;

         if (l0 > h2 && c1 > h2) {
            fvgLow[found] = l0;
            fvgHigh[found] = h2;
            fvgDist[found] = MathAbs(MarketInfo(sym, MODE_BID) - ((l0 + h2) / 2));
            found++;
            if (found >= 100) break;
         }
      }

      // Bubble sort by distance
      for (int i = 0; i < found - 1; i++) {
         for (int j = i + 1; j < found; j++) {
            if (fvgDist[j] < fvgDist[i]) {
               double tmpL = fvgLow[i];   double tmpH = fvgHigh[i];  double tmpD = fvgDist[i];
               fvgLow[i] = fvgLow[j];     fvgHigh[i] = fvgHigh[j];   fvgDist[i] = fvgDist[j];
               fvgLow[j] = tmpL;          fvgHigh[j] = tmpH;         fvgDist[j] = tmpD;
            }
         }
      }

      datetime now = TimeCurrent();
      string ts = TimeToString(now, TIME_DATE|TIME_MINUTES|TIME_SECONDS);
      int precision = (int)MarketInfo(sym, MODE_DIGITS);

      for (int i = 0; i < MathMin(found, MaxFVGsPerSymbol); i++) {
         if (fvgLow[i] > 0 && fvgHigh[i] > 0) {
            string line = ts + "|" + sym + "|" + 
                          DoubleToString(fvgLow[i], precision) + "|" +
                          DoubleToString(fvgHigh[i], precision);
            FileWrite(fileHandle, line);
         }
      }
   }

   FileClose(fileHandle);
   return(rates_total);
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