# Getting Started

## Prerequisites

You must have [Node.js](https://nodejs.org) or another **JavaScript** runtime installed on your computer.
To check your Node.js version, run:

```sh
node -v
```

::: warning

**Express version 5** requires Node.js version 18 or higher. Please update Node.js if your version is lower.

:::

---

## Create the `package.json` File

Navigate to your project folder and initialize a `package.json` file using one of the following commands:

::: code-group

```sh [npm]
npm init
```

```sh [pnpm]
pnpm init
```

```sh [yarn]
yarn init
```

```sh [bun]
bun init
```

```sh [deno]
deno init
```

:::

---

## Install Dependencies

Install Express, ReScript, and Rexpress using your preferred package manager:

::: code-group

```sh [npm]
npm install express rescript @rescript/core rexpress
```

```sh [pnpm]
pnpm add express rescript @rescript/core rexpress
```

```sh [yarn]
yarn add express rescript @rescript/core rexpress
```

```sh [bun]
bun add express rescript @rescript/core rexpress
```

```sh [deno]
deno add --npm express rescript @rescript/core rexpress
```

:::

---

## Create the `rescript.json` File

Create a `rescript.json` file at the root of your project:

::: code-group

```sh [Unix]
touch rescript.json
```

```powershell [Windows]
New-Item -Path ".\rescript.json" -ItemType File
```

:::

Add the following content to your `rescript.json` file:

```json
{
  "name": "your-project-name",
  "sources": [
    {
      "dir": "src",
      "subdirs": true
    }
  ],
  "package-specs": [
    {
      "module": "esmodule",
      "in-source": true
    }
  ],
  "suffix": ".res.mjs",
  "bs-dependencies": [
    "@rescript/core",
    "rexpress"
  ],
  "bsc-flags": [
    "-open RescriptCore"
  ]
}
```

See the [build configuration documentation](https://rescript-lang.org/docs/manual/v11.0.0/build-configuration) for more details about the `rescript.json` file.

---

## Compile `.res` Files to JavaScript

Add the following scripts to your `package.json` to compile your `.res` files:

```json
"scripts": {
  "res:dev": "rescript -w",
  "res:build": "rescript"
}
```

For more details on setting up a ReScript project, see the official [installation documentation](https://rescript-lang.org/docs/manual/v11.0.0/installation).

---

**Next Steps:**
You are now ready to start building your ReScript Express app! See the [Usage Examples](./examples.md) for sample code and patterns.