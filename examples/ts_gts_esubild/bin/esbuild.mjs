#!/usr/bin/env node

import esbuild from 'esbuild';

const build = esbuild.build({
  entryPoints: ["src/index.ts"],
  outdir: "dist",
  bundle: true,
  loader: {".ts": "ts"}
});

await build;
