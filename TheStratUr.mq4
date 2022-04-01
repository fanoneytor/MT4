//+------------------------------------------------------------------+
//|                                                      TheStratUr
//|
//|
//+------------------------------------------------------------------+
#property copyright ""
#property link      ""
#property version   "1.00"
#property strict

//Parametros de la interfaz.

input int FontSize = 21;
input int BarsNumber = 21;
input int rachaDe2 = 13;

//Variables Globales

int counter2 = 0;// Contador para poner arrow en la vela #2 que se especifique en el parametro rachaDe2
double maxHigh = 0; //Variable que guarda el high mas alto entre las velas #3
double maxHigh1 = 0;
double minLow = 1000000; //Variable que guarda el low mas bajo entre las velas #3
double minLow1 = 1000000;

//+------------------------------------------------------------------+
//|Funcion que se ejecuta concada tick.
//+------------------------------------------------------------------+
void OnTick()
  {
   TheStratNumbers();
  }

//+-------------------------------------------------------------------------------------------------------------+
//|Funcion que analiza los tipos de tipos de posiciones de las velas para indentificar los #1, #2 y #3 de Strat.
//+-------------------------------------------------------------------------------------------------------------+
void TheStratNumbers()
  {
   datetime date;
   double high;
   double high1;
   double low;
   double low1;
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
         DibujarNumeros(i, "3", date, low, Lime);
         LineasHorizontales(i, high, low);
         counter2 = 0;
        }
      else
         if(high<high1 && low>low1)
           {
            DibujarNumeros(i, "1", date, low, Gold);
            counter2 = 0;
           }
         else
           {
            DibujarNumeros(i, "2", date, low, Aqua);
            if(rachaDe2 != 0)
               counter2++;
            if(counter2 == rachaDe2)
              {
               ObjectCreate("Arrow"+(string)i, OBJ_ARROW_UP, 0, date, low);
               ObjectSetInteger(0,"Arrow"+(string)i,OBJPROP_COLOR,White);
               ObjectSetInteger(0,"Arrow"+(string)i,OBJPROP_WIDTH,5);
               counter2 = 0;
              }
           }
     }
  }


//+------------------------------------------------------------------+
//|Dibuja los numeros debajo de las velas
//+------------------------------------------------------------------+
void DibujarNumeros(int i, string numero, datetime date, double low, color c)
  {
   ObjectCreate("numero"+(string)i,OBJ_TEXT,0,date, low);
   ObjectSetText("numero"+(string)i, numero, FontSize, "Tahoma", c);
  }

//+-----------------------------------------------------------------------------------+
//|Dibuja las lineas horizontales en el mayor High y el menor low de los #3.
//+-----------------------------------------------------------------------------------+
void LineasHorizontales(int i, double high, double low)
  {
   if(high >= maxHigh)
     {
      ObjectCreate("HLineHigh"+(string)i,OBJ_HLINE,0,0,high);
      ObjectSetInteger(0,"HLineHigh"+(string)i,OBJPROP_COLOR,Lime);
      maxHigh = high;
     }
   if(high < maxHigh && high >= maxHigh1)
     {
      ObjectCreate("HLineHigh"+(string)i,OBJ_HLINE,0,0,high);
      ObjectSetInteger(0,"HLineHigh"+(string)i,OBJPROP_COLOR,Lime);
      maxHigh1 = high;
     }
   if(low <= minLow)
     {
      ObjectCreate("HLineLow"+(string)i,OBJ_HLINE,0,0,low);
      ObjectSetInteger(0,"HLineLow"+(string)i,OBJPROP_COLOR,Lime);
      minLow = low;
     }
     if(low > minLow && low <= minLow1)
     {
      ObjectCreate("HLineLow"+(string)i,OBJ_HLINE,0,0,low);
      ObjectSetInteger(0,"HLineLow"+(string)i,OBJPROP_COLOR,Lime);
      minLow1 = low;
     }
  }
//+------------------------------------------------------------------+
