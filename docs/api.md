---
outline: deep
---

# Rexpress API Reference

## Overview
This document provides an overview of the ReScript bindings for Express.js, a web application framework for Node.js. The bindings allow you to build web applications using the ReScript programming language, providing a type-safe and functional approach to server-side development. This binding are alligned with the latest version of Express.js, which is version 5 and their [API reference](https://expressjs.com/en/5x/api.html).

## API Reference

### `express()`

To start a new Express application, in JavaScript or TypeScript, it's as simple as:

Using `commonjs`:

```js
const express = require('express');
const app = express();
```

Or using `ESM`:

```js
import express from 'express';
const app = express();
```

In ReScript, you can do the same with:

For `commonjs`:

```js
open Express
let app = expressCjs()
```

For `ESM`:

```js
open Express
let app = express()
```

::: warning

It's better to use the `express` function instead of `expressCjs` now that **Node.js** supports `ESM` imports. The `expressCjs` function is only available for backward compatibility with older versions of Node.js.

:::

### `express.json([options])`

In JavaScript or TypeScript, you can use the `express.json()` middleware to parse incoming JSON requests. In ReScript, it is done like this:

`jsonMiddleware(~options: {..}=?)` is a function that can take an optional `options` parameter and returns a middleware function.

```js
jsonMiddleware(~options={
  "inflate": false,
  "strict": false,
})
```



## More

Check out the documentation for the [full list of runtime APIs](https://vitepress.dev/reference/runtime-api#usedata).
