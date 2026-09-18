//+------------------------------------------------------------------+
//|                                                         axes.mqh |
//|                                     Copyright 2026, Omega Joctan |
//|                 https://www.mql5.com/en/users/omegajoctan/seller |
//+------------------------------------------------------------------+
#property copyright "Copyright 2026, Omega Joctan"
#property link      "https://www.mql5.com/en/users/omegajoctan/seller"
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
#include "axis.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#ifndef nandbl
#define nandbl double("nan")
#endif
#ifndef nanint
#define nanint int("nan")
#endif
//+------------------------------------------------------------------+
//| Axes                                                             |
//+------------------------------------------------------------------+
#ifndef MATPLOTLIB_AXES_CLASS

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CAxes
  {
protected:
   //--- Title and labels
   string            m_title;
   string            m_xlabel, m_ylabel;

   //--- Grid
   bool              m_grid;

   //--- Axis limits
   double            m_xmin;
   double            m_xmax;
   double            m_ymin;
   double            m_ymax;

   //--- Autoscaling
   bool              m_autoscale_x;
   bool              m_autoscale_y;

   //--- Axis visibility
   bool              m_xaxis_visible;
   bool              m_yaxis_visible;

   //--- Legend
   bool              m_legend;
   string            m_legend_loc;
   JSON::Object      *m_colorbar;

public:
                     CAxes(void);
                    ~CAxes(void);

   JSON::Object*     m_plots[];
   void              add_plot(JSON::Object *plot)
     {
      uint s = m_plots.Size();
      ArrayResize(m_plots, s + 1);
      m_plots[s] = plot;
     }

   //--- line plot
   void              CAxes::plot(const vector &x,
                                 const vector &y,
                                 string clr = NULL,
                                 string label = NULL,
                                 string marker = NULL,
                                 double linewidth = nandbl,
                                 string linestyle = NULL,
                                 string gapcolor = NULL,
                                 int markersize = nanint,
                                 int markeredgewidth = nanint,
                                 string markeredgecolor = NULL,
                                 string markerfacecolor = NULL,
                                 string markerfacecoloralt = NULL,
                                 string fillstyle = NULL,
                                 bool antialiased = true,
                                 string dash_capstyle = NULL,
                                 string solid_capstyle = NULL,
                                 string dash_joinstyle = NULL,
                                 string solid_joinstyle = NULL,
                                 int pickradius = NULL,
                                 string drawstyle = NULL);

   //--- scatter plot
   void              scatter(const vector &x,
                             const vector &y,
                             string c = NULL,
                             string label = NULL,
                             double s = nandbl,
                             string marker = NULL,
                             string cmap = NULL,
                             string norm = NULL,
                             double vmin = nandbl,
                             double vmax = nandbl,
                             double alpha = nandbl,
                             double linewidths = 1.5,
                             string edgecolors = NULL,
                             bool plotnonfinite = false
                            );

   //--- bar plot
   void              bar(string &x[],
                         vector &height,
                         string &colors[],
                         vector &xerr,
                         vector &yerr,
                         vector &bottom,
                         string label = NULL,
                         double width = nandbl,
                         string align = NULL,
                         string facecolor = NULL,
                         string edgecolor = NULL,
                         double linewidth = nandbl,
                         string tick_label = NULL,
                         string ecolor = NULL,
                         double capsize = nandbl,
                         bool log_ = false
                        );

   //--- bar plot
   void              bar(string &x[],
                         vector &height,
                         string &colors[],
                         string label = NULL,
                         double width = nandbl,
                         string align = NULL,
                         string facecolor = NULL,
                         string edgecolor = NULL,
                         double linewidth = nandbl,
                         string tick_label = NULL,
                         string ecolor = NULL,
                         double capsize = nandbl,
                         bool log_ = false
                        );

   //--- barh plot
   void              barh(string &y[],
                          vector &width,
                          string &colors[],
                          vector &xerr,
                          vector &yerr,
                          vector &bottom,
                          string label = NULL,
                          double height = nandbl,
                          string align = NULL,
                          string facecolor = NULL,
                          string edgecolor = NULL,
                          double linewidth = nandbl,
                          string tick_label = NULL,
                          string ecolor = NULL,
                          double capsize = nandbl,
                          bool log_ = false
                         );

   //--- barh plot
   void              barh(string &y[],
                          vector &width,
                          string &colors[],
                          string label = NULL,
                          double height = nandbl,
                          string align = NULL,
                          string facecolor = NULL,
                          string edgecolor = NULL,
                          double linewidth = nandbl,
                          string tick_label = NULL,
                          string ecolor = NULL,
                          double capsize = nandbl,
                          bool log_ = false
                         );

   //--- A Histogram
   void              hist(vector &x,
                          int bins,
                          vector &range,
                          vector &weights,
                          vector &bottom,
                          string clr = NULL,
                          bool density = false,
                          string label = NULL,
                          bool cumulative = false,
                          string histtype = NULL,
                          string align = NULL,
                          string orientation = NULL,
                          double rwidth = nandbl,
                          bool log_ = false,
                          bool stacked = false
                         );

   //--- A Histogram
   void              hist(vector &x,
                          int bins,
                          string clr = NULL,
                          bool density = false,
                          string label = NULL,
                          bool cumulative = false,
                          string histtype = NULL,
                          string align = NULL,
                          string orientation = NULL,
                          double rwidth = nandbl,
                          bool log_ = false,
                          bool stacked = false
                         );

   //--- Pie chart
   void              pie(vector &x,
                         string &labels[],
                         vector &explode,
                         string &colors[],
                         string &hatch[],
                         bool shadow = false,
                         string autopct = NULL,
                         double pctdistance = nandbl,
                         double labeldistance = nandbl,
                         double startangle = nandbl,
                         double radius = nandbl,
                         bool counterclock = false,
                         string wedgeprops = NULL,
                         string textprops = NULL,
                         double center_x = 0.0,
                         double center_y = 0.0,
                         bool frame = false,
                         bool rotatelabels = false,
                         bool normalize = true
                        );


   void              pie(vector &x,
                         string &labels[],
                         bool shadow = false,
                         string autopct = NULL,
                         double pctdistance = nandbl,
                         double labeldistance = nandbl,
                         double startangle = nandbl,
                         double radius = nandbl,
                         bool counterclock = false,
                         string wedgeprops = NULL,
                         string textprops = NULL,
                         double center_x = 0.0,
                         double center_y = 0.0,
                         bool frame = false,
                         bool rotatelabels = false,
                         bool normalize = true
                        );

   //--- Hex bin
   void              hexbin(vector &x,
                            vector &y,
                            vector &C,
                            vector &extent,
                            int gridsize = nanint,
                            string bins = NULL,
                            string cmap = NULL,
                            string xscale = NULL,
                            string yscale = NULL,
                            string norm = NULL,
                            double vmin = nandbl,
                            double vmax = nandbl,
                            double alpha = nandbl,
                            double linewidths = nandbl,
                            string edgecolors = NULL,
                            string reduce_C_function = NULL,
                            int mincnt = nanint,
                            bool marginals = false,
                            string colorizer = NULL
                           );

   //--- Titles and labels
   void              set_title(const string title);
   string            get_title(void) const;

   void              set_xlabel(const string label);
   string            get_xlabel(void) const;

   void              set_ylabel(const string label);
   string            get_ylabel(void) const;

   //--- Grid
   void              grid(const bool enable);
   bool              grid(void) const;

   //--- Limits
   void              set_xlim(const double xmin, const double xmax);
   void              set_ylim(const double ymin, const double ymax);

   double            xmin(void) const;
   double            xmax(void) const;
   double            ymin(void) const;
   double            ymax(void) const;

   //--- Autoscaling
   void              autoscale(const bool enable = true);

   //--- Axis visibility
   void              xaxis_visible(const bool visible = true);
   void              yaxis_visible(const bool visible = true);

   //--- Legend
   void              legend(const string loc = "");

   bool              get_legend() const { return m_legend; }
   string            legend_loc() const { return m_legend_loc; }

   //--- Clear
   void              clear(void);

   //--- Set multiple properties
   void              set(
      const string title = NULL,
      const string xlabel = NULL,
      const string ylabel = NULL,
      const double xmin = DBL_MAX,
      const double xmax = DBL_MAX,
      const double ymin = DBL_MAX,
      const double ymax = DBL_MAX
   );

   //---
   JSON::Object*      colorbar() const { return this.m_colorbar; }
   //--- color bar
   void              colorbar(string label,
                              string location = NULL,
                              string orientation = "vertical",
                              double fraction = 0.15,
                              double pad = 0.05,
                              double shrink = 1.0,
                              double aspect = 20);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CAxes::CAxes(void)
  {
   m_title  = "";

   m_grid = false;

   m_xmin = nandbl;
   m_xmax = nandbl;

   m_ymin = nandbl;
   m_ymax = nandbl;

   m_autoscale_x = true;
   m_autoscale_y = true;

   m_xaxis_visible = true;
   m_yaxis_visible = true;

   m_legend = false;
   m_legend_loc = "";
   m_colorbar = new JSON::Object();
  }

//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CAxes::~CAxes(void)
  {
   for(uint i = 0; i < m_plots.Size(); i++)
      del_valid_ptr(m_plots[i]);

   del_valid_ptr(m_colorbar)
  }
//+------------------------------------------------------------------+
//| Plot a line on the axes.                                         |
//|                                                                  |
//| Creates a CLine2D object from the supplied X/Y data and line     |
//| properties, converts it to JSON, and adds it to the axes plot    |
//| collection. The actual rendering is performed by the Python      |
//| Matplotlib server.                                               |
//|                                                                  |
//| Parameters:                                                      |
//|   x                    - X-coordinate values.                    |
//|   y                    - Y-coordinate values.                    |
//|   clr                  - Line color.                             |
//|   label                - Label used by the legend.               |
//|   marker               - Marker style for data points.           |
//|   linewidth            - Width of the line.                      |
//|   linestyle            - Line style, e.g. "-", "--", ":", "-.".  |
//|   gapcolor             - Color used for gaps in dashed lines.    |
//|   markersize           - Size of the markers.                    |
//|   markeredgewidth      - Width of the marker edge.               |
//|   markeredgecolor      - Color of the marker edge.               |
//|   markerfacecolor      - Primary marker face color.              |
//|   markerfacecoloralt   - Alternate marker face color.            |
//|   fillstyle            - Marker fill style.                      |
//|   antialiased          - Whether line rendering is antialiased.  |
//|   dash_capstyle        - Cap style used for dashed lines.        |
//|   solid_capstyle       - Cap style used for solid lines.         |
//|   dash_joinstyle       - Join style used for dashed lines.       |
//|   solid_joinstyle      - Join style used for solid lines.        |
//|   pickradius           - Picking tolerance for interactive       |
//|                          line selection.                         |
//|   drawstyle            - Draw style, e.g. "default", "steps",    |
//|                          "steps-pre", "steps-mid", or "steps-post|
//|                                                                  |
//| Notes:                                                           |
//|   The X and Y vectors should contain the same number of values.  |
//|   Empty or default styling parameters are passed through the     |
//|   JSON layer and are interpreted by the Python Matplotlib server.|
//|                                                                  |
//| Example:                                                         |
//|   vector x = {1, 2, 3, 4};                                       |
//|   vector y = {2, 4, 3, 5};                                       |
//|                                                                  |
//|   ax.plot(x, y, "blue", "Price", "o", 2.0, "-", ...);            |
//|                                                                  |
//+------------------------------------------------------------------+
void CAxes::plot(const vector &x,
                 const vector &y,
                 string clr,
                 string label,
                 string marker,
                 double linewidth,
                 string linestyle,
                 string gapcolor,
                 int markersize,
                 int markeredgewidth,
                 string markeredgecolor,
                 string markerfacecolor,
                 string markerfacecoloralt,
                 string fillstyle,
                 bool antialiased,
                 string dash_capstyle,
                 string solid_capstyle,
                 string dash_joinstyle,
                 string solid_joinstyle,
                 int pickradius,
                 string drawstyle)
  {
   CLine2D line;

//--- Values assignments
   line.x                    = x;
   line.y                    = y;
   line.clr                  = clr;
   line.label                = label;
   line.marker               = marker;
   line.linewidth            = linewidth;
   line.linestyle            = linestyle;
   line.gapcolor             = gapcolor;
   line.markersize           = markersize;
   line.markeredgewidth      = markeredgewidth;
   line.markeredgecolor      = markeredgecolor;
   line.markerfacecolor      = markerfacecolor;
   line.markerfacecoloralt   = markerfacecoloralt;
   line.fillstyle            = fillstyle;
   line.antialiased          = antialiased;
   line.dash_capstyle        = dash_capstyle;
   line.solid_capstyle       = solid_capstyle;
   line.dash_joinstyle       = dash_joinstyle;
   line.solid_joinstyle      = solid_joinstyle;
   line.pickradius           = pickradius;
   line.drawstyle            = drawstyle;

   add_plot(line.toJSON());
  }
//+------------------------------------------------------------------+
//| Scatter plot                                                     |
//|                                                                  |
//| Creates a scatter plot from the supplied X/Y coordinates and     |
//| styling properties. The scatter plot is represented internally   |
//| by a CScatter object, serialized to JSON, and added to the axes. |
//| The resulting JSON is later processed by the Python Matplotlib   |
//| server to render the plot.                                       |
//|                                                                  |
//| Parameters:                                                      |
//|   x             - X-coordinate values for the data points.       |
//|   y             - Y-coordinate values for the data points.       |
//|   c             - Marker colors. Can be a single color or a      |
//|                   color specification used to map values through |
//|                   a colormap.                                    |
//|   label         - Label associated with the scatter plot, used   |
//|                   when displaying the legend.                    |
//|   s             - Marker size.                                   |
//|   marker        - Marker style used for each data point.         |
//|   cmap          - Colormap used when colors are mapped from      |
//|                   numerical values.                              |
//|   norm          - Normalization used to scale values before      |
//|                   applying the colormap.                         |
//|   vmin          - Lower bound of the data range used for color   |
//|                   normalization.                                 |
//|   vmax          - Upper bound of the data range used for color   |
//|                   normalization.                                 |
//|   alpha         - Marker transparency, where 0 is fully          |
//|                   transparent and 1 is fully opaque.             |
//|   linewidths    - Width of the marker edges.                     |
//|   edgecolors    - Color of the marker edges.                     |
//|   plotnonfinite - Specifies whether non-finite values are        |
//|                   plotted.                                       |
//|                                                                  |
//| Notes:                                                           |
//|   The X and Y vectors should contain corresponding coordinate    |
//|   values. Each X value is paired with the Y value at the same    |
//|   index.                                                         |
//|                                                                  |
//|   The scatter plot is not rendered directly by MQL5. Instead,    |
//|   its properties are serialized into JSON and sent to the Python |
//|   Matplotlib server for rendering.                               |
//+------------------------------------------------------------------+
void CAxes::scatter(const vector &x,
                    const vector &y,
                    string c,
                    string label,
                    double s,
                    string marker,
                    string cmap,
                    string norm,
                    double vmin,
                    double vmax,
                    double alpha,
                    double linewidths,
                    string edgecolors,
                    bool plotnonfinite
                   )
  {
   CScatter scatter;

//--- Values assignments
   scatter.x             = x;
   scatter.y             = y;
   scatter.label         = label;
   scatter.s             = s;
   scatter.c             = c;
   scatter.marker        = marker;
   scatter.cmap          = cmap;
   scatter.norm          = norm;
   scatter.vmin          = vmin;
   scatter.vmax          = vmax;
   scatter.alpha         = alpha;
   scatter.linewidths    = linewidths;
   scatter.edgecolors    = edgecolors;
   scatter.plotnonfinite = plotnonfinite;

//--- Add plot to Axes
   add_plot(scatter.toJSON());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//| Creates a bar plot and adds it to the axes.                      |
//|                                                                  |
//| Parameters:                                                      |
//|      x          -  x coordinates of the bars.                    |
//|      height     -  height of each bar.                           |
//|      xerr       -  horizontal error bar values.                  |
//|      yerr       -  vertical error bar values.                    |
//|      bottom     -  y coordinate of the bottom of each bar.       |
//|      clr        -  color of the bars.                            |
//|      label      -  label used for the legend.                    |
//|      width      -  width of the bars.                            |
//|      align      -  alignment of the bars ('center' or 'edge').   |
//|      facecolor  -  face color of the bars.                       |
//|      edgecolor  -  edge color of the bars.                       |
//|      linewidth  -  width of the bar edges.                       |
//|      tick_label -  labels displayed on the x-axis ticks.         |
//|      ecolor     -  color of the error bars.                      |
//|      capsize    -  length of the error bar caps.                 |
//|      log_       -  whether to use a logarithmic y-axis.          |
//+------------------------------------------------------------------+
void CAxes::bar(string &x[],
                vector &height,
                string &colors[],
                vector &xerr,
                vector &yerr,
                vector &bottom,
                string label,
                double width,
                string align,
                string facecolor,
                string edgecolor,
                double linewidth,
                string tick_label,
                string ecolor,
                double capsize,
                bool log_
               )
  {
//--- Create bar plot object
   CBar bar;

//--- Data
   ArrayCopy(bar.x, x);
   bar.height = height;
   ArrayCopy(bar.colors, colors);
   bar.xerr   = xerr;
   bar.yerr   = yerr;
   bar.bottom = bottom;

//--- Bar properties
   bar.label      = label;
   bar.width      = width;
   bar.align      = align;
   bar.facecolor  = facecolor;
   bar.edgecolor  = edgecolor;
   bar.linewidth  = linewidth;
   bar.tick_label = tick_label;

//--- Error bar properties
   bar.ecolor  = ecolor;
   bar.capsize = capsize;

//--- Logarithmic y-axis
   bar.log_ = log_;

//--- Add plot to the axes
   add_plot(bar.toJSON());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CAxes::bar(string &x[],
                vector &height,
                string &colors[],
                string label,
                double width,
                string align,
                string facecolor,
                string edgecolor,
                double linewidth,
                string tick_label,
                string ecolor,
                double capsize,
                bool log_
               )
  {
   this.bar(x, height, colors, vector::Zeros(0), vector::Zeros(0), vector::Zeros(0), label,
            width, align, facecolor, edgecolor, linewidth, tick_label, ecolor, capsize, log_);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//| Creates a horizontal bar plot and adds it to the axes.           |
//|                                                                  |
//| Parameters:                                                      |
//|      x          -  x coordinates of the bars.                    |
//|      width      -  width of each bar.                            |
//|      xerr       -  horizontal error bar values.                  |
//|      yerr       -  vertical error bar values.                    |
//|      bottom     -  y coordinate of the bottom of each bar.       |
//|      clr        -  color of the bars.                            |
//|      label      -  label used for the legend.                    |
//|      width      -  width of the bars.                            |
//|      align      -  alignment of the bars ('center' or 'edge').   |
//|      facecolor  -  face color of the bars.                       |
//|      edgecolor  -  edge color of the bars.                       |
//|      linewidth  -  width of the bar edges.                       |
//|      tick_label -  labels displayed on the x-axis ticks.         |
//|      ecolor     -  color of the error bars.                      |
//|      capsize    -  length of the error bar caps.                 |
//|      log_       -  whether to use a logarithmic y-axis.          |
//|                                                                  |
//+------------------------------------------------------------------+
void CAxes::barh(string &y[],
                 vector &width,
                 string &colors[],
                 vector &xerr,
                 vector &yerr,
                 vector &bottom,
                 string label,
                 double height,
                 string align,
                 string facecolor,
                 string edgecolor,
                 double linewidth,
                 string tick_label,
                 string ecolor,
                 double capsize,
                 bool log_)
  {
//--- Create bar plot object
   CBarh barh;

//--- Data
   ArrayCopy(barh.y, y);
   barh.height = height;
   ArrayCopy(barh.colors, colors);
   barh.xerr   = xerr;
   barh.yerr   = yerr;

//--- Bar properties
   barh.label      = label;
   barh.width      = width;
   barh.align      = align;
   barh.facecolor  = facecolor;
   barh.edgecolor  = edgecolor;
   barh.linewidth  = linewidth;
   barh.tick_label = tick_label;

//--- Error bar properties
   barh.ecolor  = ecolor;
   barh.capsize = capsize;

//--- Logarithmic y-axis
   barh.log_ = log_;

//--- Add plot to the axes
   add_plot(barh.toJSON());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CAxes::barh(string &y[],
                 vector &width,
                 string &colors[],
                 string label,
                 double height,
                 string align,
                 string facecolor,
                 string edgecolor,
                 double linewidth,
                 string tick_label,
                 string ecolor,
                 double capsize,
                 bool log_
                )
  {
   this.barh(y, width, colors, vector::Zeros(0), vector::Zeros(0), vector::Zeros(0), label,
             height, align, facecolor, edgecolor, linewidth, tick_label, ecolor, capsize, log_);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//| Creates a histogram and adds it to the axes.                     |
//|                                                                  |
//| Parameters:                                                      |
//|      x           - Input data values used to construct the       |
//|                    histogram.                                    |
//|      bins        - Number of equal-width bins used to divide     |
//|                    the data range.                               |
//|      range       - Lower and upper limits of the bin range.      |
//|      weights     - Weights assigned to individual data values.   |
//|      bottom      - Vertical starting position of the histogram   |
//|                    bars.                                         |
//|      clr         - Color of the histogram.                       |
//|      density     - If true, normalize the histogram to display   |
//|                    a probability density instead of raw counts.  |
//|      label       - Label assigned to the histogram for use in    |
//|                    the axes legend.                              |
//|      cumulative  - If true, display cumulative counts rather     |
//|                    than individual bin counts.                   |
//|      histtype    - Histogram style: 'bar', 'barstacked',         |
//|                    'step', or 'stepfilled'.                      |
//|      align       - Horizontal alignment of the histogram bars:   |
//|                    'left', 'mid', or 'right'.                    |
//|      orientation - Orientation of the histogram: 'vertical' or   |
//|                    'horizontal'.                                 |
//|      rwidth      - Relative width of the histogram bars as a     |
//|                    fraction of the bin width.                    |
//|      log_        - If true, use a logarithmic scale for the      |
//|                    histogram axis.                               |
//|      stacked     - If true, stack multiple histogram datasets    |
//|                    on top of each other.                         |
//|                                                                  |
//+------------------------------------------------------------------+
void CAxes::hist(vector &x,
                 int bins,
                 vector &range,
                 vector &weights,
                 vector &bottom,
                 string clr,
                 bool density,
                 string label,
                 bool cumulative,
                 string histtype,
                 string align,
                 string orientation,
                 double rwidth,
                 bool log_,
                 bool stacked
                )
  {
   CHist hist;

   hist.x = x;
   hist.bins = bins;
   hist.range = range;
   hist.weights = weights;
   hist.bottom = bottom;
   hist.clr = clr;
   hist.density = density;
   hist.label = label;
   hist.cumulative = cumulative;
   hist.histtype = histtype;
   hist.align = align;
   hist.orientation = orientation;
   hist.rwidth = rwidth;
   hist.log_ = log_;
   hist.stacked = stacked;

//---

   add_plot(hist.toJSON());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CAxes::hist(vector &x,
                 int bins,
                 string clr,
                 bool density,
                 string label,
                 bool cumulative,
                 string histtype,
                 string align,
                 string orientation,
                 double rwidth,
                 bool log_,
                 bool stacked
                )
  {
   this.hist(x, bins, vector::Zeros(0), vector::Zeros(0), vector::Zeros(0), clr, density,
             label, cumulative, histtype, align, orientation, rwidth, log_, stacked);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//| Creates a pie chart and adds it to the axes.                     |
//|                                                                  |
//| A pie chart represents the relative proportions of a dataset.    |
//| Each value in x determines the size of one wedge, with the       |
//| fraction of the pie calculated as x / sum(x).                    |
//|                                                                  |
//| Parameters:                                                      |
//|      x             -  Values determining the size of each        |
//|                       wedge.                                     |
//|      labels        -  Labels associated with each wedge.         |
//|      explode       -  Offset of each wedge from the center,      |
//|                       expressed as a fraction of the radius.     |
//|      colors        -  Colors assigned to the wedges.             |
//|      hatch         -  Hatching patterns applied to the wedges.   |
//|      shadow        -  Whether to draw a shadow beneath the       |
//|                       pie.                                       |
//|      autopct       -  Format string used to display the          |
//|                       percentage of each wedge.                  |
//|      pctdistance   -  Relative distance from the center at       |
//|                       which percentage labels are displayed.     |
//|      labeldistance -  Relative distance from the center at       |
//|                       which wedge labels are displayed.          |
//|      startangle    -  Rotation angle of the first wedge in       |
//|                       degrees, measured counterclockwise from    |
//|                       the x-axis.                                |
//|      radius        -  Radius of the pie chart.                   |
//|      counterclock  -  Direction in which wedges are drawn.       |
//|                       true draws them counterclockwise; false    |
//|                       draws them clockwise.                      |
//|      wedgeprops    -  Properties applied to each pie wedge.      |
//|                       Passed to matplotlib's Wedge objects.      |
//|      textprops     -  Properties applied to the text objects     |
//|                       used for labels and percentages.           |
//|      center_x      -  X coordinate of the center of the pie.     |
//|      center_y      -  Y coordinate of the center of the pie.     |
//|      frame         -  Whether to display the axes frame around   |
//|                       the pie chart.                             |
//|      rotatelabels  -  Whether to rotate each wedge label to      |
//|                       match the angle of its corresponding       |
//|                       wedge.                                     |
//|      normalize     -  Whether to normalize x so that the values  |
//|                       fill a complete pie.                       |
//|                                                                  |
//| Notes:                                                           |
//|      The explode, labels, colors, and hatch arrays should        |
//|      correspond to the values in x.                              |
//|                                                                  |
//|      When normalize is true, the values in x are normalized so   |
//|      that their sum represents 100% of the pie.                  |
//|                                                                  |
//|      When normalize is false, x must sum to 1 or less, allowing  |
//|      a partial pie to be displayed.                              |
//|                                                                  |
//+------------------------------------------------------------------+
void CAxes::pie(vector &x,
                string &labels[],
                vector &explode,
                string &colors[],
                string &hatch[],
                bool shadow,
                string autopct,
                double pctdistance,
                double labeldistance,
                double startangle,
                double radius,
                bool counterclock,
                string wedgeprops,
                string textprops,
                double center_x,
                double center_y,
                bool frame,
                bool rotatelabels,
                bool normalize
               )
  {
   CPie pie;

//---

   pie.x = x;
   pie.explode = explode;

   ArrayCopy(pie.labels, labels);
   ArrayCopy(pie.colors, colors);
   ArrayCopy(pie.hatch, hatch);

   pie.shadow = shadow;
   pie.autopct = autopct;
   pie.pctdistance = pctdistance;
   pie.labeldistance = labeldistance;
   pie.startangle = startangle;
   pie.radius = radius;
   pie.counterclock = counterclock;
   pie.wedgeprops = wedgeprops;
   pie.textprops = textprops;
   pie.center_x = center_x;
   pie.center_y = center_y;
   pie.frame = frame;
   pie.rotatelabels = rotatelabels;
   pie.normalize = normalize;

   this.add_plot(pie.toJSON());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CAxes::pie(vector &x,
                string &labels[],
                bool shadow,
                string autopct,
                double pctdistance,
                double labeldistance,
                double startangle,
                double radius,
                bool counterclock,
                string wedgeprops,
                string textprops,
                double center_x,
                double center_y,
                bool frame,
                bool rotatelabels,
                bool normalize
               )
  {
   CPie pie;

//---

   pie.x = x;
   string colors[], hatch[];

   this.pie(x, labels, vector::Zeros(0), colors, hatch, shadow, autopct, pctdistance, labeldistance,
            startangle, radius, counterclock, wedgeprops, textprops, center_x, center_y, frame, rotatelabels, normalize);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//| Creates a hexagonal binning plot and adds it to the axes.        |
//|                                                                  |
//| A hexbin plot divides the x-y plane into hexagonal cells and     |
//| aggregates the observations that fall within each cell. The      |
//| color of each hexagon represents the number of observations or   |
//| an aggregated value supplied through C.                          |
//|                                                                  |
//| Parameters:                                                      |
//|      x                   - X coordinates of the data points.     |
//|      y                   - Y coordinates of the data points.     |
//|      C                   - Values associated with each point,    |
//|                            used to calculate the color/value of  |
//|                            each hexagonal bin.                   |
//|      extent              - The [xmin, xmax, ymin, ymax] range of |
//|                            the binning area.                     |
//|      gridsize             - Number of hexagonal bins along the   |
//|                            x-axis.                               |
//|      bins                 - Binning/color scaling method, such   |
//|                            as 'log'.                             |
//|      cmap                 - Colormap used to map bin values to   |
//|                            colors, e.g. 'viridis' or 'inferno'.  |
//|      xscale               - Scale of the x-axis, e.g. 'linear'   |
//|                            or 'log'.                             |
//|      yscale               - Scale of the y-axis, e.g. 'linear'   |
//|                            or 'log'.                             |
//|      norm                 - Normalization method used to map     |
//|                            values to the colormap.               |
//|      vmin                 - Minimum value used for color         |
//|                            normalization.                        |
//|      vmax                 - Maximum value used for color         |
//|                            normalization.                        |
//|      alpha                - Transparency of the hexagons, from   |
//|                            0.0 (transparent) to 1.0 (opaque).    |
//|      linewidths           - Width of the hexagon edge lines.     |
//|      edgecolors           - Color of the hexagon edges.          |
//|      reduce_C_function    - Function used to aggregate C values  |
//|                            within each hexagonal bin, such as    |
//|                            'mean', 'sum', or 'max'.              |
//|      mincnt               - Minimum number of observations       |
//|                            required for a hexagon to be shown.   |
//|      marginals            - Whether to display marginal          |
//|                            distributions along the axes.         |
//|      colorizer            - Color mapping configuration used to  |
//|                            map bin values to colors.             |
//|                                                                  |
//+------------------------------------------------------------------+
void CAxes::hexbin(vector &x,
                   vector &y,
                   vector &C,
                   vector &extent,
                   int gridsize,
                   string bins,
                   string cmap,
                   string xscale,
                   string yscale,
                   string norm,
                   double vmin,
                   double vmax,
                   double alpha,
                   double linewidths,
                   string edgecolors,
                   string reduce_C_function,
                   int mincnt,
                   bool marginals,
                   string colorizer
                  )
  {
   CHexbin hexbin;

   hexbin.x = x;
   hexbin.y = y;
   hexbin.C = C;
   hexbin.extent = extent;
   hexbin.gridsize = gridsize;
   hexbin.bins = bins;
   hexbin.cmap = cmap;
   hexbin.xscale = xscale;
   hexbin.yscale = yscale;
   hexbin.norm = norm;
   hexbin.vmin = vmin;
   hexbin.vmax = vmax;
   hexbin.alpha = alpha;
   hexbin.linewidths = linewidths;
   hexbin.edgecolors = edgecolors;
   hexbin.reduce_C_function = reduce_C_function;
   hexbin.mincnt = mincnt;
   hexbin.marginals = marginals;
   hexbin.colorizer = colorizer;

   this.add_plot(hexbin.toJSON());
  }
//+------------------------------------------------------------------+
//| Set title                                                        |
//+------------------------------------------------------------------+
void CAxes::set_title(const string title)
  {
   m_title = title;
  }
//+------------------------------------------------------------------+
//| Get title                                                        |
//+------------------------------------------------------------------+
string CAxes::get_title(void) const
  {
   return m_title;
  }

//+------------------------------------------------------------------+
//| Set X label                                                      |
//+------------------------------------------------------------------+
void CAxes::set_xlabel(const string label)
  {
   m_xlabel = label;
  }

//+------------------------------------------------------------------+
//| Get X label                                                      |
//+------------------------------------------------------------------+
string CAxes::get_xlabel(void) const
  {
   return m_xlabel;
  }

//+------------------------------------------------------------------+
//| Set Y label                                                      |
//+------------------------------------------------------------------+
void CAxes::set_ylabel(const string label)
  {
   m_ylabel = label;
  }

//+------------------------------------------------------------------+
//| Get Y label                                                      |
//+------------------------------------------------------------------+
string CAxes::get_ylabel(void) const
  {
   return m_ylabel;
  }

//+------------------------------------------------------------------+
//| Grid                                                             |
//+------------------------------------------------------------------+
void CAxes::grid(const bool enable)
  {
   m_grid = enable;
  }

//+------------------------------------------------------------------+
//| Get grid state                                                   |
//+------------------------------------------------------------------+
bool CAxes::grid(void) const
  {
   return m_grid;
  }

//+------------------------------------------------------------------+
//| Set X limits                                                     |
//+------------------------------------------------------------------+
void CAxes::set_xlim(const double xmin,
                     const double xmax)
  {
   m_xmin = xmin;
   m_xmax = xmax;

   m_autoscale_x = false;
  }

//+------------------------------------------------------------------+
//| Set Y limits                                                     |
//+------------------------------------------------------------------+
void CAxes::set_ylim(const double ymin,
                     const double ymax)
  {
   m_ymin = ymin;
   m_ymax = ymax;

   m_autoscale_y = false;
  }

//+------------------------------------------------------------------+
//| Get X minimum                                                    |
//+------------------------------------------------------------------+
double CAxes::xmin(void) const
  {
   return m_xmin;
  }

//+------------------------------------------------------------------+
//| Get X maximum                                                    |
//+------------------------------------------------------------------+
double CAxes::xmax(void) const
  {
   return m_xmax;
  }

//+------------------------------------------------------------------+
//| Get Y minimum                                                    |
//+------------------------------------------------------------------+
double CAxes::ymin(void) const
  {
   return m_ymin;
  }

//+------------------------------------------------------------------+
//| Get Y maximum                                                    |
//+------------------------------------------------------------------+
double CAxes::ymax(void) const
  {
   return m_ymax;
  }

//+------------------------------------------------------------------+
//| Autoscale                                                        |
//+------------------------------------------------------------------+
void CAxes::autoscale(const bool enable)
  {
   m_autoscale_x = enable;
   m_autoscale_y = enable;
  }

//+------------------------------------------------------------------+
//| X axis visibility                                                |
//+------------------------------------------------------------------+
void CAxes::xaxis_visible(const bool visible)
  {
   m_xaxis_visible = visible;
  }

//+------------------------------------------------------------------+
//| Y axis visibility                                                |
//+------------------------------------------------------------------+
void CAxes::yaxis_visible(const bool visible)
  {
   m_yaxis_visible = visible;
  }

//+------------------------------------------------------------------+
//| Legend                                                           |
//+------------------------------------------------------------------+
void CAxes::legend(const string loc)
  {
   m_legend = true;
   m_legend_loc = loc;
  }
//+------------------------------------------------------------------+
//| Clear                                                            |
//+------------------------------------------------------------------+
void CAxes::clear(void)
  {
   m_title = "";
   m_xlabel = "";
   m_ylabel = "";

   m_grid = false;

   m_legend = false;
  }
//+------------------------------------------------------------------+
//| Set multiple Axes properties                                     |
//+------------------------------------------------------------------+
void CAxes::set(
   const string title,
   const string xlabel,
   const string ylabel,
   const double xmin,
   const double xmax,
   const double ymin,
   const double ymax
)
  {
//--- Title
   if(title != NULL)
      set_title(title);

//--- X label
   if(xlabel != NULL)
      set_xlabel(xlabel);

//--- Y label
   if(ylabel != NULL)
      set_ylabel(ylabel);

//--- X limits
   if(xmin != DBL_MAX && xmax != DBL_MAX)
      set_xlim(xmin, xmax);

//--- Y limits
   if(ymin != DBL_MAX && ymax != DBL_MAX)
      set_ylim(ymin, ymax);
  }
//+------------------------------------------------------------------+
//| Configures a colorbar for the axes.                              |
//|                                                                  |
//| The colorbar provides a visual mapping between the colors used   |
//| by a mappable plot (such as hexbin, scatter, or other colored    |
//| plots) and their corresponding data values.                      |
//|                                                                  |
//| Parameters:                                                      |
//|      label       - Label displayed alongside the colorbar.       |
//|      location    - Location of the colorbar relative to the      |
//|                    axes (e.g. 'right', 'left', 'top', or         |
//|                    'bottom').                                    |
//|      orientation - Orientation of the colorbar: 'vertical' or    |
//|                    'horizontal'.                                 |
//|      fraction    - Fraction of the original axes size used for   |
//|                    the colorbar.                                 |
//|      pad         - Padding between the axes and the colorbar.    |
//|                    If the default value (0.05) is supplied, the  |
//|                    value is automatically adjusted to 0.15 for   |
//|                    horizontal colorbars and 0.05 for vertical    |
//|                    colorbars.                                    |
//|      shrink      - Fraction by which to shrink the colorbar      |
//|                    relative to the axes.                         |
//|      aspect      - Ratio of the colorbar's long dimension to     |
//|                    its short dimension.                          |
//|                                                                  |
//| Notes:                                                           |
//|      The colorbar configuration is stored in the axes and is     |
//|      serialized to JSON together with the figure. The Python     |
//|      backend uses this information to create the colorbar using  |
//|      matplotlib.figure.Figure.colorbar().                        |
//+------------------------------------------------------------------+
void CAxes::colorbar(string label,
                     string location,
                     string orientation,
                     double fraction,
                     double pad,
                     double shrink,
                     double aspect)
  {
   double pad_value = pad;
   if(pad_value == 0.05)  //Default value used
      pad_value = (orientation == "horizontal") ? 0.15 : 0.05;

   m_colorbar
   .setProperty("label",       label)
   .setProperty("orientation", orientation)
   .setProperty("fraction",    fraction)
   .setProperty("pad",         pad_value)
   .setProperty("shrink",      shrink)
   .setProperty("aspect",      aspect)
   .setProperty("location",    location);
  }
#endif
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

