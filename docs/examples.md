# Rexpress Usage Examples

This page demonstrates how to use the **ReScript bindings** for [Express.js](https://expressjs.com/) to build backend applications.

## The Classic `Hello, World!`

```js
// App.res
open Express

let app = express()

app->get(Path("/"), Handler(
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

## Using Routers

```js
// RouterExample.res
open Express

let app = express()
let router = Router.make()

router->Router.get(Path("/hello"), Handler((_req, res) =>
  res->json({"msg": "Hello from router!"})->ignore
))

app->useForRouter(router, ~path="/api")

app->listen(~port=3001, ~fn=_ => {
  Console.log("API server at http://localhost:3001/api/hello")
})->ignore
```

## Handling POST Requests and JSON Body

```js
open Express

let app = express()
app->use(jsonMiddleware()->#Mid)

app->post(Path("/echo"), Handler((req, res) => {
  let body = req->body
  res->json(body)->ignore
}))

app->listen(~port=3002, ~fn=_ => {
  Console.log("POST server at http://localhost:3002/echo")
})->ignore
```

## Error Handling Middleware

```js
open Express

let app = express()

app->use(#Err((_err, _req, res, _next) => {
  res->status(InternalServerError)->json({"error": "Internal Server Error"})->ignore
}))

app->listen(~port=3003, ~fn=_ => {
  Console.log("Error handler running at http://localhost:3003")
})->ignore
```

## More

- See the [API documentation](../api/) for all available bindings.
- Check out the [Express.js documentation](https://expressjs.com/) for general usage patterns.
