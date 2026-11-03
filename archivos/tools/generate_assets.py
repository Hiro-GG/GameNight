"""Genera las portadas ilustradas de GameNight (assets propios)."""
import math
import os
import random
import sys

from PIL import Image, ImageDraw, ImageFilter

OUT = sys.argv[1]
SS = 2  # supersampling para bordes suaves
W, H = 600 * SS, 450 * SS


def hex2rgb(h):
    h = h.lstrip('#')
    return tuple(int(h[i:i + 2], 16) for i in (0, 2, 4))


def gradient(top, bottom, w=W, h=H):
    a, b = hex2rgb(top), hex2rgb(bottom)
    img = Image.new('RGB', (w, h))
    px = img.load()
    for y in range(h):
        for x in range(w):
            t = min(1, max(0, (y / h) * 0.75 + (x / w) * 0.25))
            px[x, y] = tuple(int(a[i] + (b[i] - a[i]) * t) for i in range(3))
    return img.convert('RGBA')


def overlay(base, draw_fn):
    layer = Image.new('RGBA', base.size, (0, 0, 0, 0))
    draw_fn(ImageDraw.Draw(layer), layer)
    return Image.alpha_composite(base, layer)


def shadowed(base, draw_fn, offset=(0, 18), blur=22, alpha=70):
    sh = Image.new('RGBA', base.size, (0, 0, 0, 0))
    draw_fn(ImageDraw.Draw(sh), sh, shadow=True)
    r, g, b, a = sh.split()
    a = a.point(lambda v: min(v, alpha))
    sh = Image.merge('RGBA', (r, g, b, a)).filter(ImageFilter.GaussianBlur(blur * SS / 2))
    moved = Image.new('RGBA', base.size, (0, 0, 0, 0))
    moved.paste(sh, (offset[0] * SS, offset[1] * SS))
    base = Image.alpha_composite(base, moved)
    return overlay(base, lambda d, l: draw_fn(d, l, shadow=False))


def S(v):
    return v * SS


def col(c, shadow, a=255):
    if shadow:
        return (0, 0, 0, 255)
    if isinstance(c, str):
        return hex2rgb(c) + (a,)
    return c


WHITE = (255, 255, 255, 255)
SOFT = (255, 255, 255, 40)


def pattern(base, seed):
    rnd = random.Random(seed)

    def fn(d, _):
        for _ in range(26):
            x, y = rnd.randint(0, W), rnd.randint(0, H)
            r = rnd.randint(S(4), S(14))
            d.ellipse([x - r, y - r, x + r, y + r], fill=(255, 255, 255, rnd.randint(14, 34)))
    return overlay(base, fn)


def hexagon(cx, cy, r):
    return [(cx + r * math.cos(math.radians(60 * i + 30)), cy + r * math.sin(math.radians(60 * i + 30))) for i in range(6)]


def m_hex(accent):
    def fn(d, _, shadow=False):
        r = S(62)
        dx, dy = r * math.sqrt(3), r * 1.5
        cx, cy = W / 2, H / 2 + S(8)
        cells = [(0, 0), (1, 0), (-1, 0), (0.5, -1), (-0.5, -1), (0.5, 1), (-0.5, 1)]
        fills = ['#FFFFFF', accent, '#FFE3A3', '#FFFFFF', '#C8E6A0', accent, '#FFFFFF']
        for (i, j), f in zip(cells, fills):
            d.polygon(hexagon(cx + i * dx, cy + j * dy, r - S(5)), fill=col(f, shadow))
        if not shadow:
            d.ellipse([cx - S(18), cy - S(18), cx + S(18), cy + S(18)], fill=col('#3A2A1A', False))
    return fn


def rounded(d, box, r, fill):
    d.rounded_rectangle(box, radius=r, fill=fill)


