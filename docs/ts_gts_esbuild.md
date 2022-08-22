# Typescript project with gts and esbuild

## Abstract

When starting a new typescript project you need to configure lots of things

- npm project settings
- typescript transpiler settings
- folder structure
- style checker and formatter
- bundler

To minize the effort [gts][gts] is a nice tool to help you setting up the project.
Our of deployment/devliver purposes we also want to bundle the code to create nice and small artifacts.
For those purposes we use [esbuild][esbuild].
The whole example can be found [here][example]

## Prerequisites

For starting this tutorial you need to have [nodejs][nodejs] and [npm][npm] (also [npx][npx]) installed on your machine.
Some basic knowledge about **nodejs**, **npm** and **npx** is helpful.

## Create the project

Please keep in mind that some of the outputs can vary on your system related to the used versions.

So lets start some actions.
First we want to create the npm project.
Therefore please `cd` into a nice directory of your choice.

Now lets create the project directory and the **npm** typescript project with the help of **gts**.

**Remark** We add the `-y` flag to accept the default settings. If you want to adjust those, just do not add the flag.

```bash
mkdir ts_gts_esbuild
cd ts_gts_esbuild
npx gts init -y
```

## Analyse

Now lets see what we got.

```bash
$ tree -a -L 1
.
├── .eslintignore
├── .eslintrc.json
├── node_modules
├── package.json
├── package-lock.json
├── .prettierrc.js
├── src
└── tsconfig.json

2 directories, 6 files

```

Because we do not want to add build artifacts and dependent libs to our git database we add them to **.gitignore**

**Remark** The build/ folder is  used per default for the typescript build artefacts.

```bash
echo node_modules/ >> .gitignore
echo build/ >> .gitignore
```

We can see that we received some default settings

- npm project settings
- typescript transpiler settings
- folder structure
- style checker and formatter

### NPM project settings

```bash
$ cat package.json
{
  "name": "",
  "version": "0.0.0",
  "description": "",
  "main": "build/src/index.js",
  "types": "build/src/index.d.ts",
  "files": [
    "build/src"
  ],
  "license": "Apache-2.0",
  "keywords": [],
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1",
    "lint": "gts lint",
    "clean": "gts clean",
    "compile": "tsc",
    "fix": "gts fix",
    "prepare": "npm run compile",
    "pretest": "npm run compile",
    "posttest": "npm run lint"
  },
  "devDependencies": {
    "gts": "^3.1.0",
    "typescript": "^4.0.3",
    "@types/node": "^14.11.2"
  }
}
```

As you can see some devDependencies have been installed. Also we got some preparations for delivering a npm package.
Furthermore we got some npm scripts.

### Typescript transpiler settings

```bash
npm run compile
```

This will compile the typescript sources defined in **tsconfig.json** file and put the built aretefacts into the outDir folder defined in **tsconfig.json**.

```bash
npm run clean
```

This will cleanup the typescript build artefacts (delete the outDir directory defined in **tsconfig.json**).

### Style checker and formatter

```bash
npm run lint
```

This will run the style checker [eslint][eslint].

```bash
npm run fix
```

This will fix some of the found lint issues.

## bundler

Because we also want to bundle our project we first install esbuild as dev dependency

```bash
npm i -D esbuild
```

Lets test it.

```bash
npx esbuild src/index.ts
```

The output is the bundled file.

You can pass lots of options to the cli interface.
*However, using the command-line interface can become unwieldy if you need to pass many options to esbuild. For more sophisticated uses you will likely want to write a build script in JavaScript using esbuild's JavaScript API.*

We will do that now.
Lets create a small nodejs binary.

```bash
mkdir bin
touch bin/esbuild.mjs
```

now please copy the following content to the file

```mjs
#!/usr/bin/env node

import esbuild from 'esbuild';

const build = esbuild.build({
  entryPoints: ["src/index.ts"],
  outdir: "dist",
  bundle: true,
  loader: {".ts": "ts"}
});

await build;
```

as you can see we will have the outdir **dist** set. We also need to add this to our **.gitignore** file.

```bash
echo dist/ >> .gitignore
```

Now lets test it

```bash
node bin/esbuild.mjs
```

As you can see the bundled package is built.

Now we can add a new npm script. Please add a new script within the script part in **package.json**. Because in addition we want to create the types we also add `npx tsc --emitDeclarationOnly --outDir dist/types`

```json
...
"scripts": {
  ...
  "posttest": "npm run lint",
  "bundle": "npx tsc --emitDeclarationOnly --outDir dist/types && node bin/esbuild.mjs"
},
...
```

### [option] Package

Now we have the option to create a nice small npm package.
Therefore we need to add a `.npmignore` file and add some content.

```bash
touch .npmignore
echo node_modules/ >> .npmignore
echo build/ >> .npmignore
echo bin/ >> .npmignore
echo src/ >> .npmignore
```

Also we need to adjust some paths within our **package.json**

```json
"name": "ts-gts-esbuild",
"version": "0.1.0",
"description": "",
"main": "dist/index.js",
"types": "dist/src/index.d.ts",
...
```

We can test it now

```bash
npm package
```

This will create a tar archive in your package folder.
You can check it.

### Cons

There are lots of pros related to this project setup. But of course there are also some cons.
One of them is that gts is out of the box not properly working with [npm workspaces][npm-workspaces] yet [gts issue][gts-issue].
But you just need to do the gts init within the repos and adjust some path parameters in some files.

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/A0A4EKB66)

[gts]: https://github.com/google/gts
[gts-issue]: https://github.com/google/gts/issues/718
[npm-workspaces]: https://docs.npmjs.com/cli/v8/using-npm/workspaces
[esbuild]: https://github.com/evanw/esbuild
[nodejs]: https://nodejs.org/en/
[npm]: https://docs.npmjs.com/about-npm
[npx]: https://www.npmjs.com/package/npx
[eslint]: https://github.com/eslint/eslint
[example]: https://github.com/AndreasAugustin/teaching/tree/main/examples/ts_gts_esbuild
