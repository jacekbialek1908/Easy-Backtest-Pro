//+------------------------------------------------------------------+
//|                                            Easy backtest pro.mq4 |
//|                                         Copyright 2021, JB FOREX |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, JB FOREX"
#property link      "https://www.mql5.com/en/users/jacekbialek/seller#products"
#property version   "1.00"
#property strict

#include <Controls/Dialog.mqh>
#include <Controls/Button.mqh>
#include <Controls/Label.mqh>
#include <Controls/CheckGroup.mqh>



CAppDialog  Interface, SmallInterfzace ;

CEdit       MsgDemo;

CWndClient  WndClient, WndClient2, WndClient3, WndClient4;

CLabel      Currency;
CLabel      AtrLabel;

CLabel      OrderTotalMenu;
CLabel      OrderTotalLotsMenu;
CLabel      OrderTotalProfitMenu;

CLabel      OrderTotal;
CLabel      OrderTotalLots;
CLabel      OrderTotalProfit;

CLabel      Message;

CEdit      Balance;
CEdit      Equity;
CEdit      FreeMargin;

CEdit      BalanceNb;
CEdit      EquityNb;
CEdit      FreeMarginNb;

CButton buy,sell,closefirst, closelast, closeall,buystop,buylimit,sellstop,selllimit,plus, minus,incSL,decSL,incTP,decTP, breakeven,calcLotRisk,calcTpatr,calcSlatr ;
CEdit lotbuy,lotsell,tpsize,slsize,atrm,atredit,riskm, riskedit;
CEdit title, title2;
CEdit AutoBEVEdit, AutoTrailingStopEdit;

CCheckBox   AutoLot,AutoTpSl,AutoBEV, AutoTrailingStop, AutoTwoPositions, DailyHighLow, PivotPoints, Fibo;

CButton BtnCandle,BtnGrid;

//+------------------------------------------------------------------+
//| Extern variables                                   |
//+------------------------------------------------------------------+
extern int    left_right = 50;                            //Position from left to right
extern int    up_down = 300;                              //Position from the top to the bottom

extern int    pipsToBumpWhenMovingSLorTP = 5;             //SL and TP pips move when push (+ , -)
extern double breakevenPipsSize = 0.5;                    //Pips level after breakeven

extern int    pendingOrdersDistance = 30;                       //Pending order initial distance (pips)

extern double lotsize = 0.01;                                //Lot size
extern int    StopLoss=25;                                   //Stop loss
extern int    TakeProfit=25;                                 //Take profit

//+------------------------------------------------------------------+
//| Global variables                                   |
//+------------------------------------------------------------------+
double pips  = _Point;
int startBar = 0;


