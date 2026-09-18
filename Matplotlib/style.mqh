//+------------------------------------------------------------------+
//|                                                        style.mqh |
//|                                     Copyright 2026, Omega Joctan |
//|                 https://www.mql5.com/en/users/omegajoctan/seller |
//+------------------------------------------------------------------+
#property copyright "Copyright 2026, Omega Joctan"
#property link      "https://www.mql5.com/en/users/omegajoctan/seller"
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
#include "requests.mqh"
#include "JSON.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#ifndef MATPLOTLIB_STYLE_CLASS

string DEFAULT_STYLES[] =
     {
      "Solarize_Light2",
      "bmh",
      "classic",
      "dark_background",
      "fast",
      "fivethirtyeight",
      "ggplot",
      "grayscale",
      "petroff10",
      "petroff6",
      "petroff8",
      "seaborn-v0_8",
      "seaborn-v0_8-bright",
      "seaborn-v0_8-colorblind",
      "seaborn-v0_8-dark",
      "seaborn-v0_8-dark-palette",
      "seaborn-v0_8-darkgrid",
      "seaborn-v0_8-deep",
      "seaborn-v0_8-muted",
      "seaborn-v0_8-notebook",
      "seaborn-v0_8-paper",
      "seaborn-v0_8-pastel",
      "seaborn-v0_8-poster",
      "seaborn-v0_8-talk",
      "seaborn-v0_8-ticks",
      "seaborn-v0_8-white",
      "seaborn-v0_8-whitegrid",
      "tableau-colorblind10"
     };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CStyle
  {
private:
   CSession          m_session;
   string            m_server;
   uint              m_port;
   string            m_name;

public:

   string            available[]; //styles available

                     CStyle(CSession *session, const string server, const uint port);
                    ~CStyle(void) {}

   bool              use(const string name);
   string            name(void) const { return m_name; }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStyle::CStyle(CSession *session, const string server, const uint port):
   m_session(session),
   m_server(server),
   m_port(port)
  {
//---
   ArrayCopy(available, DEFAULT_STYLES);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStyle::use(const string name)
  {
   m_name = name;
//---
   JSON::Object *json = new JSON::Object();

   json
   .setProperty("style", name);
   
   string json_str = json.toString();
   
   del_valid_ptr(json);
   
   string url = m_server+":"+string(m_port);
   CResponse response = m_session.post(url + "/set-style", json_str);

//---
   
   if (MQLInfoInteger(MQL_DEBUG))
      Print(CharArrayToString(response.content));

//---
   return response.ok;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#endif 