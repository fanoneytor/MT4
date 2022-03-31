//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

input int FontSize = 10;
input int BarsNumber = 15;

datetime date;
double high;
double high1;
double low;
double low1;
int OnInit()
  {

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   TheStratNumbers();
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TheStratNumbers()
  {
   for(int i=0; i<=BarsNumber; i++)
     {
      ObjectDelete("numero"+(string)i);
     }
   for(int i=0; i<=BarsNumber; i++)
     {
      date = iTime(Symbol(), 0, i);
      high = iHigh(Symbol(), 0, i);
      high1 = iHigh(Symbol(), 0, i+1);
      low = iLow(Symbol(), 0, i);
      low1 = iLow(Symbol(), 0, i+1);
      if(high>high1 && low<low1)
        {
         ObjectCreate("numero"+(string)i,OBJ_TEXT,0,date, low);
         ObjectSetText("numero"+(string)i,"3",FontSize,"Tahoma",Lime);
        }
      else
         if(high<high1 && low>low1)
           {
            ObjectCreate("numero"+(string)i,OBJ_TEXT,0,date, low);
            ObjectSetText("numero"+(string)i,"1",FontSize,"Tahoma",Gold);
           }
         else
           {
            ObjectCreate("numero"+(string)i,OBJ_TEXT, 0, date, low);
            ObjectSetText("numero"+(string)i,"2",FontSize,"Tahoma",Aqua);
           }
     }
  }
//+------------------------------------------------------------------+