//+------------------------------------------------------------------+
//| Panel Create                                  |
//+------------------------------------------------------------------+
void PanelCreate()
  {
   double buttonWidth = 100, buttonHeight = 50;
   int interfaceWidth = 715, interfaceHeight = 160;

   Interface.Create(0,"JB",0,left_right,up_down,left_right + interfaceWidth,up_down + interfaceHeight);

   Currency.Create(0,"currency",0,0,0,0,0);
   Interface.Add(Currency);

   Currency.Color(clrBlack);
   Currency.Shift(282,-20);

   AtrLabel.Create(0,"AtrLabel",0,0,0,0,0);
   Interface.Add(AtrLabel);

   AtrLabel.Color(clrBlack);
   AtrLabel.Shift(110,-20);

   BtnCandle.Create(0, "Candle", 0, 0, 1,50,  22);
   BtnCandle.Text("Candle");
   BtnCandle.FontSize(10);
   BtnCandle.ColorBackground(clrDodgerBlue);
   BtnCandle.Color(clrLightYellow);
   BtnCandle.Font("Georgia");
   BtnCandle.ColorBorder(clrDarkGray);
   Interface.Add(BtnCandle);
   BtnCandle.Shift(564,-23);

   BtnGrid.Create(0, "BtnGrid", 0, 0, 1,50,  22);
   BtnGrid.Text("Grid");
   BtnGrid.FontSize(10);
   BtnGrid.ColorBackground(clrDodgerBlue);
   BtnGrid.Color(clrLightYellow);
   BtnGrid.Font("Georgia");
   BtnGrid.ColorBorder(clrDarkGray);
   Interface.Add(BtnGrid);
   BtnGrid.Shift(615,-23);



   WndClient.Create(0,"WnpClient",0,280,3,704,30);
   WndClient.ColorBackground(clrGainsboro);
   WndClient.ColorBorder(clrWhiteSmoke);
   Interface.Add(WndClient);

   WndClient2.Create(0,"WndClient2",0,280,30,704,70);
   WndClient2.ColorBackground(clrWhite);
   WndClient2.ColorBorder(clrWhiteSmoke);
   Interface.Add(WndClient2);

   WndClient3.Create(0,"WndClient3",0,280,72,704,130);
   WndClient3.ColorBackground(clrGray);
   WndClient3.ColorBorder(clrWhiteSmoke);
   Interface.Add(WndClient3);

//window with the check box---------------------
   AutoBEV.Create(0,"AutoBEV",0,2,4,110,28);
   AutoBEV.Text("auto BEV  |if");
   AutoBEV.Color(clrBlack);
   WndClient3.Add(AutoBEV);

   AutoTrailingStop.Create(0,"AutoTrailingStop",0,2,30,110,53);
   AutoTrailingStop.Text("auto T-stop");
   AutoTrailingStop.Color(clrBlack);
   WndClient3.Add(AutoTrailingStop);

   AutoBEVEdit.Create(0,"AutoBEVEdit",0,112, 3,139,28);
   AutoBEVEdit.FontSize(10);
   AutoBEVEdit.Text((string)5);
   AutoBEVEdit.TextAlign(ALIGN_CENTER);
   AutoBEVEdit.ColorBorder(clrDarkGray);
   WndClient3.Add(AutoBEVEdit);

   AutoTrailingStopEdit.Create(0,"AutoTrailingStopEdit",0,112, 30,139,54);
   AutoTrailingStopEdit.FontSize(10);
   AutoTrailingStopEdit.Text((string)5);
   AutoTrailingStopEdit.TextAlign(ALIGN_CENTER);
   AutoTrailingStopEdit.ColorBorder(clrDarkGray);
   WndClient3.Add(AutoTrailingStopEdit);

   AutoTwoPositions.Create(0,"AutoTwoPositions",0,144,4,271,28);
   AutoTwoPositions.Text("2 pos. 1/2 lot");
   AutoTwoPositions.Color(clrBlack);
   WndClient3.Add(AutoTwoPositions);

   DailyHighLow.Create(0,"DailyHighLow",0,144,30,271,54);
   DailyHighLow.Text("daily High/Low");
   DailyHighLow.Color(clrBlack);
   WndClient3.Add(DailyHighLow);

   PivotPoints.Create(0,"PivotPoints",0,276,4,401,28);
   PivotPoints.Text("pivot points");
   PivotPoints.Color(clrBlack);
   WndClient3.Add(PivotPoints);

   Fibo.Create(0,"Fibo",0,276,30,401,54);
   Fibo.Text("fibonacci");
   Fibo.Color(clrBlack);
   WndClient3.Add(Fibo);


   Balance.Create(0,"balance",0,2,2,60,25);
   Balance.Text("Balance:");
   Balance.ColorBackground(clrWhiteSmoke);
   Balance.Shift(0,0);
   Balance.Font("Georgia");
   Balance.FontSize(8);
   Balance.Color(clrBlack);
   WndClient.Add(Balance);

   BalanceNb.Create(0,"balanceNb",0,58,2,135,25);
   BalanceNb.Text("0 " + AccountCurrency());
   BalanceNb.FontSize(8);
   BalanceNb.TextAlign(ALIGN_CENTER);
   BalanceNb.ColorBackground(clrWhite);
   BalanceNb.Shift(0,0);
   Balance.Color(clrBlack);
   WndClient.Add(BalanceNb);

   Equity.Create(0,"equity",0,132,2,184,25);
   Equity.Shift(0,0);
   Equity.Text("Equity:") ;
   Equity.ColorBackground(clrWhiteSmoke);
   Equity.Font("Georgia");
   Equity.FontSize(8);
   Equity.Color(clrBlack);
   WndClient.Add(Equity);

   EquityNb.Create(0,"equityNb",0,180,2,258,25);
   EquityNb.FontSize(8);
   EquityNb.Shift(0,0);
   EquityNb.TextAlign(ALIGN_CENTER);
   EquityNb.Text("0 " + AccountCurrency());
   Balance.Color(clrBlack);
   WndClient.Add(EquityNb);

   FreeMargin.Create(0,"freeMargin",0,256,2,353,25);
   FreeMargin.Shift(0,0);
   FreeMargin.Text("FreeMargin:");
   FreeMargin.ColorBackground(clrWhiteSmoke);
   FreeMargin.Font("Georgia");
   FreeMargin.FontSize(8);
   Balance.Color(clrBlack);
   WndClient.Add(FreeMargin);

   FreeMarginNb.Create(0,"freeMarginNb",0,265,2,348,25);
   FreeMarginNb.FontSize(8);
   FreeMarginNb.Shift(75,0);
   FreeMarginNb.TextAlign(ALIGN_CENTER);
   FreeMarginNb.Text("0 " + AccountCurrency());
   Balance.Color(clrBlack);
   WndClient.Add(FreeMarginNb);


//button start here---
   buy.Create(0, "buy", 0, 2, 2,77,  42);
   buy.Text("BUY");
   buy.FontSize(20);
   buy.ColorBackground(clrGreen);
   buy.Color(clrLightYellow);
   buy.Font("Georgia");
   buy.ColorBorder(clrDarkGray);
   Interface.Add(buy);

   buystop.Create(0, "buystop", 0,79, 2,130, 23);
   buystop.Text("Buy Limit");
   buystop.FontSize(7);
   buystop.ColorBackground(clrWhiteSmoke);
   buystop.Color(clrBlack);
   buystop.Font("Georgia");
   buystop.ColorBorder(clrDarkGray);
   Interface.Add(buystop);

   buylimit.Create(0, "buylimit", 0,79,21,130,41);
   buylimit.Text("Buy Stop");
   buylimit.FontSize(7);
   buylimit.ColorBackground(clrWhiteSmoke);
   buylimit.Color(clrBlack);
   buylimit.Font("Georgia");
   buylimit.ColorBorder(clrDarkGray);
   Interface.Add(buylimit);

   selllimit.Create(0, "selllimit", 0,149, 2,201,22);
   selllimit.Text("Sell Limit");
   selllimit.FontSize(7);
   selllimit.ColorBackground(clrWhiteSmoke);
   selllimit.Color(clrBlack);
   selllimit.Font("Georgia");
   selllimit.ColorBorder(clrDarkGray);
   Interface.Add(selllimit);

   sellstop.Create(0, "sellstop", 0,149,21,201,41);
   sellstop.Text("Sell Stop");
   sellstop.FontSize(7);
   sellstop.ColorBackground(clrWhiteSmoke);
   sellstop.Color(clrBlack);
   sellstop.Font("Georgia");
   sellstop.ColorBorder(clrDarkGray);
   Interface.Add(sellstop);

   plus.Create(0, "plus", 0, 129, 2,150,22);
   plus.Text("+");
   plus.FontSize(7);
   plus.ColorBackground(clrWhiteSmoke);
   plus.Color(clrBlack);
   plus.Font("Georgia");
   plus.ColorBorder(clrDarkGray);
   Interface.Add(plus);

   minus.Create(0, "minus", 0,129,21, 150,41);
   minus.Text("-");
   minus.FontSize(7);
   minus.ColorBackground(clrWhiteSmoke);
   minus.Color(clrBlack);
   minus.Font("Georgia");
   minus.ColorBorder(clrDarkGray);
   Interface.Add(minus);

   sell.Create(0, "sell", 0,203, 2,278,42);
   sell.Text("SELL");
   sell.FontSize(20);
   sell.ColorBackground(clrIndianRed);
   sell.Color(clrLightYellow);
   sell.Font("Georgia");
   sell.ColorBorder(clrDarkGray);
   Interface.Add(sell);

   closefirst.Create(0, "closefirst", 0,79,43, 141, 69);
   closefirst.Text("Close first");
   closefirst.FontSize(8);
   closefirst.ColorBackground(clrWhiteSmoke);
   closefirst.Color(clrBlack);
   closefirst.Font("Georgia");
   closefirst.ColorBorder(clrDarkGray);
   Interface.Add(closefirst);

   closelast.Create(0, "closelast", 0,139,43, 201, 69);
   closelast.Text("Close last");
   closelast.FontSize(8);
   closelast.ColorBackground(clrWhiteSmoke);
   closelast.Color(clrBlack);
   closelast.Font("Georgia");
   closelast.ColorBorder(clrDarkGray);
   Interface.Add(closelast);

   closeall.Create(0, "closeall", 0,79,68, 201, 92);
   closeall.Text("Close all");
   closeall.FontSize(11);
   closeall.ColorBackground(clrWhiteSmoke);
   closeall.Color(clrBlack);
   closeall.Font("Georgia");
   closeall.ColorBorder(clrDarkGray);
   Interface.Add(closeall);

   incTP.Create(0, "incTP", 0,2,44, 77, 69);
   incTP.Text("TP+");
   incTP.FontSize(9);
   incTP.ColorBackground(clrWhiteSmoke);
   incTP.Color(clrBlack);
   incTP.Font("Georgia");
   incTP.ColorBorder(clrDarkGray);
   Interface.Add(incTP);

   decTP.Create(0, "decTP", 0, 2,67, 77, 92);
   decTP.Text("TP-");
   decTP.FontSize(9);
   decTP.ColorBackground(clrWhiteSmoke);
   decTP.Color(clrBlack);
   decTP.Font("Georgia");
   decTP.ColorBorder(clrDarkGray);
   Interface.Add(decTP);

   incSL.Create(0, "incSL", 0,203,44, 278,69);
   incSL.Text("SL+");
   incSL.FontSize(9);
   incSL.ColorBackground(clrWhiteSmoke);
   incSL.Color(clrBlack);
   incSL.Font("Georgia");
   incSL.ColorBorder(clrDarkGray);
   Interface.Add(incSL);

   decSL.Create(0, "decSL", 0,203,67,278, 92);
   decSL.Text("SL-");
   decSL.FontSize(10);
   decSL.ColorBackground(clrWhiteSmoke);
   decSL.Color(clrBlack);
   decSL.Font("Georgia");
   decSL.ColorBorder(clrDarkGray);
   Interface.Add(decSL);

   lotbuy.Create(0,"lotbuy",0,25, 0, 55,20);
   lotbuy.FontSize(10);
   lotbuy.Text((string)lotsize);
   lotbuy.ColorBackground(clrWhite);
   lotbuy.TextAlign(ALIGN_CENTER);
   lotbuy.ColorBorder(clrDarkGray);
   Interface.Add(lotbuy);
   lotbuy.Shift(0,-10);

   lotsell.Create(0,"lotsell",0,225, 0,255,20);
   lotsell.FontSize(10);
   lotsell.Text((string)lotsize);
   lotsell.ColorBackground(clrWhite);
   lotsell.TextAlign(ALIGN_CENTER);
   lotsell.ColorBorder(clrDarkGray);
   Interface.Add(lotsell);
   lotsell.Shift(0,-10);

   breakeven.Create(0,"breakeven",0,253,55,278,78);
   breakeven.FontSize(9);
   breakeven.Text("BEV");
   breakeven.ColorBackground(clrDodgerBlue);
   breakeven.Color(clrWhite);
   breakeven.ColorBorder(clrDarkGray);
   Interface.Add(breakeven);

   tpsize.Create(0,"tpsize",0,53,54, 77,79);
   tpsize.FontSize(10);
   tpsize.Text("20");
   tpsize.TextAlign(ALIGN_CENTER);
   tpsize.ColorBorder(clrDarkGray);
   Interface.Add(tpsize);

   slsize.Create(0,"slsize",0,203,54,227,79);
   slsize.FontSize(10);
   slsize.Text(IntegerToString(20));
   slsize.TextAlign(ALIGN_CENTER);
   slsize.ColorBorder(clrDarkGray);
   Interface.Add(slsize);

   atrm.Create(0,"atrm",0,140,93,201,109);
   atrm.FontSize(9);
   atrm.Text("x ATR");
   atrm.TextAlign(ALIGN_CENTER);
   atrm.ColorBackground(clrWhiteSmoke);
   atrm.Color(clrBlack);
   atrm.ColorBorder(clrDarkGray);
   atrm.ReadOnly(true);
   Interface.Add(atrm);

   atredit.Create(0,"atredit",0,140,108, 201, 129);
   atredit.ColorBackground(clrWhite);
   atredit.ColorBorder(clrDarkGray);
   atredit.Text(DoubleToString(1.5,1));
   Interface.Add(atredit);

   riskm.Create(0,"riskm",0,79, 93, 141,109);
   riskm.FontSize(8);
   riskm.Text("RISK %");
   riskm.Font("Georgia");
   riskm.ColorBackground(clrWhiteSmoke);
   riskm.TextAlign(ALIGN_CENTER);
   riskm.Color(clrBlack);
   riskm.ColorBorder(clrDarkGray);
   riskm.ReadOnly(true);
   Interface.Add(riskm);

   riskedit.Create(0,"riskedit",0,79,108, 141, 129);
   riskedit.ColorBackground(clrWhite);
   riskedit.ColorBorder(clrDarkGray);
   riskedit.Text(IntegerToString(1));
   Interface.Add(riskedit);

   calcLotRisk.Create(0,"calcLotRisk",0,2, 93, 77,109);
   calcLotRisk.FontSize(8);
   calcLotRisk.Text("CALC LOTS");
   calcLotRisk.Font("Georgia");
   calcLotRisk.ColorBackground(clrWhiteSmoke);
   calcLotRisk.Color(clrBlack);

   calcLotRisk.ColorBorder(clrDarkGray);
   Interface.Add(calcLotRisk);


   calcTpatr.Create(0,"calcTpatr",0,203, 93, 278,109);
   calcTpatr.FontSize(8);
   calcTpatr.Text(" TP SL ATR");
   calcTpatr.Font("Georgia");
   calcTpatr.ColorBackground(clrWhiteSmoke);
   calcTpatr.Color(clrBlack);
   calcTpatr.ColorBorder(clrDarkGray);
   Interface.Add(calcTpatr);

//------------order info menu-------------------------------------
   OrderTotalMenu.Create(0,"orderTotalMenu",0,0,0,50,27);
   OrderTotalMenu.Shift(25,2);
   OrderTotalMenu.FontSize(8);
   OrderTotalMenu.Text("Total Open Orders");
   OrderTotalMenu.Color(clrBlack);
   WndClient2.Add(OrderTotalMenu);

   OrderTotalLotsMenu.Create(0,"orderTotalLotsMenu",0,0,0,50,27);
   OrderTotalLotsMenu.Shift(155,2);
   OrderTotalLotsMenu.FontSize(8);
   OrderTotalLotsMenu.Text("Total Open Lots");
   OrderTotalLotsMenu.Color(clrBlack);
   WndClient2.Add(OrderTotalLotsMenu);

   OrderTotalProfitMenu.Create(0,"ordersTotalProfitMenu",0,0,0,50,27);
   OrderTotalProfitMenu.Shift(300,2);
   OrderTotalProfitMenu.FontSize(8);
   OrderTotalProfitMenu.Text("Total Profit");
   OrderTotalProfitMenu.Color(clrBlack);
   WndClient2.Add(OrderTotalProfitMenu);


//------------order info-------------------------------------
   OrderTotal.Create(0,"orderTotal",0,0,0,50,10);
   OrderTotal.Shift(66,17);
   OrderTotal.Text("0");
   OrderTotal.FontSize(10);
   OrderTotal.Color(clrBlack);
   WndClient2.Add(OrderTotal);

   OrderTotalLots.Create(0,"orderTotalLots",0,0,0,50,10);
   OrderTotalLots.Shift(185,17);
   OrderTotalLots.Text("0");
   OrderTotalLots.FontSize(10);
   OrderTotalLots.Color(clrBlack);
   WndClient2.Add(OrderTotalLots);


   OrderTotalProfit.Create(0,"orderTotalProfit",0,0,0,50,10);
   OrderTotalProfit.Shift(305,17);
   OrderTotalProfit.Text("0 "  + AccountCurrency());
   OrderTotalProfit.FontSize(10);
   OrderTotalProfit.Color(clrBlack);
   WndClient2.Add(OrderTotalProfit);


   AutoLot.Create(0,"AutoLot",0,2,109,76,128);
   AutoLot.Text("auto lot");
   AutoLot.Color(clrBlack);
   Interface.Add(AutoLot);

   AutoTpSl.Create(0,"AutoTpSl",0,201,109,278,128);
   AutoTpSl.Text("auto s/l");
   AutoTpSl.Color(clrBlack);
   Interface.Add(AutoTpSl);

   Interface.Run();


  }

