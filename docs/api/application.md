# Application

In Express.js applications, the `app` object is the main entry point for defining routes and middleware. It provides methods to handle HTTP requests, set up middleware, and manage application settings.

In ReScript, you can create an Express application using the [express function](/api/express#express()). The `app` object is a central part of your application.

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
 let locals: express => {..}
```

Example:
```js
let locals = app->locals
Console.log(locals["title"])
```
### `app.mountpath`

The path on which the app is mounted. This is useful when your application is part of a larger application or when using sub-applications.

**ReScript Signature:**
```js
 let mountpath: express => string
```

Example:
```js
let mountPath = app->mountpath
Console.log(mountPath)
```

### `app.router`

The router object for the application. This is used to define routes and middleware.

**ReScript Signature:**
```js
 let router: express => Router.t
```

Example:
```js
let router = app->router
Console.log(router)
```

## Events

### `app.on('mount', callback(parent))`

Emitted when the app is mounted on a parent app. The `parent` argument is the parent application.

**ReScript Signature:**
```js
 let on: (express, string, 'a => unit) => unit
```

Example:
```js
app->on("mount", parent => {
  Console.log("Mounted on parent app")
  Console.log(parent)
})
```

## Methods

The `app` object provides several methods to define routes and handlers for specific HTTP methods. On this section will cover the data types used to define routes and handlers and middlewares.

### `apiRoute type`

Helps to define the type of route that can be used in the `app` methods.

**ReScript Signature:**
```js
@unboxed
type apiRoute =
  | Path(string)
  | ListPath(array<string>)
  | PathMatch(RegExp.t)
```

- `Path(string)`: This the most common case, where the route is defined by a string path. For example, `Path("/users")`.
- `ListPath(array<string>)`: This allows defining a route with multiple string paths. For example, `ListPath(["/users", "/admins"])`.
- `PathMatch(RegExp.t)`: This allows defining a route that matches a regular expression. For example, `PathMatch(%re("/\/users\/\d+/"))`.

:::note
The `%re(RegExp)` is a ReScript decorator that allows you to create a regular expression. It is used to define routes that match specific patterns. For more information, see the [ReScript documentation on Regular Expressions](https://rescript-lang.org/syntax-lookup#regular-expression).
:::

### `apiHandler type`

Helps to define the type of handler that can be used in the `app` methods.

**ReScript Signature:**
```js
type apiHandler =
  | Handler((request, response) => unit)
  | AsyncHandler((request, response) => promise<unit>)
```

- `Handler((request, response) => unit)`: This is a synchronous handler that takes a request and response object and returns nothing.
- `AsyncHandler((request, response) => promise<unit>)`: This is an asynchronous handler that takes a request and response object and returns a promise that resolves to nothing.

### `app.all(path, callback [, callback ...])`

Defines a route for all HTTP methods at the specified path. This is useful for handling requests that do not match any other routes.

**ReScript Signature:**
```js
 let all: (
  express,
  apiRoute,
  apiHandler,
  ~middlewares: array<[#Mid(middleware) | #AsyncMid(asyncMiddleware)]>=?,
) => unit
```

Parameters:
- `path`: The path for the route, defined using the `apiRoute` type.
- `callback`: The handler for the route, defined using the `apiHandler` type.
- `middlewares`: Optional array of middlewares to apply to the route. Each middleware can be either a synchronous or asynchronous middleware.

Example:
```js
app->all(Path("/users"), Handler((req, res) => {
  res->send("Handling all methods for /users")-> ignore
}), ~middlewares=[#Mid(myMiddleware)])
```

### `app.get(path, callback [, callback ...])`

Defines a route for the GET HTTP method at the specified path.

**ReScript Signature:**
```js
 let get: (
  express,
  apiRoute,
  apiHandler,
  ~middlewares: array<[#Mid(middleware) | #AsyncMid(asyncMiddleware)]>=?,
) => unit
```

Parameters:
- `path`: The path for the route, defined using the `apiRoute` type.
- `callback`: The handler for the route, defined using the `apiHandler` type.
- `middlewares`: Optional array of middlewares to apply to the route. Each middleware can be either a synchronous or asynchronous middleware.

Example:
```js
app->get(Path("/users"), Handler((req, res) => {
  res->send("Handling GET request for /users")-> ignore
}), ~middlewares=[#Mid(myMiddleware)])
```

### `app.post(path, callback [, callback ...])`

Defines a route for the POST HTTP method at the specified path.

**ReScript Signature:**
```js
 let post: (
  express,
  apiRoute,
  apiHandler,
  ~middlewares: array<[#Mid(middleware) | #AsyncMid(asyncMiddleware)]>=?,
) => unit
```

Parameters:
- `path`: The path for the route, defined using the `apiRoute` type.
- `callback`: The handler for the route, defined using the `apiHandler` type.
- `middlewares`: Optional array of middlewares to apply to the route. Each middleware can be either a synchronous or asynchronous middleware.

Example:
```js
app->post(Path("/users"), Handler((req, res) => {
  res->send("Handling POST request for /users")-> ignore
}), ~middlewares=[#Mid(myMiddleware)])
```

### `app.put(path, callback [, callback ...])`

Defines a route for the PUT HTTP method at the specified path.

**ReScript Signature:**
```js
 let put: (
  express,
  apiRoute,
  apiHandler,
  ~middlewares: array<[#Mid(middleware) | #AsyncMid(asyncMiddleware)]>=?,
) => unit
```

Parameters:
- `path`: The path for the route, defined using the `apiRoute` type.
- `callback`: The handler for the route, defined using the `apiHandler` type.
- `middlewares`: Optional array of middlewares to apply to the route. Each middleware can be either a synchronous or asynchronous middleware.

Example:
```js
app->put(Path("/users"), Handler((req, res) => {
  res->send("Handling PUT request for /users")-> ignore
}), ~middlewares=[#Mid(myMiddleware)])
```

### `app.delete(path, callback [, callback ...])`

Defines a route for the DELETE HTTP method at the specified path.

**ReScript Signature:**
```js
 let delete: (
  express,
  apiRoute,
  apiHandler,
  ~middlewares: array<[#Mid(middleware) | #AsyncMid(asyncMiddleware)]>=?,
) => unit
```

Parameters:
- `path`: The path for the route, defined using the `apiRoute` type.
- `callback`: The handler for the route, defined using the `apiHandler` type.
- `middlewares`: Optional array of middlewares to apply to the route. Each middleware can be either a synchronous or asynchronous middleware.

Example:
```js
app->delete(Path("/users"), Handler((req, res) => {
  res->send("Handling DELETE request for /users")-> ignore
}), ~middlewares=[#Mid(myMiddleware)])
```

### `app.disable(name)`

Disables a setting for the application. This is useful for turning off certain features or behaviors.

**ReScript Signature:**
```js
 let disable: (express, string) => unit
```

Parameters:
- `name`: The name of the setting to disable. Common settings include "x-powered-by", "etag", etc.

Example:
```js
app->disable("x-powered-by")
```

### `app.disabled(name)`

Checks if a setting is disabled for the application.

**ReScript Signature:**
```js
 let disabled: (express, string) => bool
```

Parameters:
- `name`: The name of the setting to check.

Example:
```js
let isDisabled = app->disabled("x-powered-by")
Console.log(isDisabled) // true if disabled, false otherwise
```

### `app.enable(name)`

Enables a setting for the application. This is useful for turning on certain features or behaviors.

**ReScript Signature:**
```js
 let enable: (express, string) => unit
```

Parameters:
- `name`: The name of the setting to enable. Common settings include "x-powered-by", "etag", etc.

Example:
```js
app->enable("x-powered-by")
```

### `app.enabled(name)`

Checks if a setting is enabled for the application.

**ReScript Signature:**
```js
 let enabled: (express, string) => bool
```

Parameters:
- `name`: The name of the setting to check.

Example:
```js
let isEnabled = app->enabled("x-powered-by")
Console.log(isEnabled) // true if enabled, false otherwise
```