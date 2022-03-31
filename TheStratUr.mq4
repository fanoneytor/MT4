//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

input int FontSize = 21;
input int BarsNumber = 21;
input int rachaDe2 = 13;

datetime date;
double high;
double high1;
double low;
double low1;
int counter2 = 0;

void OnTick()
  {
   TheStratNumbers();
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TheStratNumbers()
  {
   for(int i=0; i<=BarsNumber+200; i++)
     {
      ObjectDelete("numero"+(string)i);
      ObjectDelete("HLineHigh"+(string)i);
      ObjectDelete("HLineLow"+(string)i);
      ObjectDelete("Arrow"+(string)i);
     }
   for(int i=BarsNumber; i>0; i--)
     {
      date = iTime(Symbol(), 0, i-1);
      high = iHigh(Symbol(), 0, i-1);
      low = iLow(Symbol(), 0, i-1);
      high1 = iHigh(Symbol(), 0, i);
      low1 = iLow(Symbol(), 0, i);
      if(high>high1 && low<low1)
        {
         ObjectCreate("numero"+(string)i,OBJ_TEXT,0,date, low);
         ObjectSetText("numero"+(string)i,"3",FontSize,"Tahoma",Lime);
         ObjectCreate("HLineHigh"+(string)i,OBJ_HLINE,0,0,high);
         ObjectSetInteger(0,"HLineHigh"+(string)i,OBJPROP_COLOR,Lime);
         ObjectCreate("HLineLow"+(string)i,OBJ_HLINE,0,0,low);
         ObjectSetInteger(0,"HLineLow"+(string)i,OBJPROP_COLOR,Lime);
         counter2 = 0;
        }
      else
         if(high<high1 && low>low1)
           {
            ObjectCreate("numero"+(string)i,OBJ_TEXT,0,date, low);
            ObjectSetText("numero"+(string)i,"1",FontSize,"Tahoma",Gold);
            counter2 = 0;
           }
         else
           {
            ObjectCreate("numero"+(string)i,OBJ_TEXT, 0, date, low);
            ObjectSetText("numero"+(string)i,"2",FontSize,"Tahoma",Aqua);
            if(rachaDe2 != 0)counter2++;
            if(counter2 == rachaDe2){
               ObjectCreate("Arrow"+(string)i, OBJ_ARROW_UP, 0, date, low);
               ObjectSetInteger(0,"Arrow"+(string)i,OBJPROP_COLOR,White);
               ObjectSetInteger(0,"Arrow"+(string)i,OBJPROP_WIDTH,5);
               counter2 = 0;
            }
           }
     }
  }
//+------------------------------------------------------------------+