//+------------------------------------------------------------------+
//| Check for button press                                   |
//+------------------------------------------------------------------+
void CheckForButtonPress()
  {

//Btn Grid
   if(BtnGrid.Pressed())
     {
      BtnGrid.Pressed(false);

      if(ChartGetInteger(0,CHART_SHOW_GRID) == 0)
        {
         ChartSetInteger(0,CHART_SHOW_GRID,true);
        }

      else
         ChartSetInteger(0,CHART_SHOW_GRID,false);

      return;

     }
//Btn Candle
   if(BtnCandle.Pressed())
     {
      BtnCandle.Pressed(false);

      if(ChartGetInteger(0,CHART_MODE) == 0)
        {
         ChartSetInteger(0,CHART_MODE,CHART_CANDLES);
        }

      else
         ChartSetInteger(0,CHART_MODE,CHART_BARS);

      return;

     }

//Checkbox high/low-------------------------------------------+
   if(DailyHighLow.Checked())
     {

      double high =  iHigh(_Symbol,PERIOD_D1,1);
      double low  =  iLow(_Symbol,PERIOD_D1,1);

      ObjectCreate("hline",OBJ_TREND,0,iTime(NULL,PERIOD_D1,0),high,iTime(NULL,PERIOD_D1,0)+60*60*24,high);
      ObjectCreate("lline",OBJ_TREND,0,iTime(NULL,PERIOD_D1,0),low,iTime(NULL,PERIOD_D1,0)+60*60*24,low);
      ObjectSetInteger(0,"hline",OBJPROP_STYLE,STYLE_DOT);
      ObjectSetInteger(0,"lline",OBJPROP_STYLE,STYLE_DOT);
      ObjectSet("hline", OBJPROP_RAY,False);
      ObjectSet("lline", OBJPROP_RAY,False);
      ObjectSetInteger(0,"hline",OBJPROP_COLOR,clrLightCyan);
      ObjectSetInteger(0,"lline",OBJPROP_COLOR,clrLightCyan);

      ObjectCreate("labelhigh", OBJ_TEXT, 0,iTime(NULL,PERIOD_D1,0)+60*60*12,high+14*pips);
      ObjectSetText("labelhigh", "DAILY HIGH ", 10, "Georgia", clrWheat);

      ObjectCreate("labellow", OBJ_TEXT, 0, iTime(NULL,PERIOD_D1,0)+60*60*12,low-12*pips);
      ObjectSetText("labellow", "DAILY LOW", 10, "Georgia", clrWheat);

      if(Hour()== 0)
        {

         ObjectDelete("hline");
         ObjectDelete("lline");
         ObjectDelete("labelhigh");
         ObjectDelete("labellow");
        }

      return;
     }
   else
     {
      ObjectDelete("hline");
      ObjectDelete("lline");
      ObjectDelete("labelhigh");
      ObjectDelete("labellow");

     }


//Checkbox pivot-----------------------------------------+
   if(PivotPoints.Checked())
     {
      double high =   iHigh(_Symbol,PERIOD_D1,1);
      double low  =    iLow(_Symbol,PERIOD_D1,1);
      double close  =  iClose(_Symbol,PERIOD_D1,1);
      double Pivot= (high+low+close)/3;
      double Range= high-low;                                // Pivot point
      double Res1 = 2 * Pivot - low;                         // R1
      double Res2 = Pivot + Range;                           // R2
      double Res3 = Res1 + Range;                            // R3
      double Sup1 = 2 * Pivot - high;                        // S1
      double Sup2 = Pivot - Range;                           // S2
      double Sup3 = Sup1 - Range;                            // S3

      //pivot
      ObjectCreate("p_line", OBJ_TREND,0,iTime(NULL,PERIOD_D1,0),Pivot,iTime(NULL,PERIOD_D1,0)+60*60*24,Pivot);
      ObjectSetInteger(0,"p_line",OBJPROP_STYLE,STYLE_DOT);
      ObjectSet("p_line", OBJPROP_RAY,False);
      ObjectSetInteger(0,"p_line",OBJPROP_COLOR,clrYellow);

      ObjectCreate("label_pivot", OBJ_TEXT, 0,iTime(NULL,PERIOD_D1,0)+60*60*12,Pivot+13*pips);
      ObjectSetText("label_pivot", "P", 13, "Georgia", clrWheat);

      //res1
      ObjectCreate("res1", OBJ_TREND,0,iTime(NULL,PERIOD_D1,0),Res1,iTime(NULL,PERIOD_D1,0)+60*60*24,Res1);
      ObjectSetInteger(0,"res1",OBJPROP_STYLE,STYLE_DOT);
      ObjectSet("res1", OBJPROP_RAY,False);
      ObjectSetInteger(0,"res1",OBJPROP_COLOR,clrLimeGreen);

      ObjectCreate("label_res1", OBJ_TEXT, 0,iTime(NULL,PERIOD_D1,0)+60*60*12,Res1+13*pips);
      ObjectSetText("label_res1", "R1", 13, "Georgia", clrWheat);

      //res2
      ObjectCreate("res2", OBJ_TREND,0,iTime(NULL,PERIOD_D1,0),Res2,iTime(NULL,PERIOD_D1,0)+60*60*24,Res2);
      ObjectSetInteger(0,"res2",OBJPROP_STYLE,STYLE_DOT);
      ObjectSet("res2", OBJPROP_RAY,False);
      ObjectSetInteger(0,"res2",OBJPROP_COLOR,clrLimeGreen);

      ObjectCreate("label_res2", OBJ_TEXT, 0,iTime(NULL,PERIOD_D1,0)+60*60*12,Res2+13*pips);
      ObjectSetText("label_res2", "R2", 13, "Georgia", clrWheat);

      //res3
      ObjectCreate("res3", OBJ_TREND,0,iTime(NULL,PERIOD_D1,0),Res3,iTime(NULL,PERIOD_D1,0)+60*60*24,Res3);
      ObjectSetInteger(0,"res3",OBJPROP_STYLE,STYLE_DOT);
      ObjectSet("res3", OBJPROP_RAY,False);
      ObjectSetInteger(0,"res3",OBJPROP_COLOR,clrLimeGreen);

      ObjectCreate("label_res3", OBJ_TEXT, 0,iTime(NULL,PERIOD_D1,0)+60*60*12,Res3+13*pips);
      ObjectSetText("label_res3", "R3", 13, "Georgia", clrWheat);


      //sup1
      ObjectCreate("sup1", OBJ_TREND,0,iTime(NULL,PERIOD_D1,0),Sup1,iTime(NULL,PERIOD_D1,0)+60*60*24,Sup1);
      ObjectSetInteger(0,"sup1",OBJPROP_STYLE,STYLE_DOT);
      ObjectSet("sup1", OBJPROP_RAY,False);
      ObjectSetInteger(0,"sup1",OBJPROP_COLOR,clrRed);

      ObjectCreate("label_sup1", OBJ_TEXT, 0,iTime(NULL,PERIOD_D1,0)+60*60*12,Sup1+13*pips);
      ObjectSetText("label_sup1", "S1", 13, "Georgia", clrWheat);

      //sup2
      ObjectCreate("sup2", OBJ_TREND,0,iTime(NULL,PERIOD_D1,0),Sup2,iTime(NULL,PERIOD_D1,0)+60*60*24,Sup2);
      ObjectSetInteger(0,"sup2",OBJPROP_STYLE,STYLE_DOT);
      ObjectSet("sup2", OBJPROP_RAY,False);
      ObjectSetInteger(0,"sup2",OBJPROP_COLOR,clrRed);

      ObjectCreate("label_sup2", OBJ_TEXT, 0,iTime(NULL,PERIOD_D1,0)+60*60*12,Sup2+13*pips);
      ObjectSetText("label_sup2", "R2", 13, "Georgia", clrWheat);

      //sup3
      ObjectCreate("sup3", OBJ_TREND,0,iTime(NULL,PERIOD_D1,0),Sup3,iTime(NULL,PERIOD_D1,0)+60*60*24,Sup3);
      ObjectSetInteger(0,"sup3",OBJPROP_STYLE,STYLE_DOT);
      ObjectSet("sup3", OBJPROP_RAY,False);
      ObjectSetInteger(0,"sup3",OBJPROP_COLOR,clrRed);

      ObjectCreate("label_sup3", OBJ_TEXT, 0,iTime(NULL,PERIOD_D1,0)+60*60*12,Sup3+13*pips);
      ObjectSetText("label_sup3", "R3", 13, "Georgia", clrWheat);


      if(Hour()== 0)
        {
        
         ObjectDelete("p_line");
         ObjectDelete("label_pivot");

         ObjectDelete("res1");
         ObjectDelete("label_res1");
         ObjectDelete("res2");
         ObjectDelete("label_res2");
         ObjectDelete("res3");
         ObjectDelete("label_res3");

         ObjectDelete("sup1");
         ObjectDelete("label_sup1");
         ObjectDelete("sup2");
         ObjectDelete("label_sup2");
         ObjectDelete("sup3");
         ObjectDelete("label_sup3");

        }


      return;

     }
   else
     {

      ObjectDelete("p_line");
      ObjectDelete("label_pivot");

      ObjectDelete("res1");
      ObjectDelete("label_res1");
      ObjectDelete("res2");
      ObjectDelete("label_res2");
      ObjectDelete("res3");
      ObjectDelete("label_res3");

      ObjectDelete("sup1");
      ObjectDelete("label_sup1");
      ObjectDelete("sup2");
      ObjectDelete("label_sup2");
      ObjectDelete("sup3");
      ObjectDelete("label_sup3");

     }

//fibo check
   if(Fibo.Checked())
     {

      double high =   iHigh(_Symbol,PERIOD_D1,1);
      double low  =    iLow(_Symbol,PERIOD_D1,1);


      ObjectCreate(0,"fibo",OBJ_FIBO,0,Time[0], high, Time[10],Ask);
      ObjectSet("fibo", OBJPROP_RAY,False);
      ObjectSetInteger(0,"fibo",OBJPROP_COLOR,clrBlueViolet);

      ObjectSetInteger(0,"fibo",OBJPROP_STYLE,STYLE_DOT);
      ObjectSet("fibo",OBJPROP_LEVELCOLOR,clrDodgerBlue);
     }
   else
     {

      ObjectDelete("fibo");
     }



  }

