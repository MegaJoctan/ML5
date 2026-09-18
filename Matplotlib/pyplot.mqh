//+------------------------------------------------------------------+
//|                                                       pyplot.mqh |
//|                                     Copyright 2026, Omega Joctan |
//|                 https://www.mql5.com/en/users/omegajoctan/seller |
//+------------------------------------------------------------------+
#property copyright "Copyright 2026, Omega Joctan"
#property link      "https://www.mql5.com/en/users/omegajoctan/seller"
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
#include "figure.mqh"
#include "axes.mqh"
#include "style.mqh"
#include "requests.mqh"
#include "JSON.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#ifndef del_valid_ptr
#define del_valid_ptr(ptr) if (CheckPointer(ptr)!=POINTER_INVALID) delete (ptr);
#endif
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CPyplot
  {
protected:

   CFigure           m_figure;
   CSession          *m_session;

   string            m_url;
   string            m_url_suffix;

   string            vector2StringArray(const vector &v)
     {
      string val = "[";

      ulong s = v.Size();
      for(ulong i = 0; i < s; i++)
         val += ((string)v[i] + (i == s - 1 ? "]" : ","));

      return val;
     }

   static bool       display_image(const string name, const string file_name);

public:
                     CPyplot(const string server = "http://127.0.0.1", const uint port = 5000, uint server_timeout=1000);
                    ~CPyplot(void);

   //--- style
   CStyle            *style;

   //--- Figure
   void              figure(const double width = 6.4, const double height = 4.8);

   //--- Axes

   void              plot(const vector &x, const vector &y);
   void              scatter(const vector &x, const vector &y);
   void              title(const string title);

   void              xlabel(const string label = "x");
   void              ylabel(const string label = "y");
   void              grid(const bool enable = true);

   void              xlim(const double xmin, const double xmax);
   void              ylim(const double ymin, const double ymax);
   void              legend(const bool enable = true);

   //--- Figure
   void              suptitle(const string title);
   void              tight_layout(const bool enable = true);

   //--- subplots

   CFigure           subplots(uint nrows = 1,
                              uint ncols = 1,
                              const double width = 6.4,
                              const double height = 4.8,
                              const bool sharex = false,
                              const bool sharey = false);

   //--- Send to Python
   bool              show(void);
   bool              show(CFigure &fig);
   static bool       save_fig(uchar &fig[], string filename);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CPyplot::CPyplot(const string server = "http://127.0.0.1", const uint port = 5000, uint server_timeout=1000)
  {
//---

   m_session = new CSession("Content-Type: application/json\r\n",NULL, server_timeout);
   m_url = server + ":" + string(port);

//---

   style = new CStyle(m_session, server, port);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CPyplot::~CPyplot(void)
  {
   del_valid_ptr(m_session)
   del_valid_ptr(style)
  }
//+------------------------------------------------------------------+
//| Set figure size                                                  |
//+------------------------------------------------------------------+
void CPyplot::figure(const double width = 6.4, const double height = 4.8)
  {
   m_figure.set_size(width, height);
  }
//+------------------------------------------------------------------+
//| Obtains X and Y values for drawing a line plot.                  |
//|                                                                  |
//| Parameters:                                                      |
//|     x - a vector of values to plot on the x axis.                |
//|     u - a vector of values to plot on the y axis.                |
//|                                                                  |
//| Notes:                                                           |
//|      It creates a url suffix according to the plot type          |
//|                                                                  |
//+------------------------------------------------------------------+
void CPyplot::plot(const vector &x, const vector &y)
  {
   this.m_figure.m_axes[m_figure.total_axes() - 1].plot(x, y);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CPyplot::scatter(const vector &x, const vector &y)
  {
   this.m_figure.m_axes[m_figure.total_axes() - 1].scatter(x, y);

//m_url_suffix = "/" + this.m_figure.m_axes[m_figure.total_axes()-1].plot_type();
  }
//+------------------------------------------------------------------+
//| Set plot title                                                   |
//+------------------------------------------------------------------+
void CPyplot::title(const string title = NULL)
  {
   m_figure.suptitle(title);
  }
//+------------------------------------------------------------------+
//| Set X axis label                                                 |
//+------------------------------------------------------------------+
void CPyplot::xlabel(const string label = "x")
  {
   m_figure.m_axes[m_figure.total_axes() - 1].set_xlabel(label);
  }
//+------------------------------------------------------------------+
//| Set Y axis label                                                 |
//+------------------------------------------------------------------+
void CPyplot::ylabel(const string label = "y")
  {
   m_figure.m_axes[m_figure.total_axes() - 1].set_ylabel(label);
  }
//+------------------------------------------------------------------+
//| Enable/disable grid                                              |
//+------------------------------------------------------------------+
void CPyplot::grid(const bool grid_ = true)
  {
   m_figure.m_axes[m_figure.total_axes() - 1].grid(grid_);
  }
//+------------------------------------------------------------------+
//| Creates a figure containing multiple Axes objects arranged in a  |
//| grid of rows and columns.                                        |
//|                                                                  |
//| Parameters:                                                      |
//|    nrows  - Number of rows in the subplot grid.                  |
//|    ncols  - Number of columns in the subplot grid.               |
//|    width  - Width of the resulting figure.                       |
//|    height - Height of the resulting figure.                      |
//|    sharex - Whether the subplots should share the X-axis.        |
//|    sharey - Whether the subplots should share the Y-axis.        |
//|                                                                  |
//| Returns:                                                         |
//|    A CFigure object configured with the requested subplot layout.|
//+------------------------------------------------------------------+
CFigure CPyplot::subplots(uint nrows = 1,
                          uint ncols = 1,
                          const double width = 6.4,
                          const double height = 4.8,
                          const bool sharex = false,
                          const bool sharey = false
                         )
  {
   CFigure fig;
   ArrayResize(m_figure.m_axes, nrows * ncols);

   fig.set_size(width, height);
   fig.rows(nrows);
   fig.cols(ncols);
   fig.sharex(sharex);
   fig.sharey(sharey);

   return fig;
  }
//+------------------------------------------------------------------+
//| Sends plot information to Python                                 |
//+------------------------------------------------------------------+
bool CPyplot::show(void)
  {
   return this.show(m_figure);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CPyplot::show(CFigure &fig)
  {
//--- Figure object
   JSON::Object *figure = new JSON::Object();

   figure
   .setProperty("width",        fig.width())
   .setProperty("height",       fig.height())
   .setProperty("rows", (int)fig.rows())
   .setProperty("cols", (int)fig.cols())
   .setProperty("sharex",       fig.sharex())
   .setProperty("sharey",       fig.sharey())
   .setProperty("color",        fig.facecolor())
   .setProperty("tight_layout", fig.tight_layout())
   .setProperty("visible",      fig.visible())
   .setProperty("suptitle",     fig.suptitle());

//--- Axes array
   JSON::Array *axes_array = new JSON::Array();

   for(int i = 0; i < ArraySize(fig.m_axes); i++)
     {
      JSON::Object *axes = CFigure::axestoJSON(fig.m_axes[i]);

      axes_array.add(axes);
     }

//--- Root object
   JSON::Object *json = new JSON::Object();

   json
   .setProperty("figure", figure)
   .setProperty("axes",   axes_array);

//--- Convert to JSON
   string data = json.toString();

   if(MQLInfoInteger(MQL_DEBUG))
      Print("Plot JSON:\n", data);

//--- Delete dynamic pointers

   del_valid_ptr(figure)
   del_valid_ptr(axes_array)
   del_valid_ptr(json)

//--- Send to Python

   CResponse response = m_session.post(m_url + "/mpl", data);

//--- Save returned figure
   
   uint tc = GetTickCount();
   string file_name = StringFormat("Matplotlib\\%d.bmp", tc);

   save_fig(response.content, file_name);

//--- Display image
   string rel_file_name = "\\Files\\" + file_name;

   display_image(string(tc), rel_file_name);

   return response.ok;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CPyplot::xlim(const double xmin, const double xmax)
  {
   this.m_figure.m_axes[m_figure.total_axes() - 1].set_xlim(xmin, xmax);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CPyplot::ylim(const double ymin, const double ymax)
  {
   this.m_figure.m_axes[m_figure.total_axes() - 1].set_ylim(ymin, ymax);
  }
//+------------------------------------------------------------------+
//| Saves image data from a character array to a file.               |
//|                                                                  |
//| Parameters:                                                      |
//|   fig      - Array containing the raw binary image data.         |
//|   filename - Destination filename, relative to the MQL5          |
//|              file sandbox.                                       |
//|                                                                  |
//| Returns:                                                         |
//|   true  - If the file was successfully created and written.      |
//|   false - If the file could not be opened for writing.           |
//+------------------------------------------------------------------+
bool CPyplot::save_fig(uchar &fig[], string filename)
  {
   int handle = FileOpen(filename, FILE_WRITE | FILE_BIN);
   if(handle == INVALID_HANDLE)
     {
      printf("Failed to create %s", filename);
      return false;
     }

   FileWriteArray(handle, fig, 0, ArraySize(fig));
   FileClose(handle);
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//| The function creates an OBJ_BITMAP_LABEL graphical object and    |
//| assigns the specified image file to both its ON and OFF states.  |
//| If an object with the same name already exists, it is removed    |
//| before the new bitmap object is created.                         |
//|                                                                  |
//| Parameters:                                                      |
//|   name      - Name of the bitmap object on the chart.            |
//|   file_name - Path to the bitmap image file relative to the      |
//|               MQL5 file sandbox.                                 |
//|                                                                  |
//| Returns:                                                         |
//|   true  - If the bitmap object was successfully created and the  |
//|           image was loaded.                                      |
//|   false - If the object could not be created or the image could  |
//|           not be loaded.                                         |
//|                                                                  |
//| Notes:                                                           |
//|   The bitmap is positioned 30 pixels from the upper-left corner  |
//|   of the chart and displayed in the foreground. The object is    |
//|   selectable but hidden from the chart's object list.            |
//+------------------------------------------------------------------+
bool CPyplot::display_image(const string name, const string file_name)
  {
//--- Remove existing object if it exists
   if(ObjectFind(0, name) >= 0)
      ObjectDelete(0, name);

//--- Create bitmap label
   ResetLastError();

   if(!ObjectCreate(0, name, OBJ_BITMAP_LABEL, 0, 0, 0))
     {
      Print(__FUNCTION__, ": failed to create Bitmap Label! Error = ", GetLastError());
      return false;
     }

//--- Set image for ON state
   ResetLastError();

   if(!ObjectSetString(0, name, OBJPROP_BMPFILE, 0, file_name))
     {
      Print(__FUNCTION__, ": failed to load image! File = ", file_name, " Error = ", GetLastError());
      ObjectDelete(0, name);

      return false;
     }

//--- Image for OFF state
   ResetLastError();

   if(!ObjectSetString(0, name, OBJPROP_BMPFILE, 1, file_name))
     {
      Print(__FUNCTION__, ": failed to load OFF image! ", file_name, " Error = ", GetLastError());
      ObjectDelete(0, name);
      return false;
     }

//--- Position
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, 30);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, 30);

//--- Anchor to upper-left corner
   ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);

//--- Display in foreground
   ObjectSetInteger(0, name, OBJPROP_BACK, false);

//--- allow user to move it
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, true);
   ObjectSetInteger(0, name, OBJPROP_SELECTED, true);

//--- Hide from object list
   ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
   ChartRedraw();

   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
