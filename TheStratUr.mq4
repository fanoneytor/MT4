#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

int OnInit()
  {
     return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
     
  }

void OnTick()
  {
   TheStratNumbers();      
  }
//+------------------------------------------------------------------+

void TheStratNumbers(){
   datetime date[]; // array for storing dates of visible bars
   double   low[];  // array for storing Low prices of visible bars
   double   high[]; // array for storing High prices of visible bars
//--- number of visible bars in the chart window
   int bars=(int)ChartGetInteger(0,CHART_VISIBLE_BARS);
//--- memory allocation
   ArrayResize(date,bars);
   ArrayResize(low,bars);
   ArrayResize(high,bars);
//--- fill the array of dates
   ResetLastError();
   if(CopyTime(Symbol(),Period(),0,bars,date)==-1)
     {
      Print("Failed to copy time values! Error code = ",GetLastError());
      //return;
     }
//--- fill the array of Low prices
   if(CopyLow(Symbol(),Period(),0,bars,low)==-1)
     {
      Print("Failed to copy the values of Low prices! Error code = ",GetLastError());
      //return;
     }
//--- fill the array of High prices
   if(CopyHigh(Symbol(),Period(),0,bars,high)==-1)
     {
      Print("Failed to copy the values of High prices! Error code = ",GetLastError());
      //return;
     }
     
     for(int i=0;i<bars;i++)
     {
      ObjectDelete("numero"+(string)i);
     }

//--- create texts for High and Low bars' values (with gaps)
   for(int i=1;i<bars;i++)
     {         
         if(high[i]>high[i-1] && low[i]<low[i-1]){
            ObjectCreate("numero"+(string)i,OBJ_TEXT,0,date[i], low[i]);
            ObjectSetText("numero"+(string)i,"3",14,"Tahoma",Lime);
         }else if(high[i]<high[i-1] && low[i]>low[i-1]){
            ObjectCreate("numero"+(string)i,OBJ_TEXT,0,date[i], low[i]);
            ObjectSetText("numero"+(string)i,"1",14,"Tahoma",Gold);
         }else{
            ObjectCreate("numero"+(string)i,OBJ_TEXT, 0, date[i], low[i]);
            ObjectSetText("numero"+(string)i,"2",14,"Tahoma",Aqua);
         } 
     }
}