//+------------------------------------------------------------------+
//|CHECK FOR THE ORDERS BUTTONS PRESSED                                                                  |
//+------------------------------------------------------------------+
void CheckForOrdersButtons()
  {
   if(AutoLot.Checked())
     {
      CalcLotFromRiskAndSL();
     }

   if(AutoTpSl.Checked())
     {
      CalcTPandSLwithATR();
     }

   if(calcTpatr.Pressed())
     {
      calcTpatr.Pressed(false);
      CalcTPandSLwithATR();
      return;
     }

   if(calcLotRisk.Pressed())
     {
      calcLotRisk.Pressed(false);
      CalcLotFromRiskAndSL();
      return;
     }

//BUTTON BUY---
   if(buy.Pressed())
     {
      buy.Pressed(false);
      if(AutoTwoPositions.Checked())
        {
         PlacingDoubleOrders(OP_BUY);
        }
      else
        {
         PlaceOrder(OP_BUY);
        }
      return;
     }

//BUTTON SELL---
   if(sell.Pressed())
     {
      sell.Pressed(false);
      if(AutoTwoPositions.Checked())
        {
         PlacingDoubleOrders(OP_SELL);
        }
      else
        {
         PlaceOrder(OP_SELL);
        }
      return;
     }


   if(closeall.Pressed())
     {
      closeall.Pressed(false);
      CloseAllOrder();
      return;
     }

   if(closefirst.Pressed())
     {
      closefirst.Pressed(false);
      CloseFirstOrder();
      return;
     }

   if(closelast.Pressed())
     {
      closelast.Pressed(false);
      CloseLastOrder();
      return;
     }

   if(incSL.Pressed())
     {
      incSL.Pressed(false);
      ModifyStopOrder(pipsToBumpWhenMovingSLorTP);
      return;
     }

   if(decSL.Pressed())
     {
      decSL.Pressed(false);
      ModifyStopOrder(-pipsToBumpWhenMovingSLorTP);
      return;
     }

   if(incTP.Pressed())
     {
      incTP.Pressed(false);
      ModifyTargetOrder(pipsToBumpWhenMovingSLorTP);
      return;
     }

   if(decTP.Pressed())
     {
      decTP.Pressed(false);
      ModifyTargetOrder(-pipsToBumpWhenMovingSLorTP);
      return;
     }

   if(plus.Pressed())
     {
      plus.Pressed(false);
      ModifyPending(pipsToBumpWhenMovingSLorTP);
      return;
     }

   if(minus.Pressed())
     {
      minus.Pressed(false);
      ModifyPending(-pipsToBumpWhenMovingSLorTP);
      return;
     }

   if(buystop.Pressed())
     {
      buystop.Pressed(false);
      PlaceOrder(OP_BUYSTOP);
      return;
     }

   if(buylimit.Pressed())
     {
      buylimit.Pressed(false);
      PlaceOrder(OP_BUYLIMIT);
      return;
     }

   if(selllimit.Pressed())
     {
      selllimit.Pressed(false);
      PlaceOrder(OP_SELLLIMIT);
      return;
     }

   if(sellstop.Pressed())
     {
      sellstop.Pressed(false);
      PlaceOrder(OP_SELLSTOP);
      return;
     }

   if(breakeven.Pressed())
     {
      breakeven.Pressed(false);
      BreakEven();
      return;
     }


  }
