#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
/usr/bin/time -p pwd
/usr/bin/time -p test -f index.html
PORT="${PORT:-3000}"
/usr/bin/time -p test -n "$PORT"
/usr/bin/time -p mkdir -p dist
if /usr/bin/time -p test -f package.json; then
  /usr/bin/time -p npm install --no-audit --no-fund
  if /usr/bin/time -p node -e "const p=require('./package.json');process.exit(p.scripts&&p.scripts.build?0:1)"; then
    /usr/bin/time -p npm run build
  fi
fi
if /usr/bin/time -p test -f index.html; then
  /usr/bin/time -p cp -f index.html dist/index.html
fi
/usr/bin/time -p test -f dist/index.html
PROJECT_ROOT="$(pwd)"
DIST_DIR="$PROJECT_ROOT/dist"
/usr/bin/time -p node -e "const fs=require('fs');const path=require('path');const dir=process.env.OPENCODE_WEB_DIR||'/tmp';fs.mkdirSync(dir,{recursive:true});fs.writeFileSync(path.join(dir,'deployment-output.json'),JSON.stringify({project:process.cwd(),directory:process.cwd()+'/dist'}))"
/usr/bin/time -p node -e "console.log('serving '+process.cwd()+'/dist on port '+(process.env.PORT||3000))"
/usr/bin/time -p node scripts/serve.mjs