def card_img(w, h, angle, fill, mark, mark_col):
    img = Image.new('RGBA', (w + S(40), h + S(40)), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    rounded(d, [S(20), S(20), S(20) + w, S(20) + h], S(18), fill)
    if mark_col is not None:
        cx, cy = S(20) + w / 2, S(20) + h / 2
        if mark == 'oval':
            d.ellipse([cx - w * 0.32, cy - h * 0.3, cx + w * 0.32, cy + h * 0.3], fill=mark_col)
        elif mark == 'heart':
            heart(d, cx, cy, w * 0.26, mark_col)
        elif mark == 'star':
            star(d, cx, cy, w * 0.28, mark_col)
    return img.rotate(angle, resample=Image.BICUBIC, expand=True)


def m_cards(colors, mark='oval'):
    def fn(d, layer, shadow=False):
        w, h = S(150), S(220)
        for k, (ang, c) in enumerate(zip([24, 8, -8, -24], colors)):
            fill = (0, 0, 0, 255) if shadow else hex2rgb(c) + (255,)
            mc = None if shadow else (255, 255, 255, 235)
            img = card_img(w, h, ang, fill, mark, mc)
            x = int(W / 2 - img.width / 2 + (k - 1.5) * S(58))
            y = int(H / 2 - img.height / 2 + abs(k - 1.5) * S(10))
            layer.alpha_composite(img, (x, y))
            if not shadow:
                bord = ImageDraw.Draw(layer)
    return fn


def heart(d, cx, cy, r, fill):
    d.ellipse([cx - r, cy - r * 0.9, cx, cy + r * 0.1], fill=fill)
    d.ellipse([cx, cy - r * 0.9, cx + r, cy + r * 0.1], fill=fill)
    d.polygon([(cx - r * 0.97, cy - r * 0.25), (cx + r * 0.97, cy - r * 0.25), (cx, cy + r * 1.05)], fill=fill)


def star(d, cx, cy, r, fill, points=5):
    pts = []
    for i in range(points * 2):
        rr = r if i % 2 == 0 else r * 0.45
        a = math.radians(-90 + i * 180 / points)
        pts.append((cx + rr * math.cos(a), cy + rr * math.sin(a)))
    d.polygon(pts, fill=fill)


def m_bubbles(accent):
    def fn(d, _, shadow=False):
        cx, cy = W / 2, H / 2
        b = [(cx - S(150), cy - S(110), cx + S(40), cy + S(10), '#FFFFFF'),
             (cx - S(20), cy - S(20), cx + S(160), cy + S(90), accent)]
        for x0, y0, x1, y1, c in b:
            d.rounded_rectangle([x0, y0, x1, y1], radius=S(50), fill=col(c, shadow))
        d.polygon([(cx - S(110), cy), (cx - S(70), cy + S(5), ), (cx - S(120), cy + S(50))], fill=col('#FFFFFF', shadow))
        d.polygon([(cx + S(110), cy + S(80)), (cx + S(70), cy + S(85)), (cx + S(130), cy + S(130))], fill=col(accent, shadow))
        if not shadow:
            for i in range(3):
                x = cx - S(95) + i * S(40)
                d.ellipse([x - S(11), cy - S(61), x + S(11), cy - S(39)], fill=col('#4B3BA8', False))
            star(d, cx + S(70), cy + S(35), S(30), col('#FFFFFF', False))
    return fn


def m_tower(colors):
    def fn(d, _, shadow=False):
        bw, bh = S(52), S(26)
        cx, base = W / 2, H / 2 + S(150)
        for row in range(9):
            y = base - row * (bh + S(4))
            missing = {2: 1, 4: 0, 6: 2, 8: 1}.get(row)
            for k in range(3):
                if k == missing:
                    continue
                c = colors[(row + k) % len(colors)]
                if row % 2 == 0:
                    x = cx - bw * 1.5 + k * bw
                    d.rounded_rectangle([x + S(2), y - bh, x + bw - S(2), y], radius=S(6), fill=col(c, shadow))
                else:
                    d.rounded_rectangle([cx - bw * 1.5 + S(2), y - bh, cx + bw * 1.5 - S(2), y], radius=S(6), fill=col(c, shadow)) if k == 0 else None
    return fn


def m_network(accent):
    def fn(d, _, shadow=False):
        rnd = random.Random(7)
        cx, cy = W / 2, H / 2
        nodes = [(cx + math.cos(a) * S(160) * rnd.uniform(0.6, 1), cy + math.sin(a) * S(120) * rnd.uniform(0.6, 1))
                 for a in [i * math.pi * 2 / 7 for i in range(7)]] + [(cx, cy)]
        if not shadow:
            for i, n in enumerate(nodes[:-1]):
                for m in (nodes[(i + 1) % 7], nodes[-1]):
                    d.line([n, m], fill=(255, 255, 255, 170), width=S(5))
        for i, (x, y) in enumerate(nodes):
            r = S(30) if i == 7 else S(20)
            c = accent if i in (2, 5, 7) else '#FFFFFF'
            d.ellipse([x - r, y - r, x + r, y + r], fill=col(c, shadow))
        if not shadow:
            x, y = nodes[-1]
            d.rectangle([x - S(5), y - S(16), x + S(5), y + S(16)], fill=WHITE)
            d.rectangle([x - S(16), y - S(5), x + S(16), y + S(5)], fill=WHITE)
    return fn


def m_grid(colors, n=5, cell=S(52)):
    def fn(d, _, shadow=False):
        rnd = random.Random(n)
        total = n * cell + (n - 1) * S(8)
        x0, y0 = W / 2 - total / 2, H / 2 - total / 2
        for i in range(n):
            for j in range(n):
                c = rnd.choice(colors)
                x, y = x0 + i * (cell + S(8)), y0 + j * (cell + S(8))
                d.rounded_rectangle([x, y, x + cell, y + cell], radius=S(9), fill=col(c, shadow))
    return fn


def m_train(accent):
    def fn(d, _, shadow=False):
        pts = [(S(70), S(330)), (S(200), S(250)), (S(330), S(300)), (S(450), S(170)), (S(540), S(110))]
        pts = [(x * W / S(600), y * H / S(450)) for x, y in pts]
        if not shadow:
            d.line(pts, fill=(255, 255, 255, 90), width=S(30), joint='curve')
        for (x0, y0), (x1, y1) in zip(pts, pts[1:]):
            for t in (0.18, 0.5, 0.82):
                x, y = x0 + (x1 - x0) * t, y0 + (y1 - y0) * t
                ang = math.atan2(y1 - y0, x1 - x0)
                hw, hh = S(26), S(11)
                corners = [(-hw, -hh), (hw, -hh), (hw, hh), (-hw, hh)]
                poly = [(x + cx_ * math.cos(ang) - cy_ * math.sin(ang), y + cx_ * math.sin(ang) + cy_ * math.cos(ang)) for cx_, cy_ in corners]
                d.polygon(poly, fill=col(accent, shadow))
        for x, y in (pts[0], pts[2], pts[-1]):
            d.ellipse([x - S(26), y - S(26), x + S(26), y + S(26)], fill=col('#FFFFFF', shadow))
    return fn


def m_mosaic(colors):
    def fn(d, _, shadow=False):
        cell = S(56)
        x0, y0 = W / 2 - 2.5 * cell - S(16), H / 2 - 2.5 * cell - S(16)
        for i in range(5):
            for j in range(5):
                if (i + j) % 4 == 3 and not (i == 2 and j == 2):
                    continue
                c = colors[(i * 2 + j) % len(colors)]
                x, y = x0 + i * (cell + S(8)), y0 + j * (cell + S(8))
                d.rounded_rectangle([x, y, x + cell, y + cell], radius=S(8), fill=col(c, shadow))
                if not shadow:
                    d.rounded_rectangle([x + S(12), y + S(12), x + cell - S(12), y + cell - S(12)], radius=S(5), fill=(255, 255, 255, 60))
    return fn


def m_bomb(accent):
    def fn(d, _, shadow=False):
        cx, cy, r = W / 2 - S(20), H / 2 + S(30), S(110)
        d.ellipse([cx - r, cy - r, cx + r, cy + r], fill=col('#1B1B1F' if not shadow else '#000', shadow))
        d.rounded_rectangle([cx + S(40), cy - r - S(10), cx + S(100), cy - r + S(40)], radius=S(8), fill=col('#3A3A42', shadow))
        if not shadow:
            d.ellipse([cx - S(60), cy - S(70), cx - S(20), cy - S(30)], fill=(255, 255, 255, 70))
            d.line([(cx + S(80), cy - r - S(5)), (cx + S(120), cy - r - S(50)), (cx + S(160), cy - r - S(40))], fill=WHITE, width=S(7), joint='curve')
            star(d, cx + S(168), cy - r - S(46), S(34), col(accent, False), points=8)
            star(d, cx + S(168), cy - r - S(46), S(16), col('#FFF59D', False), points=8)
            # orejas de gato
            d.polygon([(cx - S(80), cy - S(75)), (cx - S(95), cy - S(150)), (cx - S(30), cy - S(100))], fill=col('#1B1B1F', False))
            d.ellipse([cx - S(50), cy, cx - S(20), cy + S(30)], fill=col(accent, False))
            d.ellipse([cx + S(20), cy, cx + S(50), cy + S(30)], fill=col(accent, False))
    return fn


def m_circles(colors):
    def fn(d, _, shadow=False):
        cx, cy, r = W / 2, H / 2, S(160)
        d.ellipse([cx - r, cy - r, cx + r, cy + r], fill=col('#FFFFFF', shadow))
        if not shadow:
            rnd = random.Random(3)
            spots = [(0, 0, 38), (-85, -60, 28), (80, -70, 30), (-95, 50, 26), (90, 60, 32), (0, -115, 22), (5, 110, 24), (-30, 55, 16), (40, -10, 18)]
            for i, (dx, dy, rr) in enumerate(spots):
                c = colors[i % len(colors)]
                x, y = cx + S(dx), cy + S(dy)
                if i % 3 == 0:
                    star(d, x, y, S(rr), col(c, False))
                elif i % 3 == 1:
                    d.ellipse([x - S(rr), y - S(rr), x + S(rr), y + S(rr)], fill=col(c, False))
                else:
                    heart(d, x, y + S(rr) * 0.2, S(rr), col(c, False))
    return fn


def m_letter(accent):
    def fn(d, _, shadow=False):
        cx, cy = W / 2, H / 2 + S(10)
        w, h = S(300), S(200)
        d.rounded_rectangle([cx - w / 2, cy - h / 2, cx + w / 2, cy + h / 2], radius=S(16), fill=col('#FFF8F0', shadow))
        if not shadow:
            d.polygon([(cx - w / 2 + S(6), cy - h / 2 + S(6)), (cx + w / 2 - S(6), cy - h / 2 + S(6)), (cx, cy + S(20))], fill=col('#F3E1D2', False))
            d.ellipse([cx - S(34), cy - S(14), cx + S(34), cy + S(54)], fill=col(accent, False))
            heart(d, cx, cy + S(20), S(18), WHITE)
    return fn


def m_planet(accent):
    def fn(d, _, shadow=False):
        cx, cy, r = W / 2, H / 2, S(120)
        if not shadow:
            d.ellipse([cx - S(230), cy - S(45), cx + S(230), cy + S(45)], outline=(255, 255, 255, 120), width=S(10))
        d.ellipse([cx - r, cy - r, cx + r, cy + r], fill=col(accent, shadow))
        if not shadow:
            for dx, dy, rr in [(-40, -30, 28), (35, 40, 20), (50, -55, 14), (-55, 55, 12)]:
                d.ellipse([cx + S(dx) - S(rr), cy + S(dy) - S(rr), cx + S(dx) + S(rr), cy + S(dy) + S(rr)], fill=(0, 0, 0, 45))
            d.ellipse([cx - S(70), cy - S(100), cx + S(10), cy - S(70)], fill=(255, 255, 255, 60))
            d.chord([cx - S(230), cy - S(45), cx + S(230), cy + S(45)], 0, 180, outline=(255, 255, 255, 170), width=S(10))
    return fn


def m_space(accent):
    def fn(d, _, shadow=False):
        cx, cy = W / 2, H / 2
        if not shadow:
            rnd = random.Random(11)
            for _ in range(40):
                x, y, r = rnd.randint(0, W), rnd.randint(0, H), rnd.randint(S(2), S(5))
                d.ellipse([x - r, y - r, x + r, y + r], fill=(255, 255, 255, rnd.randint(120, 230)))
        # cohete
        body = [(cx, cy - S(150)), (cx + S(55), cy - S(40)), (cx + S(55), cy + S(80)), (cx - S(55), cy + S(80)), (cx - S(55), cy - S(40))]
        d.polygon(body, fill=col('#FFFFFF', shadow))
        d.polygon([(cx - S(55), cy + S(10)), (cx - S(105), cy + S(100)), (cx - S(55), cy + S(80))], fill=col(accent, shadow))
        d.polygon([(cx + S(55), cy + S(10)), (cx + S(105), cy + S(100)), (cx + S(55), cy + S(80))], fill=col(accent, shadow))
        if not shadow:
            d.ellipse([cx - S(24), cy - S(50), cx + S(24), cy - S(2)], fill=col('#1A237E', False))
            d.polygon([(cx - S(30), cy + S(85)), (cx + S(30), cy + S(85)), (cx, cy + S(150))], fill=col('#FFB547', False))
    return fn


def m_meeples(colors):
    def meeple(d, cx, cy, s, fill):
        d.ellipse([cx - s * 0.32, cy - s * 1.05, cx + s * 0.32, cy - s * 0.41], fill=fill)
        d.polygon([(cx - s * 0.22, cy - s * 0.5), (cx + s * 0.22, cy - s * 0.5), (cx + s * 0.95, cy - s * 0.25),
                   (cx + s * 0.9, cy), (cx + s * 0.35, cy - s * 0.05), (cx + s * 0.62, cy + s * 0.75),
                   (cx + s * 0.12, cy + s * 0.75), (cx, cy + s * 0.4), (cx - s * 0.12, cy + s * 0.75),
                   (cx - s * 0.62, cy + s * 0.75), (cx - s * 0.35, cy - s * 0.05), (cx - s * 0.9, cy),
                   (cx - s * 0.95, cy - s * 0.25)], fill=fill)
        d.ellipse([cx - s * 0.98, cy - s * 0.3, cx - s * 0.82, cy + s * 0.02], fill=fill)
        d.ellipse([cx + s * 0.82, cy - s * 0.3, cx + s * 0.98, cy + s * 0.02], fill=fill)

    def fn(d, _, shadow=False):
        spots = [(-150, 40, 95), (0, 10, 130), (150, 40, 95)]
        for (dx, dy, s), c in zip(spots, colors):
            meeple(d, W / 2 + S(dx), H / 2 + S(dy), S(s), col(c, shadow))
    return fn


def m_lines(accent):
    def fn(d, _, shadow=False):
        cx, cy = W / 2, H / 2
        w, h = S(300), S(240)
        d.rounded_rectangle([cx - w / 2, cy - h / 2, cx + w / 2, cy + h / 2], radius=S(14), fill=col('#FFFFFF', shadow))
        if not shadow:
            for i in range(4):
                y = cy - h / 2 + S(55) + i * S(48)
                d.line([(cx - w / 2 + S(24), y), (cx + w / 2 - S(24), y)], fill=(0, 0, 0, 40), width=S(3))
                d.rounded_rectangle([cx - w / 2 + S(28), y - S(26), cx - w / 2 + S(28) + S(60 + 30 * (i % 3)), y - S(12)], radius=S(6), fill=col(accent, False))
            d.line([(cx - w / 2 + S(100), cy - h / 2 + S(10)), (cx - w / 2 + S(100), cy + h / 2 - S(10))], fill=col('#E57373', False), width=S(4))
            # lápiz
            d.polygon([(cx + S(80), cy + S(120)), (cx + S(200), cy - S(60)), (cx + S(230), cy - S(40)), (cx + S(110), cy + S(140))], fill=col('#FFB547', False))
            d.polygon([(cx + S(80), cy + S(120)), (cx + S(110), cy + S(140)), (cx + S(70), cy + S(160))], fill=col('#3A2A1A', False))
    return fn


def m_dice(accent):
    def fn(d, layer, shadow=False):
        for (dx, dy, ang, pips, c) in [(-90, 10, 14, [1, 3, 5, 7, 9], '#FFFFFF'), (95, -10, -12, [1, 5, 9], accent)]:
            s = S(170)
            img = Image.new('RGBA', (s + S(20), s + S(20)), (0, 0, 0, 0))
            di = ImageDraw.Draw(img)
            di.rounded_rectangle([S(10), S(10), S(10) + s, S(10) + s], radius=S(30), fill=col(c, shadow))
            if not shadow:
                pc = col('#2D2A6E', False) if c == '#FFFFFF' else WHITE
                for p in pips:
                    px = S(10) + s * (0.25 + 0.25 * ((p - 1) % 3))
                    py = S(10) + s * (0.25 + 0.25 * ((p - 1) // 3))
                    di.ellipse([px - S(15), py - S(15), px + S(15), py + S(15)], fill=pc)
            img = img.rotate(ang, resample=Image.BICUBIC, expand=True)
            layer.alpha_composite(img, (int(W / 2 + S(dx) - img.width / 2), int(H / 2 + S(dy) - img.height / 2)))
    return fn


GAMES = [
    ('catan', '#F0954A', '#B5481F', m_hex('#E8833A')),
    ('carcassonne', '#8BC34A', '#33691E', m_meeples(['#FFFFFF', '#FFB547', '#FFFFFF'])),
    ('dixit', '#8C7CF0', '#3B2F9E', m_bubbles('#FFB547')),
    ('uno', '#EF5350', '#B71C1C', m_cards(['#FDD835', '#43A047', '#1E88E5', '#FFFFFF'][::-1])),
    ('jenga', '#E2B26F', '#9C6A2E', m_tower(['#FFF3E0', '#FFE0B2', '#FFCC80'])),
    ('pandemic', '#3E9BD6', '#0D3C78', m_network('#E53935')),
    ('codenames', '#56657A', '#1E2633', m_grid(['#EF5350', '#42A5F5', '#F5E6C8', '#F5E6C8'])),
    ('ticket-to-ride', '#6F8296', '#2C3E50', m_train('#FFB547')),
    ('azul', '#26A6C9', '#0D4F6B', m_mosaic(['#FFFFFF', '#FFB547', '#E53935', '#1A1A1A', '#4FC3F7'])),
    ('exploding-kittens', '#FFC94D', '#F07A24', m_bomb('#E53935')),
    ('dobble', '#FFA040', '#E65100', m_circles(['#E53935', '#1E88E5', '#43A047', '#8E24AA', '#FFB300'])),
    ('loteria', '#26A69A', '#004D40', m_grid(['#FFFFFF', '#FFB547', '#F06292', '#FFFFFF'], n=4, cell=S(64))),
    ('love-letter', '#EC407A', '#880E4F', m_letter('#B71C1C')),
    ('the-crew', '#283593', '#0B0F3F', m_space('#FFB547')),
    ('terraforming-mars', '#B8653A', '#5D2A12', m_planet('#E2703A')),
    ('basta', '#26C6DA', '#00838F', m_lines('#26A69A')),
]


def make_cover(name, top, bottom, motif):
    img = gradient(top, bottom)
    img = pattern(img, name)
    img = shadowed(img, motif)
    img = img.resize((W // SS, H // SS), Image.LANCZOS).convert('RGB')
    img.save(os.path.join(OUT, 'games', f'{name}.png'), optimize=True)


def make_onboarding(name, motif, bg='#ECEBFA'):
    size = 520 * SS
    global W, H
    W0, H0 = W, H
    W, H = size, size * 3 // 4
    img = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    img = overlay(img, lambda d, _: d.ellipse([W / 2 - S(200), H / 2 - S(190), W / 2 + S(200), H / 2 + S(190)], fill=col(bg, False)))
    img = shadowed(img, motif, alpha=45)
    img = img.resize((W // SS, H // SS), Image.LANCZOS)
    img.save(os.path.join(OUT, 'onboarding', f'{name}.png'), optimize=True)
    W, H = W0, H0


if __name__ == '__main__':
    os.makedirs(os.path.join(OUT, 'games'), exist_ok=True)
    os.makedirs(os.path.join(OUT, 'onboarding'), exist_ok=True)
    for g in GAMES:
        make_cover(*g)
        print('ok', g[0])
    make_onboarding('descubre', m_cards(['#2D2A6E', '#FFB547', '#6C63FF', '#FF6B6B'], mark='star'))
    make_onboarding('filtra', m_meeples(['#6C63FF', '#2D2A6E', '#FFB547']))
    make_onboarding('guarda', m_dice('#FF6B6B'))
    print('onboarding ok')