//+------------------------------------------------------------------+
//|PLACING THE DOUBLE ORDERS                                                                  |
//+------------------------------------------------------------------+
void PlacingDoubleOrders(int orderType)
  {
 

      int ticket = -1;
      int ticket2 = -1;

      double lotselllocal=0;
      double lotbuylocal=0;



      if(orderType == OP_BUY)
        {
         if(double(lotbuy.Text()) == 0.01)
            lotbuylocal = 0.01;
         else
            lotbuylocal = double(lotbuy.Text()) / 2;
        }


      if(orderType == OP_SELL)
        {
         if(double(lotsell.Text()) == 0.01)
            lotselllocal = 0.01;
         else
            lotselllocal = double(lotsell.Text()) / 2 ;

        }



      if(orderType == OP_BUY && OrdersTotal() == 0)
        {
         ticket = OrderSend(_Symbol, orderType, lotbuylocal, Ask, 3, Ask - (double(slsize.Text())) * pips, (double(tpsize.Text())) * pips,NULL,0,0,clrNONE);
         ticket2 = OrderSend(_Symbol, orderType, lotbuylocal, Ask, 3, Ask - (double(slsize.Text())) * pips, 0,NULL,0,0,clrNONE);

        }


      if(orderType == OP_SELL && OrdersTotal() == 0)
        {
         ticket = OrderSend(_Symbol, orderType, lotselllocal, Bid, 3, Bid + (double(tpsize.Text()))  * pips, Bid - (double(tpsize.Text()))  * pips,NULL,0,0,clrNONE);
         ticket2 = OrderSend(_Symbol, orderType, lotselllocal, Bid, 3, Bid + (double(slsize.Text()))  * pips,0,NULL,0,0,clrNONE);

        }

  
  }
