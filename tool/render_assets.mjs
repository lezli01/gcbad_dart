// Renders the gcbad_dart brand PNGs from the committed SVG sources.
//
// The SVGs under .github/assets are the source of truth; this script
// rasterizes them to PNG at their native dimensions so the outputs stay
// reproducible. pub.dev renders PNG (not SVG) in package READMEs, so the
// README references the generated PNG rather than the SVG source.
//
// Usage:
//   cd tool && npm install && npm run render

import { Resvg } from '@resvg/resvg-js';
import { readFileSync, writeFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { dirname, join } from 'node:path';

const assetsDir = join(dirname(fileURLToPath(import.meta.url)), '..', '.github', 'assets');

const targets = [
  { svg: 'gcbad-mark.svg', png: 'gcbad-mark.png' },
];

for (const { svg, png } of targets) {
  const source = readFileSync(join(assetsDir, svg));
  const resvg = new Resvg(source, {
    fitTo: { mode: 'original' },
    font: { loadSystemFonts: true },
    background: 'rgba(0,0,0,0)',
  });
  const rendered = resvg.render();
  const buffer = rendered.asPng();
  writeFileSync(join(assetsDir, png), buffer);
  console.log(`rendered ${svg} -> ${png}  (${rendered.width}x${rendered.height}, ${buffer.length} bytes)`);
}
