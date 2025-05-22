# How to Run

Follow these steps to build and run your ReScript Express app:

## Start the ReScript compiler in development mode
If there are any errors, check the output and fix them.

::: code-group

```sh [npm]
npm run res:dev
```

```sh [pnpm]
pnpm run res:dev
```

```sh [yarn]
yarn run res:dev
```

```sh [bun]
bun run res:dev
```

```sh [deno]
deno run res:dev
```

:::

## Build the JavaScript output for production
Once the ReScript check is complete, you can build the compiled JavaScript files:

::: code-group

```sh [npm]
npm run res:build
```

```sh [pnpm]
pnpm run res:build
```

```sh [yarn]
yarn run res:build
```

```sh [bun]
bun run res:build
```

```sh [deno]
deno run res:build
```

:::

## Run your server
Replace `TheNameOfYourFile.js` with the actual filename of your compiled server file.

::: code-group

```sh [npm]
node src/TheNameOfYourFile.js
```

```sh [pnpm]
node src/TheNameOfYourFile.js
```

```sh [yarn]
node src/TheNameOfYourFile.js
```

```sh [bun]
bun src/TheNameOfYourFile.js
```

```sh [deno]
deno run src/TheNameOfYourFile.js
```

:::