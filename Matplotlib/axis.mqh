//+------------------------------------------------------------------+
//|                                                         axis.mqh |
//|                                     Copyright 2026, Omega Joctan |
//|                 https://www.mql5.com/en/users/omegajoctan/seller |
//+------------------------------------------------------------------+
#property copyright "Copyright 2026, Omega Joctan"
#property link      "https://www.mql5.com/en/users/omegajoctan/seller"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include "JSON.mqh"
//+------------------------------------------------------------------+
//| A class containing information about the line plot.              |
//+------------------------------------------------------------------+
class CLine2D
  {
public:

   vector            x, y;
   string            label;
   double            linewidth;
   string            linestyle;
   string            clr;
   string            gapcolor;
   string            marker;
   int               markersize;
   int               markeredgewidth;
   string            markeredgecolor;
   string            markerfacecolor;
   string            markerfacecoloralt;
   string            fillstyle;
   bool              antialiased;
   string            dash_capstyle;
   string            solid_capstyle;
   string            dash_joinstyle;
   string            solid_joinstyle;
   int               pickradius;
   string            drawstyle;

   JSON::Object*     toJSON(void)
     {
      JSON::Array *x_data = new JSON::Array();
      JSON::Array *y_data = new JSON::Array();

      for(ulong i = 0; i < x.Size(); i++)
         x_data.add(x[i]);

      for(ulong i = 0; i < y.Size(); i++)
         y_data.add(y[i]);

      JSON::Object *line = new JSON::Object();

      line
      .setProperty("type",              "line")
      .setProperty("x",                 x_data)
      .setProperty("y",                 y_data)
      .setProperty("label",             label)
      .setProperty("linewidth",         linewidth)
      .setProperty("linestyle",         linestyle)
      .setProperty("color",             clr)
      .setProperty("gapcolor",          gapcolor)
      .setProperty("marker",            marker)
      .setProperty("markersize", (int)markersize)
      .setProperty("markeredgewidth", (int)markeredgewidth)
      .setProperty("markeredgecolor",    markeredgecolor)
      .setProperty("markerfacecolor",    markerfacecolor)
      .setProperty("markerfacecoloralt", markerfacecoloralt)
      .setProperty("fillstyle",          fillstyle)
      .setProperty("antialiased",        antialiased)
      .setProperty("dash_capstyle",      dash_capstyle)
      .setProperty("solid_capstyle",     solid_capstyle)
      .setProperty("dash_joinstyle",     dash_joinstyle)
      .setProperty("solid_joinstyle",    solid_joinstyle)
      .setProperty("pickradius", (int)pickradius)
      .setProperty("drawstyle",          drawstyle);

      return line;
     }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CScatter
  {
public:

   vector            x, y;
   string            label;
   double            s;
   string            c;
   string            marker;
   string            cmap;
   string            norm;
   double            vmin;
   double            vmax;
   double            alpha;
   double            linewidths;
   string            edgecolors;
   bool              plotnonfinite;

   JSON::Object*     toJSON(void)
     {
      JSON::Array *x_data = new JSON::Array();
      JSON::Array *y_data = new JSON::Array();

      for(ulong i = 0; i < x.Size(); i++)
         x_data.add(x[i]);

      for(ulong i = 0; i < y.Size(); i++)
         y_data.add(y[i]);

      JSON::Object *scatter = new JSON::Object();

      scatter
      .setProperty("type",          "scatter")
      .setProperty("x",             x_data)
      .setProperty("y",             y_data)
      .setProperty("label",         label)
      .setProperty("s",             s)
      .setProperty("c",             c)
      .setProperty("marker",        marker)
      .setProperty("cmap",          cmap)
      .setProperty("norm",          norm)
      .setProperty("vmin",          vmin)
      .setProperty("vmax",          vmax)
      .setProperty("alpha",         alpha)
      .setProperty("linewidths",    linewidths)
      .setProperty("edgecolors",    edgecolors)
      .setProperty("plotnonfinite", plotnonfinite);

      return scatter;
     }
  };
//+------------------------------------------------------------------+
//| A class containing information about the bar plot.               |
//+------------------------------------------------------------------+
class CBar
  {
public:

   string            x[];
   vector            height;

   double            width;
   vector            bottom;

   string            align;

   string            colors[];
   string            facecolor;
   string            edgecolor;

   double            linewidth;

   string            tick_label;
   string            label;

   vector            xerr;
   vector            yerr;

   string            ecolor;
   double            capsize;

   bool              log_;

   //+------------------------------------------------------------------+
   //| Converts the bar plot information to a JSON object.              |
   //+------------------------------------------------------------------+
   JSON::Object*     toJSON(void)
     {
      //--- X data
      JSON::Array *x_data = new JSON::Array();

      for(ulong i = 0; i < x.Size(); i++)
         x_data.add(x[i]);

      //--- Height data
      JSON::Array *height_data = new JSON::Array();

      for(ulong i = 0; i < height.Size(); i++)
         height_data.add(height[i]);

      //--- colors
      JSON::Array *colors_array = new JSON::Array();

      for(ulong i = 0; i < colors.Size(); i++)
         colors_array.add(colors[i]);

      //--- Bottom data
      JSON::Array *bottom_data = new JSON::Array();

      for(ulong i = 0; i < bottom.Size(); i++)
         bottom_data.add(bottom[i]);

      //--- X error data
      JSON::Array *xerr_data = new JSON::Array();

      for(ulong i = 0; i < xerr.Size(); i++)
         xerr_data.add(xerr[i]);

      //--- Y error data
      JSON::Array *yerr_data = new JSON::Array();

      for(ulong i = 0; i < yerr.Size(); i++)
         yerr_data.add(yerr[i]);

      //--- Bar object
      JSON::Object *bar = new JSON::Object();

      bar
      .setProperty("type",       "bar")
      .setProperty("x",          x_data)
      .setProperty("height",     height_data)
      .setProperty("width",      width)
      .setProperty("bottom",     bottom_data)
      .setProperty("align",      align)
      .setProperty("color",      colors_array)
      .setProperty("facecolor",  facecolor)
      .setProperty("edgecolor",  edgecolor)
      .setProperty("linewidth",  linewidth)
      .setProperty("tick_label", tick_label)
      .setProperty("label",      label)
      .setProperty("xerr",       xerr_data)
      .setProperty("yerr",       yerr_data)
      .setProperty("ecolor",     ecolor)
      .setProperty("capsize",    capsize)
      .setProperty("log",        log_);

      return bar;
     }
  };
//+------------------------------------------------------------------+
//| A class containing information about the horizontal bar plot.    |
//+------------------------------------------------------------------+
class CBarh
  {
public:

   string            y[];
   vector            width;

   double            height;
   vector            left;

   string            align;

   string            colors[];
   string            facecolor;
   string            edgecolor;

   double            linewidth;

   string            tick_label;
   string            label;

   vector            xerr;
   vector            yerr;

   string            ecolor;
   double            capsize;

   bool              log_;

   //+------------------------------------------------------------------+
   //| Converts the horizontal bar plot information to a JSON object.   |
   //+------------------------------------------------------------------+
   JSON::Object*     toJSON(void)
     {
      //--- Y data
      JSON::Array *y_data = new JSON::Array();

      for(ulong i = 0; i < y.Size(); i++)
         y_data.add(y[i]);

      //--- Width data
      JSON::Array *width_data = new JSON::Array();

      for(ulong i = 0; i < width.Size(); i++)
         width_data.add(width[i]);

      //--- Colors
      JSON::Array *colors_array = new JSON::Array();

      for(ulong i = 0; i < colors.Size(); i++)
         colors_array.add(colors[i]);

      //--- Left data
      JSON::Array *left_data = new JSON::Array();

      for(ulong i = 0; i < left.Size(); i++)
         left_data.add(left[i]);

      //--- X error data
      JSON::Array *xerr_data = new JSON::Array();

      for(ulong i = 0; i < xerr.Size(); i++)
         xerr_data.add(xerr[i]);

      //--- Y error data
      JSON::Array *yerr_data = new JSON::Array();

      for(ulong i = 0; i < yerr.Size(); i++)
         yerr_data.add(yerr[i]);

      //--- Horizontal bar object
      JSON::Object *barh = new JSON::Object();

      barh
      .setProperty("type",       "barh")
      .setProperty("y",          y_data)
      .setProperty("width",      width_data)
      .setProperty("height",     height)
      .setProperty("left",       left_data)
      .setProperty("align",      align)
      .setProperty("color",      colors_array)
      .setProperty("facecolor",  facecolor)
      .setProperty("edgecolor",  edgecolor)
      .setProperty("linewidth",  linewidth)
      .setProperty("tick_label", tick_label)
      .setProperty("label",      label)
      .setProperty("xerr",       xerr_data)
      .setProperty("yerr",       yerr_data)
      .setProperty("ecolor",     ecolor)
      .setProperty("capsize",    capsize)
      .setProperty("log",        log_);

      return barh;
     }
  };
//+------------------------------------------------------------------+
//| A class containing information about the histogram plot.         |
//+------------------------------------------------------------------+
class CHist
  {
public:

   vector            x;

   int               bins;
   string            clr;
   string            label;
   vector            range;

   vector            weights;
   vector            bottom;

   bool              density;
   bool              cumulative;

   string            histtype;
   string            align;
   string            orientation;

   double            rwidth;
   bool              log_;

   bool              stacked;

   //+------------------------------------------------------------------+
   //| Converts the histogram plot information to a JSON object.        |
   //+------------------------------------------------------------------+
   JSON::Object*     toJSON(void)
     {
      //--- X data
      JSON::Array *x_data = new JSON::Array();

      for(ulong i = 0; i < x.Size(); i++)
         x_data.add(x[i]);

      //--- Weights
      JSON::Array *weights_data = new JSON::Array();

      for(ulong i = 0; i < weights.Size(); i++)
         weights_data.add(weights[i]);

      //--- Bottom
      JSON::Array *bottom_data = new JSON::Array();

      for(ulong i = 0; i < bottom.Size(); i++)
         bottom_data.add(bottom[i]);

      //--- Range
      JSON::Array *range_data = new JSON::Array();

      for(ulong i = 0; i < range.Size(); i++)
         range_data.add(range[i]);

      //--- Histogram object
      JSON::Object *hist = new JSON::Object();

      hist
      .setProperty("type",        "hist")
      .setProperty("x",           x_data)
      .setProperty("bins",        (int)bins)
      .setProperty("range",       range_data)
      .setProperty("density",     density)
      .setProperty("weights",     weights_data)
      .setProperty("cumulative",  cumulative)
      .setProperty("bottom",      bottom_data)
      .setProperty("histtype",    histtype)
      .setProperty("align",       align)
      .setProperty("orientation", orientation)
      .setProperty("rwidth",      rwidth)
      .setProperty("log",         log_)
      .setProperty("color",       clr)
      .setProperty("label",       label)
      .setProperty("stacked",     stacked);

      return hist;
     }
  };
//+------------------------------------------------------------------+
//| A class containing information about the pie chart.              |
//+------------------------------------------------------------------+
class CPie
  {
public:

   //--- Pie data
   vector            x;

   //--- Slice properties
   vector            explode;
   string            labels[];
   string            colors[];
   string            hatch[];

   //--- Label and percentage formatting
   string            autopct;
   double            pctdistance;
   double            labeldistance;

   //--- Pie appearance
   bool              shadow;
   double            startangle;
   double            radius;
   bool              counterclock;

   //--- Wedge and text properties
   string            wedgeprops;
   string            textprops;

   //--- Position and frame
   double            center_x;
   double            center_y;
   bool              frame;

   //--- Label rotation
   bool              rotatelabels;

   //--- Normalization
   bool              normalize;


   //+------------------------------------------------------------------+
   //| Converts the pie chart information to a JSON object.             |
   //+------------------------------------------------------------------+
   JSON::Object* toJSON(void)
     {
      //--- Pie data
      JSON::Array *x_data = new JSON::Array();

      for(ulong i = 0; i < x.Size(); i++)
         x_data.add(x[i]);

      //--- Explode data
      JSON::Array *explode_data = new JSON::Array();

      for(ulong i = 0; i < explode.Size(); i++)
         explode_data.add(explode[i]);

      //--- Labels
      JSON::Array *labels_data = new JSON::Array();

      for(ulong i = 0; i < labels.Size(); i++)
         labels_data.add(labels[i]);

      //--- Colors
      JSON::Array *colors_data = new JSON::Array();

      for(ulong i = 0; i < colors.Size(); i++)
         colors_data.add(colors[i]);

      //--- Hatch patterns
      JSON::Array *hatch_data = new JSON::Array();

      for(ulong i = 0; i < hatch.Size(); i++)
         hatch_data.add(hatch[i]);

      //--- Center
      JSON::Array *center_data = new JSON::Array();

      center_data
      .add(center_x)
      .add(center_y);

      //--- Pie object
      JSON::Object *pie = new JSON::Object();

      pie
      .setProperty("type",          "pie")
      .setProperty("x",             x_data)
      .setProperty("explode",       explode_data)
      .setProperty("labels",        labels_data)
      .setProperty("colors",        colors_data)
      .setProperty("autopct",       autopct)
      .setProperty("pctdistance",   pctdistance)
      .setProperty("shadow",        shadow)
      .setProperty("labeldistance", labeldistance)
      .setProperty("startangle",    startangle)
      .setProperty("radius",        radius)
      .setProperty("counterclock",  counterclock)
      .setProperty("wedgeprops",    wedgeprops)
      .setProperty("textprops",     textprops)
      .setProperty("center",        center_data)
      .setProperty("frame",         frame)
      .setProperty("rotatelabels",  rotatelabels)
      .setProperty("normalize",     normalize)
      .setProperty("hatch",         hatch_data);

      return pie;
     }
  };
//+------------------------------------------------------------------+
//| A class containing information about a hexbin plot.              |
//+------------------------------------------------------------------+
class CHexbin
  {
public:

   //--- Data
   vector            x;
   vector            y;
   vector            C;

   //--- Hexbin configuration
   int               gridsize;
   string            bins;

   //--- Axis scaling
   string            xscale;
   string            yscale;

   //--- Data range
   vector            extent;

   //--- Color mapping
   string            cmap;
   string            norm;

   double            vmin;
   double            vmax;

   //--- Appearance
   double            alpha;
   double            linewidths;
   string            edgecolors;

   //--- C reduction
   string            reduce_C_function;

   //--- Minimum number of points
   int               mincnt;

   //--- Marginal distributions
   bool              marginals;

   //--- Colorizer
   string            colorizer;

   //+------------------------------------------------------------------+
   //| Converts the hexbin plot information to a JSON object.           |
   //+------------------------------------------------------------------+
   JSON::Object* toJSON(void)
     {
      //--- X data
      JSON::Array *x_data = new JSON::Array();

      for(ulong i = 0; i < x.Size(); i++)
         x_data.add(x[i]);

      //--- Y data
      JSON::Array *y_data = new JSON::Array();

      for(ulong i = 0; i < y.Size(); i++)
         y_data.add(y[i]);

      //--- C data
      JSON::Array *c_data = new JSON::Array();

      for(ulong i = 0; i < C.Size(); i++)
         c_data.add(C[i]);

      //--- Extent
      JSON::Array *extent_data = new JSON::Array();

      for(ulong i = 0; i < extent.Size(); i++)
         extent_data.add(extent[i]);

      //--- Hexbin object
      JSON::Object *hexbin = new JSON::Object();

      hexbin
      .setProperty("type",                "hexbin")
      .setProperty("x",                   x_data)
      .setProperty("y",                   y_data)
      .setProperty("C",                   c_data)
      .setProperty("gridsize",            gridsize)
      .setProperty("bins",                bins)
      .setProperty("xscale",              xscale)
      .setProperty("yscale",              yscale)
      .setProperty("extent",              extent_data)
      .setProperty("cmap",                cmap)
      .setProperty("norm",                norm)
      .setProperty("vmin",                vmin)
      .setProperty("vmax",                vmax)
      .setProperty("alpha",               alpha)
      .setProperty("linewidths",          linewidths)
      .setProperty("edgecolors",          edgecolors)
      .setProperty("reduce_C_function",   reduce_C_function)
      .setProperty("mincnt",              mincnt)
      .setProperty("marginals",           marginals)
      .setProperty("colorizer",           colorizer);

      return hexbin;
     }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+


