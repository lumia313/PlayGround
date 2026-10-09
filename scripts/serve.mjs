import { createServer } from 'node:http';
import { readFileSync, existsSync, statSync } from 'node:fs';
import { resolve, join, extname } from 'node:path';
const root = resolve(process.cwd(), 'dist');
const port = Number(process.env.PORT || 3000);
const mime = { '.html': 'text/html', '.js': 'application/javascript', '.css': 'text/css', '.json': 'application/json', '.svg': 'image/svg+xml', '.png': 'image/png', '.jpg': 'image/jpeg', '.webp': 'image/webp', '.wasm': 'application/wasm', '.glb': 'model/gltf-binary' };
const server = createServer((req, res) => {
  try {
    const url = new URL(req.url, 'http://localhost');
    let path = resolve(root, '.' + decodeURIComponent(url.pathname));
    if (path !== root && !path.startsWith(root + '/')) { res.writeHead(404); res.end(); return; }
    try { if (statSync(path).isDirectory()) path = join(path, 'index.html'); } catch { path = join(root, 'index.html'); }
    if (!existsSync(path)) path = join(root, 'index.html');
    res.setHeader('Content-Type', mime[extname(path)] || 'application/octet-stream');
    res.setHeader('Cache-Control', 'no-cache');
    res.end(readFileSync(path));
  } catch { res.writeHead(404); res.end('Not found'); }
});
server.listen(port, '0.0.0.0', () => console.log(`star-runner-3d serving ${root} on :${port}`));
