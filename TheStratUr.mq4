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

input double Volumen = 0.01;
input double SlPoints = 50;
input double TpPoints = 75;
input int FontSize = 21;
input int BarsNumber = 21;
input int rachaDe2 = 13;
input int OrdenesPorVela = 3;

//Variables Globales

int counter2 = 0;// Contador para poner arrow en la vela #2 que se especifique en el parametro rachaDe2
double lineas[]= {0, 0, 1000000, 1000000};
double BarsCount = 0;
//+------------------------------------------------------------------+
//|Funcion que se ejecuta concada tick.
//+------------------------------------------------------------------+
void OnTick()
  {
   SendOrder();
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
         AnalisisLineas(high, low);
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
   for(int i=0; i<4; i++)
     {
      DibujarLineaH(i, lineas[i]);
     }
   lineas[0]=0;
   lineas[1]=0;
   lineas[2]=1000000;
   lineas[3]=1000000;
  }


//+------------------------------------------------------------------+
//|Dibuja los numeros debajo de las velas
//+------------------------------------------------------------------+
void DibujarNumeros(int i, string numero, datetime date, double low, color c)
  {
   ObjectCreate("numero"+(string)i,OBJ_TEXT,0,date, low);
   ObjectSetText("numero"+(string)i, numero, FontSize, "Tahoma", c);
  }
//+------------------------------------------------------------------+
//|Dibuja Linea Horizontal
//+------------------------------------------------------------------+
void DibujarLineaH(int i, double posicion)
  {
   ObjectCreate("HLineHigh"+(string)i,OBJ_HLINE,0,0,posicion);
   ObjectSetInteger(0,"HLineHigh"+(string)i,OBJPROP_COLOR,Lime);
  }

//+------------------------------------------------------------------------------------------------+
//|Llena un vector con los valores de las 2 lineas mas altas y las dos mas bajas de las velas #3
//+------------------------------------------------------------------------------------------------+
void AnalisisLineas(double high, double low)
  {
   if(high > lineas[0])
     {
      lineas[1]=lineas[0];
      lineas[0] = high;
     }
   if(low < lineas[2])
     {
      lineas[3] = lineas[2];
      lineas[2] = low;
     }
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void SendOrder()
  {
   double open = iOpen(Symbol(),0, 1);
   double close = iClose(Symbol(), 0, 1);
   
   double slb = NormalizeDouble(Ask - SlPoints * Point, Digits);
   double tpb = NormalizeDouble(Ask + TpPoints * Point, Digits);
   
   double sls = NormalizeDouble(Bid + SlPoints * Point, Digits);
   double tps = NormalizeDouble(Bid - TpPoints * Point, Digits);
   
   int ticket;
   
   if(Bars > BarsCount && close > open)
     {
      for(int i=0; i<OrdenesPorVela; i++)
        {
         ticket = OrderSend(Symbol(), OP_BUY, Volumen, Ask, 0, slb, tpb, "Compra con bot", 0, 0,NULL);
        }
      BarsCount = Bars;
     }
   if(Bars > BarsCount && close < open)
     {
      for(int i=0; i<OrdenesPorVela; i++)
        {
         ticket = OrderSend(Symbol(), OP_SELL, Volumen, Bid, 0, sls, tps, "Venta con bot", 0, 0, NULL);
        }
      BarsCount = Bars;
     }
  }
//+------------------------------------------------------------------+