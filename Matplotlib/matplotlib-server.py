from flask import Flask, request, jsonify, send_file
import numpy as np

import matplotlib
matplotlib.use("Agg")  # Use a non-interactive backend for Flask

import matplotlib.pyplot as plt
import utils

app = Flask(__name__)


@app.route("/set-style", methods=["POST"])
def set_style():
    """Sets the style for the matplotlib plots.

    Returns:
        jsonify: A JSON response indicating success or failure.
    """

    data = request.get_json(silent=True)

    if not data:
        return jsonify({"error": "No JSON data provided"}), 400

    style = data.get("style")

    if style is None:
        return jsonify({"error": "No style specified"}), 400

    try:
        # Reset all rcParams to Matplotlib defaults
        plt.rcdefaults()

        # Apply the requested style
        plt.style.use(style)

    except OSError as e:
        return (
            jsonify({"error": f"Invalid Matplotlib style: {style}", "details": str(e)}),
            400,
        )

    return jsonify({"message": f"Style set to {style}"}), 200


@app.route("/mpl", methods=["POST"])
def mpl():
    """Creates any plot based on the JSON data received in the POST request.

    Returns:
        Optional[None]: A figure object if successful, None if there was an error
    """

    data = request.get_json()

    # print(f"Received plot data: {data}")

    # check if all crucial keys are present in the data
    try:
        figure = data["figure"]  # Figure data
        axes_data = data["axes"]  # Axes information

    except KeyError as e:

        print(f"Missing key in data: {e}")
        return None

    # Figure configurations

    width = figure.get("width", 6.4)
    height = figure.get("height", 4.8)

    rows = int(figure.get("rows", 1))
    cols = int(figure.get("cols", 1))

    sharex = figure.get("sharex", False)
    sharey = figure.get("sharey", False)

    # Create Figure + all Axes

    fig, axes = plt.subplots(
        rows, cols, figsize=(width, height), sharex=sharex, sharey=sharey
    )

    # Normalize axes into a flat list

    if rows == 1 and cols == 1:
        axes = [axes]
    else:
        axes = axes.flatten()

    # Configure each Axes

    for index, axes_data_item in enumerate(axes_data):

        if index >= len(axes):
            break

        ax = axes[index]

        # Axes properties

        title = axes_data_item.get("title")
        xlabel = axes_data_item.get("xlabel")
        ylabel = axes_data_item.get("ylabel")

        if title is not None:
            ax.set_title(title)

        if xlabel is not None:
            ax.set_xlabel(xlabel)

        if ylabel is not None:
            ax.set_ylabel(ylabel)

        # Grid
        if axes_data_item.get("grid", False):
            ax.grid(True)

        # Limits
        xlim = axes_data_item.get("xlim")
        ylim = axes_data_item.get("ylim")

        if xlim is not None:
            if xlim[0] is not None and xlim[1] is not None:
                ax.set_xlim(xlim)
            elif xlim[0] is not None:
                ax.set_xlim(left=xlim[0])
            elif xlim[1] is not None:
                ax.set_xlim(right=xlim[1])

        if ylim is not None:
            if ylim[0] is not None and ylim[1] is not None:
                ax.set_ylim(ylim)
            elif ylim[0] is not None:
                ax.set_ylim(bottom=ylim[0])
            elif ylim[1] is not None:
                ax.set_ylim(top=ylim[1])

        # Plots belonging to this Axes
        plots = axes_data_item.get("plots", [])

        for plot in plots:

            plot_type = plot.get("type")

            if plot_type == "line":  # Line plot

                x = plot.get("x", [])
                y = plot.get("y", [])

                kwargs = {
                    key: value
                    for key, value in plot.items()
                    if (
                        key not in ("type", "x", "y")
                        and value is not None
                        and value != ""
                    )
                }

                ax.plot(x, y, **kwargs)

            elif plot_type == "scatter":  # Scatter

                x = plot.get("x", [])
                y = plot.get("y", [])

                kwargs = {
                    key: value
                    for key, value in plot.items()
                    if (
                        key not in ("type", "x", "y")
                        and value is not None
                        and value != ""
                    )
                }

                ax.scatter(x, y, **kwargs)

            elif plot_type == "bar":  # Bar plot

                x = plot.get("x", [])
                y = plot.get("height", [])

                kwargs = {
                    key: value
                    for key, value in plot.items()
                    if (
                        key not in ("type", "x", "height")
                        and value is not None
                        and value != ""
                        and value != []
                    )
                }

                ax.bar(x, y, **kwargs)

            elif plot_type == "barh":  # Horizontal bar plot

                y = plot.get("y", [])
                width = plot.get("width", [])

                kwargs = {
                    key: value
                    for key, value in plot.items()
                    if (
                        key not in ("type", "y", "width")
                        and value is not None
                        and value != ""
                        and value != []
                    )
                }

                ax.barh(y, width, **kwargs)

            elif plot_type == "hist":  # Histogram

                x = plot.get("x", [])
                bins = plot.get("bins", 10)

                if isinstance(bins, (int, float)): #Ensure bins is an integer
                    bins = int(bins)

                kwargs = {
                    key: value
                    for key, value in plot.items()
                    if (
                        key not in ("type", "x", "bins")
                        and value is not None
                        and value != ""
                        and value != []
                    )
                }

                ax.hist(x, bins=bins, **kwargs)

            elif plot_type == "pie": # Pie chart
                x = plot.get("x", [])

                kwargs = {
                    key: value
                    for key, value in plot.items()
                    if (
                        key not in ("type", "x")
                        and value is not None
                        and value != ""
                        and value != []
                    )
                }

                ax.pie(x, **kwargs)

            elif plot_type == "hexbin": # Hexbin plot

                x = plot.get("x", [])
                y = plot.get("y", [])
                gridsize = plot.get("gridsize", 10)

                if isinstance(gridsize, (int, float)): #Ensure gridsize is an integer
                    gridsize = int(gridsize)

                kwargs = {
                    key: value
                    for key, value in plot.items()
                    if (
                        key not in ("type", "x", "y", "gridsize")
                        and value is not None
                        and value != ""
                        and value != []
                    )
                }

                ax.hexbin(x, y, gridsize=gridsize, **kwargs)

            # Unknown plot
            else:
                print(f"Unsupported plot type: {plot_type}")

            legend_info = axes_data_item.get("legend")

            if legend_info is not None:
                if legend_info.get("enabled", False):
                    ax.legend(loc=legend_info.get("loc", "upper left"))

        # colorbar for each axes if specified
        colorbar_info = axes_data_item.get("colorbar", None)
        if colorbar_info is None:
            continue

        kwargs = {
            key: value
            for key, value in colorbar_info.items()
            if (
                value is not None
                and value != ""
            )
        }

        fig.colorbar(ax.collections[-1], ax=ax, **kwargs)
        
    # figure properties

    color = figure.get("color")

    if color is not None:
        fig.set_facecolor(color)

    suptitle = figure.get("suptitle")

    if suptitle is not None:
        fig.suptitle(suptitle)

    if figure.get("tight_layout", False):
        fig.tight_layout()

    # convert the figure to BMP
    bmp = utils.figure_to_bmp(fig)

    return bmp, 200, {"Content-Type": "image/bmp"}


if __name__ == "__main__":

    print("Starting MQL5 Plot Server...")
    print("Listening on http://127.0.0.1:5000")

    app.run(host="127.0.0.1", port=5000, debug=True, use_reloader=False)
