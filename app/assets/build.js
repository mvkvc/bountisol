const esbuild = require("esbuild");
const {
  nodeModulesPolyfillPlugin,
} = require("esbuild-plugins-node-modules-polyfill");

const args = process.argv.slice(2);
const watch = args.includes("--watch");
const deploy = args.includes("--deploy");

const loader = {
  // Add loaders for images/fonts/etc, e.g. { '.svg': 'file' }
};

const plugins = [
  nodeModulesPolyfillPlugin({
    globals: {
      process: true,
      Buffer: true,
    },
  }),
];

// Define esbuild options
let opts = {
  entryPoints: ["out/js/app.js"],
  bundle: true,
  logLevel: "info",
  target: "es2020",
  outdir: "../priv/static/assets",
  external: ["*.css", "fonts/*", "images/*"],
  loader: loader,
  plugins: plugins,
};

if (deploy) {
  opts = {
    ...opts,
    minify: true,
  };
}

if (watch) {
  opts = {
    ...opts,
    sourcemap: "inline",
  };
  esbuild
    .context(opts)
    .then((ctx) => {
      ctx.watch();
    })
    .catch((_error) => {
      process.exit(1);
    });
} else {
  esbuild.build(opts);
}
