import numpy as np
import io
from PIL import Image

def figure_to_bmp(fig):
    """Converts a Matplotlib figure to BMP format.
    
    Parameters:
        fig (matplotlib.figure.Figure): The Matplotlib figure to convert.
    
    Returns:
        bytes: The BMP image data.
    """

    # First render the Matplotlib figure as PNG
    png_buffer = io.BytesIO()

    fig.savefig(
        png_buffer,
        format="png",
        bbox_inches="tight"
    )

    png_buffer.seek(0)

    # Open PNG with Pillow
    image = Image.open(png_buffer)

    # BMP does not support RGBA in the same way, so convert it
    image = image.convert("RGB")

    # Convert to BMP
    bmp_buffer = io.BytesIO()

    image.save(
        bmp_buffer,
        format="BMP"
    )

    return bmp_buffer.getvalue()

def is_default_limit(limit):
    return (
        limit is None
        or len(limit) != 2
        or (
            limit[0] == 0.0
            and limit[1] == 1.0
        )
        or np.isinf(limit[0])
        or np.isinf(limit[1])
    )

def create_colorbar(fig, ax, **kwargs):
    """Creates a colorbar for a given axis and mappable object.
    
    Parameters:
        fig (matplotlib.figure.Figure): The Matplotlib figure.
        ax (matplotlib.axes.Axes): The axis to which the colorbar is associated.
        **kwargs:Keyword arguments for the colorbar.
    """
    
    cb = fig.colorbar(ax.collections[0], ax=ax, **kwargs)