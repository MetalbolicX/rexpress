# Rexpress Usage Examples

This page demonstrates how to use the **ReScript bindings** for [Express.js](https://expressjs.com/) to build backend applications.

---

## Getting Started

First, install the required dependencies:

```bash
npm install express
npm install rescript
```

---

## Minimal Example

Let's create a `Hello, world!` web server.

```js
// App.res
open Express

let app = express()

app->get(String("/"), Handler(
  (_req, res) => res
    ->status(OK)
    ->json({
      "message": "Hello from ReScript Express!"
    })->ignore
))

app->listen(~port=3000, ~fn=_ => {
  Console.log("Server running at http://localhost:3000")
})->ignore
```

---

## Using Routers

```js
// RouterExample.res
open Express

let app = express()
let router = Router.make()

router->Router.get(String("/hello"), (_req, res) => {
  res->json({"msg": "Hello from router!"})->ignore
})

app->useForRouter(router, ~path="/api")
app->listen(~port=3001, ~fn=_ => {
  Console.log("API server at http://localhost:3001/api/hello")
})->ignore
```

---

## Handling POST Requests and JSON Body

```js
open Express

let app = express()
app->use(jsonMiddleware())

app->post(String("/echo"), (req, res) => {
  let body = req->body
  res->json(body)->ignore
})

app->listen(~port=3002, ~fn=_ => {
  Js.log("POST server at http://localhost:3002/echo")
})->ignore
```

---

## Error Handling Middleware

```js
open Express

let app = express()

app->use((_req, res, _next, ~error=Exn.raiseError("Unknown error")) => {
  Js.log2("Error:", error)
  res->status(InternalServerError)->json({"error": "Something went wrong"})->ignore
})

app->listen(~port=3003, ~fn=_ => {
  Js.log("Error handler running at http://localhost:3003")
})->ignore
```

---

## Status Codes with Variants

```js
open Express

let app = express()

app->get(String("/notfound"), (_req, res) => {
  res->sendStatus(NotFound)->ignore
})

app->listen(~port=3004, ~fn=_ => {
  Js.log("Try http://localhost:3004/notfound")
})->ignore
```

---

## More

- See the [API documentation](../api/) for all available bindings.
- Check out the [Express.js documentation](https://expressjs.com/) for general usage patterns.

---

> 💡 **Tip:** All code blocks use ReScript syntax. Make sure your project is set up for ReScript compilation.
