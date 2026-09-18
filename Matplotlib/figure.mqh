//+------------------------------------------------------------------+
//|                                                       figure.mqh |
//|                                     Copyright 2026, Omega Joctan |
//|                 https://www.mql5.com/en/users/omegajoctan/seller |
//+------------------------------------------------------------------+
#property copyright "Copyright 2026, Omega Joctan"
#property link      "https://www.mql5.com/en/users/omegajoctan/seller"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include "axes.mqh"
//+------------------------------------------------------------------+
//| Figure                                                           |
//+------------------------------------------------------------------+
#ifndef MATPLOTLIB_FIGURE_CLASS
class CFigure
  {
protected:
   double            m_width;
   double            m_height;

   uint              m_rows;
   uint              m_cols;

   string            m_title;
   string            m_background;
   bool              m_tight_layout;
   bool              m_visible;

   bool              m_sharex, m_sharey;

public:

   CAxes             m_axes[];

                     CFigure(void);
                    ~CFigure(void);

   bool              sharex() const { return m_sharex; }
   bool              sharey() const { return m_sharey; }

   void              sharex(bool var) { m_sharex = var; }
   void              sharey(bool var) { m_sharey = var; }

   //--- For adding axes to a figure object

   void              add_axes(CAxes &ax);
   uint              total_axes() { return m_axes.Size(); }
   static JSON::Object*     axestoJSON(CAxes &ax);

   //--- Figure properties
   void              set_size(const double width, const double height);

   uint              rows() const { return m_rows; }
   uint              cols() const { return m_cols; }

   void              rows(uint r) { m_rows = r; }
   void              cols(uint c) { m_cols = c; }

   double            width(void) const;
   double            height(void) const;

   void              suptitle(const string title);
   string            suptitle(void) const;

   void              facecolor(const string clr);
   string            facecolor(void) const;

   //--- Layout
   void              tight_layout(const bool enable);
   bool              tight_layout(void) const;

   //--- Visibility
   void              show(void);
   void              hide(void);
   bool              visible(void) const;

   //--- Figure operations
   void              clear(void);
   void              close(void);

   //--- color bar
   void              colorbar(CAxes &ax, string label = NULL,
                              string location = NULL,
                              string orientation = NULL,
                              double fraction = 0.15,
                              double pad = 0.05,
                              double shrink = 1.0,
                              double aspect = 20);

  };

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CFigure::CFigure(void)
  {
   m_width        = 6.4;
   m_height       = 4.8;
   m_title        = "";
   m_background   = "white";
   m_tight_layout = false;
   m_visible      = true;
   m_rows         = 1;
   m_cols         = 1;
   m_sharex       = false;
   m_sharey       = false;
  }

//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CFigure::~CFigure(void)
  {
  }

//+------------------------------------------------------------------+
//| Set figure size                                                  |
//+------------------------------------------------------------------+
void CFigure::set_size(const double width, const double height)
  {
   m_width  = width;
   m_height = height;
  }

//+------------------------------------------------------------------+
//| Get figure width                                                 |
//+------------------------------------------------------------------+
double CFigure::width(void) const
  {
   return m_width;
  }

//+------------------------------------------------------------------+
//| Get figure height                                                |
//+------------------------------------------------------------------+
double CFigure::height(void) const
  {
   return m_height;
  }

//+------------------------------------------------------------------+
//| Set figure-level title                                           |
//+------------------------------------------------------------------+
void CFigure::suptitle(const string title)
  {
   m_title = title;
  }

//+------------------------------------------------------------------+
//| Get figure-level title                                           |
//+------------------------------------------------------------------+
string CFigure::suptitle(void) const
  {
   return m_title;
  }

//+------------------------------------------------------------------+
//| Set figure background color                                      |
//+------------------------------------------------------------------+
void CFigure::facecolor(const string clr)
  {
   m_background = clr;
  }

//+------------------------------------------------------------------+
//| Get figure background color                                      |
//+------------------------------------------------------------------+
string CFigure::facecolor(void) const
  {
   return m_background;
  }

//+------------------------------------------------------------------+
//| Enable/disable tight layout                                      |
//+------------------------------------------------------------------+
void CFigure::tight_layout(const bool enable)
  {
   m_tight_layout = enable;
  }

//+------------------------------------------------------------------+
//| Get tight layout state                                           |
//+------------------------------------------------------------------+
bool CFigure::tight_layout(void) const
  {
   return m_tight_layout;
  }

//+------------------------------------------------------------------+
//| Show figure                                                       |
//+------------------------------------------------------------------+
void CFigure::show(void)
  {
   m_visible = true;
  }

//+------------------------------------------------------------------+
//| Hide figure                                                       |
//+------------------------------------------------------------------+
void CFigure::hide(void)
  {
   m_visible = false;
  }

//+------------------------------------------------------------------+
//| Get visibility                                                   |
//+------------------------------------------------------------------+
bool CFigure::visible(void) const
  {
   return m_visible;
  }

//+------------------------------------------------------------------+
//| Clear figure                                                     |
//+------------------------------------------------------------------+
void CFigure::clear(void)
  {
   m_title = "";
  }

//+------------------------------------------------------------------+
//| Close figure                                                     |
//+------------------------------------------------------------------+
void CFigure::close(void)
  {
   m_visible = false;
  }
//+------------------------------------------------------------------+
//|  Adds a CAxes object to the m_axes array[].                      |
//|                                                                  |
//|  Parameters:                                                     |
//|       ax -- the CAxes object to append to the m_axes array.      |
//+------------------------------------------------------------------+
void CFigure::add_axes(CAxes &ax)
  {
   uint s = m_axes.Size();
   ArrayResize(m_axes, s + 1);
//---
   m_axes[s] = ax;
  }
//+------------------------------------------------------------------+
//|  Converts a CAxes object into a JSON::Object.                    |
//|                                                                  |
//|  The resulting JSON object contains the axes configuration,      |
//|  including its title, axis labels, grid, legend, axis limits,    |
//|  and all plots associated with the axes.                         |
//|                                                                  |
//|  Parameters:                                                     |
//|       ax -- the CAxes object to convert to JSON.                 |
//|                                                                  |
//|  Returns:                                                        |
//|       A pointer to a JSON::Object containing the serialized      |
//|       CAxes properties and plot data.                            |
//+------------------------------------------------------------------+
JSON::Object* CFigure::axestoJSON(CAxes &ax)
  {
//--- X limits
   JSON::Array *xlim = new JSON::Array();

   xlim
   .add(ax.xmin())
   .add(ax.xmax());

//--- Y limits
   JSON::Array *ylim = new JSON::Array();

   ylim
   .add(ax.ymin())
   .add(ax.ymax());

//--- For every plot in the axis (for multiple plots)
   JSON::Array *plots = new JSON::Array();

   for(uint i = 0; i < ax.m_plots.Size(); i++)
     {
      plots.add(ax.m_plots[i]);
     }

//--- Axes object
   JSON::Object *axes = new JSON::Object();

   JSON::Object *legend = new JSON::Object();

   legend
   .setProperty("enabled", ax.get_legend())
   .setProperty("loc", ax.legend_loc());
   
   axes
   .setProperty("title",  ax.get_title())
   .setProperty("xlabel", ax.get_xlabel())
   .setProperty("ylabel", ax.get_ylabel())
   .setProperty("grid",   ax.grid())
   .setProperty("legend", legend)
   .setProperty("xlim",   xlim)
   .setProperty("ylim",   ylim)
   .setProperty("plots",  plots)
   .setProperty("colorbar", ax.colorbar());

   return axes;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#endif
