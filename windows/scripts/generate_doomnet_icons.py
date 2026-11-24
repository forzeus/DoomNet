"""Generate Windows-only ICO resources from the committed HD DoomNet artwork."""
from pathlib import Path
from PIL import Image, ImageDraw, ImageOps

root = Path(__file__).resolve().parents[2]
assets = root / "assets" / "images"
source = Image.open(assets / "doomnet_orbit_hd.png").convert("RGBA")
sizes = [(n, n) for n in (16, 24, 32, 48, 64, 128, 256)]

def icon(dot=None):
    canvas = Image.new("RGBA", (256, 256), (0, 0, 0, 0))
    draw = ImageDraw.Draw(canvas)
    draw.rounded_rectangle((5, 5, 250, 250), radius=45, fill=(5, 32, 19, 255))
    art = ImageOps.contain(source, (216, 216), Image.Resampling.LANCZOS)
    canvas.alpha_composite(art, ((256-art.width)//2, (256-art.height)//2))
    if dot:
        draw = ImageDraw.Draw(canvas)
        draw.ellipse((179, 179, 248, 248), fill=(4, 20, 13, 255))
        draw.ellipse((188, 188, 239, 239), fill=dot)
    return canvas

def save(path, dot=None):
    icon(dot).save(path, format="ICO", sizes=sizes)
    with Image.open(path) as result:
        assert result.format == "ICO" and (256, 256) in result.ico.sizes()
    print(path.relative_to(root))

save(root / "windows/runner/resources/app_icon.ico")
save(assets / "tray_icon.ico")
save(assets / "tray_icon_dark.ico")
save(assets / "tray_icon_connected.ico", (74, 245, 146, 255))
save(assets / "tray_icon_disconnected.ico", (248, 94, 94, 255))