//+------------------------------------------------------------------+
//|PLACING THE ORDERS                                  |
//+------------------------------------------------------------------+
void PlaceOrder(int orderType)
  {
   int ticket = -1;



      if(orderType == OP_BUY)
        {
         ticket = OrderSend(_Symbol, orderType, double(lotbuy.Text()), Ask, 5, Ask - (double(slsize.Text())) * pips, Ask + (double(tpsize.Text())) * pips,NULL,0,0,clrNONE);
        }
      if(orderType == OP_SELL)
        {
         ticket = OrderSend(_Symbol, orderType, double(lotsell.Text()), Bid, 5, Bid + (double(slsize.Text())) * pips, Bid - (double(tpsize.Text()))  * pips,NULL,0,0,clrNONE);
        }

      if(orderType == OP_BUYLIMIT)
        {
         double openingPrice = Ask - pendingOrdersDistance * pips;
         ticket = OrderSend(_Symbol, orderType, double(lotbuy.Text()), openingPrice, 5, openingPrice - (double(slsize.Text())) * pips, openingPrice + (double(tpsize.Text()))  * pips,NULL,0,0,clrNONE);
        }
      if(orderType == OP_BUYSTOP)
        {
         double openingPrice = Ask + pendingOrdersDistance * pips;
         ticket = OrderSend(_Symbol, orderType, double(lotbuy.Text()), openingPrice, 5, openingPrice - (double(slsize.Text())) * pips, openingPrice + (double(tpsize.Text()))  * pips,NULL,0,0,clrNONE);
        }

      if(orderType == OP_SELLLIMIT)
        {
         double openingPrice = Bid + pendingOrdersDistance * pips;
         ticket = OrderSend(_Symbol, orderType, double(lotsell.Text()), openingPrice, 5, openingPrice + (double(slsize.Text())) * pips, openingPrice - (double(tpsize.Text()))  * pips,NULL,0,0,clrNONE);
        }
      if(orderType == OP_SELLSTOP)
        {
         double openingPrice = Bid - pendingOrdersDistance * pips;
         ticket = OrderSend(_Symbol, orderType, double(lotsell.Text()), openingPrice, 5, openingPrice + (double(slsize.Text())) * pips, openingPrice - (double(tpsize.Text()))  * pips,NULL,0,0,clrNONE);
        }

     

  }
