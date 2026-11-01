"""Copy the Flutter web build into the artifact publish folder and print the
Artifact `files` map as JSON.

Usage: python3 tools/prep_preview.py <web-preview checkout> <publish folder> > files.json

Keeps the publish folder's own index.html and shots/. Skips file types
artifacts do not serve (debug symbols, the binary asset manifest). Shader
.frag files are JSON on web, so they go up as text/plain.
"""
import json
import os
import shutil
import sys

src, dst = sys.argv[1], sys.argv[2]

KEEP = {'index.html', 'shots'}
SKIP_EXT = {'.symbols', '.bin', '.map'}
SKIP_NAMES = {'index.html', '.last_build_id', '.nojekyll', '.gitkeep', 'flutter_service_worker.js', 'version.json'}
SKIP_DIRS = {'.git', 'skwasm', 'wimp'}
TYPES = {
    '.wasm': 'application/wasm', '.js': 'text/javascript', '.json': 'application/json',
    '.png': 'image/png', '.otf': 'font/otf', '.ttf': 'font/ttf', '.ico': 'image/x-icon', '.css': 'text/css',
}

os.makedirs(dst, exist_ok=True)
for name in os.listdir(dst):
    if name not in KEEP:
        p = os.path.join(dst, name)
        shutil.rmtree(p) if os.path.isdir(p) else os.remove(p)

files = {}
for root, dirs, names in os.walk(src):
    dirs[:] = [d for d in dirs if d not in SKIP_DIRS]
    for n in names:
        ext = os.path.splitext(n)[1]
        # Only the CanvasKit renderer is used; skip the unused skwasm/wimp engines.
        if n in SKIP_NAMES or ext in SKIP_EXT or n.startswith(('skwasm', 'wimp')):
            continue
        rel = os.path.relpath(os.path.join(root, n), src)
        if rel.startswith(('canvaskit/webparagraph', 'icons/')) or rel == 'manifest.json':
            continue
        out = os.path.join(dst, rel)
        os.makedirs(os.path.dirname(out), exist_ok=True)
        shutil.copy2(os.path.join(root, n), out)
        files[rel] = {'from': rel, 'contentType': TYPES.get(ext, 'text/plain')}

# Artifact pages cannot register service workers: start Flutter without one.
boot = os.path.join(dst, 'flutter_bootstrap.js')
if os.path.exists(boot):
    with open(boot) as f:
        js = f.read()
    i = js.rfind('_flutter.loader.load(')
    if i != -1:
        with open(boot, 'w') as f:
            f.write(js[:i] + '_flutter.loader.load({});\n')

# Screenshots used by the page's fallback view.
shots = os.path.join(dst, 'shots')
if os.path.isdir(shots):
    for n in sorted(os.listdir(shots)):
        files[f'shots/{n}'] = {'from': f'shots/{n}', 'contentType': 'image/png'}

total = sum(os.path.getsize(os.path.join(dst, f)) for f in files)
print(f'{len(files)} files, {total / 1e6:.1f} MB', file=sys.stderr)
print(json.dumps(files))
