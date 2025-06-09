# Application

In Express.js applications, the `app` object is the main entry point for defining routes and middleware. It provides methods to handle HTTP requests, set up middleware, and manage application settings.

In ReScript, you can create an Express application using the `express` function. The `app` object is a central part of your application.

Example:
```js
open Express

let app = express()

app->get(Path("/), Handler((_req, res) => {
  res->send("Hello, World!")-> ignore
}))

app->listen(~port=3000, ~fn=_ => {
  Console.log("Listening at http://localhost:3000")
})-> ignore
```
## Properties

### `app.locals`

An object for storing local variables that are scoped to the request and response objects.

**ReScript Signature:**
```js
 locals: express => {..}
```

Example:
```js
let locals = app->locals
Console.log(locals["title"])
```