//+------------------------------------------------------------------+
//|COLSE FIRST OREDER                                  |
//+------------------------------------------------------------------+
void CloseFirstOrder()
  {
   if(!OrderSelect(0,SELECT_BY_POS))
      return;
   int Ordertype = OrderType();

   double closeprice = 0;
   if(Ordertype == OP_BUY)
      closeprice = Bid;
   else
      if(Ordertype == OP_SELL)
         closeprice = Ask;
      else
         if(Ordertype > 1)
           {
            if(!OrderDelete(OrderTicket(),clrNONE))
              {
               Print("Unable to delete panding order");
              }

           }

   if(!OrderClose(OrderTicket(),OrderLots(),closeprice,30))
     {
      Print("Unable to close the order");

     }

  }
//+------------------------------------------------------------------+
//|CLOSE LAST ORDER                                |
//+------------------------------------------------------------------+
void CloseLastOrder()
  {
   if(!OrderSelect(OrdersTotal()-1,SELECT_BY_POS))
      return;
   int Ordertype = OrderType();

   double closeprice = 0;
   if(Ordertype == OP_BUY)
      closeprice = Bid;
   else
      if(Ordertype == OP_SELL)
         closeprice = Ask;
      else
         if(Ordertype > 1)
           {
            if(!OrderDelete(OrderTicket(),clrNONE))
              {
               Print("Unable to delete panding order");
              }

           }

   if(!OrderClose(OrderTicket(),OrderLots(),closeprice,30))
     {
      Print("Unable to close the order");

     }

  }
//+------------------------------------------------------------------+
//|CLOSE ALL ORDERS                                 |
//+------------------------------------------------------------------+
void CloseAllOrder()
  {
   int numOfOrders = OrdersTotal();
   int FirstOrderType = 0;

   for(int index = 0; index < OrdersTotal(); index++)
     {
      if(!OrderSelect(index, SELECT_BY_POS, MODE_TRADES))
         continue;
      if(OrderSymbol() == Symbol())
        {
         FirstOrderType = OrderType();
         break;
        }
     }

   for(int index = numOfOrders - 1; index >= 0; index--)
     {
      if(!OrderSelect(index, SELECT_BY_POS, MODE_TRADES))
         continue;

      if(OrderSymbol() == Symbol())
         switch(OrderType())
           {
            case OP_BUY:
               if(!OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 3, Red))
                  Print("Unable to close buy the order");
               break;

            case OP_SELL:
               if(!OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 3, Red))
                  Print("Unable to close sell the order");
               break;

            case OP_BUYLIMIT:
            case OP_SELLLIMIT:
            case OP_BUYSTOP:
            case OP_SELLSTOP:
               if(!OrderDelete(OrderTicket()))
                  Print("Unable to delete the order");
               break;
           }
     }
  }
//+------------------------------------------------------------------+
//|MODIFY STOP ORDER                               |
//+------------------------------------------------------------------+
void ModifyStopOrder(int pipsToBump)
  {
   if(!OrderSelect(OrdersTotal()-1,SELECT_BY_POS))
      return;

   if(!OrderModify(OrderTicket(), OrderOpenPrice(),OrderStopLoss() + pipsToBump * pips, OrderTakeProfit(),0))
     {
      Print("Unable to increase the stop");
     }
  }
//+------------------------------------------------------------------+
//|MODIFY TARGET ORDER                               |
//+------------------------------------------------------------------+
void ModifyTargetOrder(int pipsToBump)
  {
   if(!OrderSelect(OrdersTotal()-1,SELECT_BY_POS))
      return;

   if(!OrderModify(OrderTicket(), OrderOpenPrice(),OrderStopLoss(), OrderTakeProfit()+ pipsToBump * pips,0))
     {
      Print("Unable to increase the stop");
     }
  }

//+------------------------------------------------------------------+
//|MODIFY PENDING ORDERS                                 |
//+------------------------------------------------------------------+
void ModifyPending(int pipsToBump)
  {
   if(!OrderSelect(OrdersTotal()-1,SELECT_BY_POS))
      return;

   if(!OrderModify(OrderTicket(), OrderOpenPrice() + pipsToBump * pips, OrderStopLoss() + pipsToBump * pips, OrderTakeProfit() + pipsToBump * pips,0))
     {
      Print("Unable to modify panding order");
     }
  }
//+------------------------------------------------------------------+
//| BREAKEVEN                               |
//+------------------------------------------------------------------+
void BreakEven()
  {
   for(int i = OrdersTotal()-1; i >= 0; i--)
     {
      if(!OrderSelect(i, SELECT_BY_POS,MODE_TRADES))
         continue;

      if(OrderType() == OP_BUY)
         if(OrderStopLoss()< OrderOpenPrice())
            if(Ask > OrderOpenPrice() + 2 * pips)
              {
               if(!OrderModify(OrderTicket(),OrderOpenPrice(),(OrderOpenPrice()) + breakevenPipsSize * pips, OrderTakeProfit(),0,clrNONE))
                  Print("Unable to modify to breakeven buy");

              }
      if(OrderType() == OP_SELL)
         if(OrderStopLoss()> OrderOpenPrice())
            if(Bid < OrderOpenPrice() - 2 * pips)
              {
               if(!OrderModify(OrderTicket(),OrderOpenPrice(),(OrderOpenPrice()) - breakevenPipsSize * pips, OrderTakeProfit(),0,clrNONE))
                  Print("Unable to modify to breakeven sell");
              }
     }
  }
//+------------------------------------------------------------------+
//| AUTO BREAKEVEN                               
//+------------------------------------------------------------------+
void AutoBreakEven()
  {
   for(int i = OrdersTotal()-1; i >= 0; i--)
     {
      if(!OrderSelect(i,SELECT_BY_POS))
        {
         Print("Unable select order by position.");
         break;
        }
      if(OrderType() == OP_BUY)
        {

         if(Ask > OrderOpenPrice() + (StringToInteger(AutoBEVEdit.Text())* pips))
            if(!OrderModify(OrderTicket(),OrderOpenPrice(),(OrderOpenPrice()) + breakevenPipsSize * pips, OrderTakeProfit(),0,clrNONE))
               Print("Unable to modify to auto breakeven buy");

        }
      else
         if(OrderType() == OP_SELL)
           {

            if(Bid < OrderOpenPrice() - (StringToInteger(AutoBEVEdit.Text())*pips))
               if(!OrderModify(OrderTicket(),OrderOpenPrice(),(OrderOpenPrice()) - breakevenPipsSize * pips, OrderTakeProfit(),0,clrNONE))
                  Print("Unable to modify to auto breakeven sell");
           }
     }
  }
//+------------------------------------------------------------------+
//|CALCUL SL AND TP WITH ATR                                                                 |
//+------------------------------------------------------------------+
int CalcTPandSLwithATR()
  {
   double ATR = iATR(_Symbol, _Period, 14, 0);
   int atrWithProcentage = (int)((NormalizeDouble(ATR, 4) * 10000) * StrToDouble(atredit.Text()));
   tpsize.Text(IntegerToString(atrWithProcentage));
   slsize.Text(IntegerToString(atrWithProcentage));

   return atrWithProcentage;

  }

//+------------------------------------------------------------------+
//|CALCUL LOT SIZE WITH WITH RISK AND SL                                                                  |
//+------------------------------------------------------------------+
void CalcLotFromRiskAndSL()
  {
   double ATR = iATR(_Symbol, _Period, 14, 0);

   int atrWithProcentage = (int)((NormalizeDouble(ATR, 4) * 10000) * StrToDouble(atredit.Text()));



   double lotValueUpdated = (((AccountBalance() * (NormalizeDouble(StrToDouble(riskedit.Text())/100,3))) / atrWithProcentage));

   Print("lotValueUpdated: " + DoubleToString(NormalizeDouble(lotValueUpdated,2),2));

   lotbuy.Text(DoubleToString(NormalizeDouble(lotValueUpdated,2)/10,2));
   lotsell.Text(DoubleToString(NormalizeDouble(lotValueUpdated,2)/10,2));
  }
//+------------------------------------------------------------------+
//|AUTOTRAILING STOP                                                                 |
//+------------------------------------------------------------------+
void AutoTrailingStop()
  {

   for(int i = OrdersTotal()-1; i >= 0; i--)
     {
      if(!OrderSelect(i,SELECT_BY_POS))
        {
         Print("Unable select order by position.");
         break;
        }
      if(OrderType() == OP_BUY)
        {

         if(Ask > OrderOpenPrice() + (StringToInteger(AutoTrailingStopEdit.Text())*2* pips))
            if(Ask > OrderStopLoss()  + (StringToInteger(AutoTrailingStopEdit.Text())*2* pips))
               if(!OrderModify(OrderTicket(),OrderOpenPrice(),Ask - (StringToInteger(AutoTrailingStopEdit.Text())* pips), OrderTakeProfit(),0,clrNONE))
                  Print("Unable to modify to trailing stop buy");

        }
      else
         if(OrderType() == OP_SELL)
           {

            if(Bid < OrderOpenPrice() - (StringToInteger(AutoTrailingStopEdit.Text())*2*pips))
               if(Bid < OrderStopLoss() - (StringToInteger(AutoTrailingStopEdit.Text())*2* pips))
                  if(!OrderModify(OrderTicket(),OrderOpenPrice(),Bid + (StringToInteger(AutoTrailingStopEdit.Text())* pips), OrderTakeProfit(),0,clrNONE))
                     Print("Unable to modify to trailing stop sell");
           }
     }
  }








//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

   ENUM_LICENSE_TYPE licenseType = (ENUM_LICENSE_TYPE)MQLInfoInteger(MQL_LICENSE_TYPE);


   if(Digits == 5 || Digits == 3)
      pips*=10;

   ChartSetInteger(0,CHART_SHOW_GRID,false);
   ChartSetInteger(0,CHART_MODE,CHART_CANDLES);


//   if(licenseType == 1)
//     {
//
//      MsgDemo.Create(0,"Dialog",0,10,30,585,100);
//      MsgDemo.Font("Georgia");
//      MsgDemo.FontSize(30);
//      MsgDemo.Text("Version DEMO only EUR/CHF");
//      MsgDemo.ColorBackground(clrFireBrick);
//
//   
//     }



   PanelCreate();

//---

   Comment(Symbol());


//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   Interface.Destroy(reason);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---

   if(!IsTesting())
      return;








   Currency.Text(_Symbol + ", M" +IntegerToString(_Period) + ", Spread: " +DoubleToStr(MarketInfo(Symbol(), MODE_SPREAD),1) + ", " + TimeToStr(TimeCurrent(),TIME_SECONDS));

   double atr = iATR(_Symbol,_Period,14,0);
   atr = (int)(NormalizeDouble(atr, 4) * 10000);
   AtrLabel.Text("ATR: " + DoubleToStr(atr,0));


   CheckForOrdersButtons();



   if(AutoBEV.Checked())
     {

      AutoBreakEven();
     }
   if(AutoTrailingStop.Checked())
     {

      AutoTrailingStop();
      Print("   AutoTrailingStop();-------------");
     }





//Account balance info update when trade is open
   string b = DoubleToStr(AccountBalance(), 2);
   string e = DoubleToStr(AccountEquity(), 2);
   string f = DoubleToStr(AccountFreeMargin(), 2);


   BalanceNb.Text(b + " " + AccountCurrency());
   EquityNb.Text(e + " " + AccountCurrency());
   FreeMarginNb.Text(f + " " + AccountCurrency());

   CheckForButtonPress();




   double profitTotal=0;
   double totalLots=0;




   if(OrdersTotal()>0)
     {
      for(int i=0; i<OrdersTotal(); i++)
        {
         if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
            continue;


         if(OrderType()==OP_BUY)
           {
            profitTotal+=OrderProfit()+OrderSwap();
            totalLots+= OrderLots();
           }
         if(OrderType()==OP_SELL)
           {
            profitTotal+=OrderProfit()+OrderSwap();
            totalLots+= OrderLots();
           }


        }


      OrderTotal.Text(IntegerToString(OrdersTotal()));
      OrderTotalLots.Text(DoubleToString(totalLots,2));
      if(OrdersTotal() == 0)
         profitTotal = 0;
      if(profitTotal < 0)
         OrderTotalProfit.Color(clrRed);
      else
         OrderTotalProfit.Color(clrBlack);
      OrderTotalProfit.Text(DoubleToString(profitTotal,2) + " " + AccountCurrency());


     }

   if(OrdersTotal() == 0)
     {
      totalLots = 0;
      profitTotal = 0;
      OrderTotalProfit.Color(clrBlack);
      OrderTotal.Text("0");
      OrderTotalLots.Text(DoubleToString(totalLots,2));
      OrderTotalProfit.Text(DoubleToString(profitTotal,2) + " " + AccountCurrency());
     }









  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---

  }
//+------------------------------------------------------------------+
