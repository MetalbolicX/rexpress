type express

@module external expressCjs: unit => express = "express"
@module("express") external express: unit => express = "default"

type request
type response

type middleware = (request, response, unit => unit) => unit
type errorMiddleware = (exn, request, response, unit => unit) => unit
type asyncMiddleware = (request, response, unit => unit) => promise<unit>
type asyncErrorMiddleware = (exn, request, response, unit => unit) => promise<unit>
type handler = (request, response) => unit
type asyncHandler = (request, response) => promise<unit>

external asMiddleware: express => middleware = "%identity"

// The *Middleware suffixes aren't really nice but avoids forcing people to disable warning 44
@module("express") external jsonMiddleware: (~options: {..}=?) => middleware = "json"
@module("express") external rawMiddleware: (~options: {..}=?) => middleware = "raw"
@module("express") external textMiddleware: (~options: {..}=?) => middleware = "text"
@module("express") external urlencodedMiddleware: (~options: {..}=?) => middleware = "urlencoded"
@module("express") external staticMiddleware: (string, ~options: {..}=?) => middleware = "static"

@send
external use: (
  express,
  @unwrap
  [
    | #Mid(middleware)
    | #AsyncMid(asyncMiddleware)
    | #CatchErr(errorMiddleware)
    | #AsyncCatchErr(asyncErrorMiddleware)
  ],
  ~path: string=?,
) => unit = "use"
@send external set: (express, string, string) => unit = "set"

@unboxed
type apiRoute =
  | String(string)
  | RegExp(RegExp.t)

type method = [#GET | #POST | #PUT | #DELETE | #PATCH]

type apiHandler =
  | Handler(handler)
  | AsyncHandler(asyncHandler)

@send
external getWithMiddlewares: (
  express,
  apiRoute,
  array<'a>,
  @unwrap [#Handler(handler) | #AsyncHandler(asyncHandler)],
) => unit = "get"

@send
external allWithMiddlewares: (
  express,
  apiRoute,
  array<'a>,
  @unwrap [#Handler(handler) | #AsyncHandler(asyncHandler)],
) => unit = "all"

@send
external postWithMiddlewares: (
  express,
  apiRoute,
  array<'a>,
  @unwrap [#Handler(handler) | #AsyncHandler(asyncHandler)],
) => unit = "post"

@send
external deleteWithMiddlewares: (
  express,
  apiRoute,
  array<'a>,
  @unwrap [#Handler(handler) | #AsyncHandler(asyncHandler)],
) => unit = "delete"

@send
external patchWithMiddlewares: (
  express,
  apiRoute,
  array<'a>,
  @unwrap [#Handler(handler) | #AsyncHandler(asyncHandler)],
) => unit = "patch"

@send
external putWithMiddlewares: (
  express,
  apiRoute,
  array<'a>,
  @unwrap [#Handler(handler) | #AsyncHandler(asyncHandler)],
) => unit = "put"

let unwrapMiddleware: array<[#Mid(middleware) | #AsyncMid(asyncMiddleware)]> => array<
  'a,
> = middlewares =>
  middlewares->Array.map(middleware =>
    switch middleware {
    | #Mid(fn) => fn->Obj.magic
    | #AsyncMid(fn) => fn->Obj.magic
    }
  )

let get: (
  express,
  apiRoute,
  apiHandler,
  ~middlewares: array<[#Mid(middleware) | #AsyncMid(asyncMiddleware)]>=?,
) => unit = (app, route, handler, ~middlewares as mds=[]) =>
  switch handler {
  | Handler(fn) => app->getWithMiddlewares(route, mds->unwrapMiddleware, #Handler(fn))
  | AsyncHandler(fn) => app->getWithMiddlewares(route, mds->unwrapMiddleware, #AsyncHandler(fn))
  }

let all: (
  express,
  apiRoute,
  apiHandler,
  ~middlewares: array<[#Mid(middleware) | #AsyncMid(asyncMiddleware)]>=?,
) => unit = (app, route, handler, ~middlewares as mds=[]) =>
  switch handler {
  | Handler(fn) => app->allWithMiddlewares(route, mds->unwrapMiddleware, #Handler(fn))
  | AsyncHandler(fn) => app->allWithMiddlewares(route, mds->unwrapMiddleware, #AsyncHandler(fn))
  }

let post: (
  express,
  apiRoute,
  apiHandler,
  ~middlewares: array<[#Mid(middleware) | #AsyncMid(asyncMiddleware)]>=?,
) => unit = (app, route, handler, ~middlewares as mds=[]) =>
  switch handler {
  | Handler(fn) => app->postWithMiddlewares(route, mds->unwrapMiddleware, #Handler(fn))
  | AsyncHandler(fn) => app->postWithMiddlewares(route, mds->unwrapMiddleware, #AsyncHandler(fn))
  }

let delete: (
  express,
  apiRoute,
  apiHandler,
  ~middlewares: array<[#Mid(middleware) | #AsyncMid(asyncMiddleware)]>=?,
) => unit = (app, route, handler, ~middlewares as mds=[]) =>
  switch handler {
  | Handler(fn) => app->deleteWithMiddlewares(route, mds->unwrapMiddleware, #Handler(fn))
  | AsyncHandler(fn) => app->deleteWithMiddlewares(route, mds->unwrapMiddleware, #AsyncHandler(fn))
  }

let patch: (
  express,
  apiRoute,
  apiHandler,
  ~middlewares: array<[#Mid(middleware) | #AsyncMid(asyncMiddleware)]>=?,
) => unit = (app, route, handler, ~middlewares as mds=[]) =>
  switch handler {
  | Handler(fn) => app->patchWithMiddlewares(route, mds->unwrapMiddleware, #Handler(fn))
  | AsyncHandler(fn) => app->patchWithMiddlewares(route, mds->unwrapMiddleware, #AsyncHandler(fn))
  }

let put: (
  express,
  apiRoute,
  apiHandler,
  ~middlewares: array<[#Mid(middleware) | #AsyncMid(asyncMiddleware)]>=?,
) => unit = (app, route, handler, ~middlewares as mds=[]) =>
  switch handler {
  | Handler(fn) => app->putWithMiddlewares(route, mds->unwrapMiddleware, #Handler(fn))
  | AsyncHandler(fn) => app->putWithMiddlewares(route, mds->unwrapMiddleware, #AsyncHandler(fn))
  }

@send external enable: (express, string) => unit = "enable"
@send external enabled: (express, string) => bool = "enabled"
@send external disable: (express, string) => unit = "disable"

type server

@send
external listen: (express, ~port: int=?, ~host: string=?, ~fn: exn => unit=?) => server = "listen"

// request properties
@get external baseUrl: request => string = "baseUrl"
@get external body: request => 'a = "body"
@get external cookies: request => 'a = "cookies"
@get external fresh: request => bool = "fresh"
@get external hostname: request => string = "hostname"
@get external ip: request => string = "ip"
@get external ips: request => array<string> = "ips"
@get external method: request => method = "method"
@get external originalUrl: request => string = "originalUrl"
@get external params: request => 'a = "params"
@get external path: request => string = "path"
@get external protocol: request => string = "protocol"
@get external query: request => 'a = "query"
@get external route: request => 'a = "route"
@get external secure: request => bool = "secure"
@get external signedCookies: request => 'a = "signedCookies"
@get external stale: request => bool = "stale"
@get external subdomains: request => array<string> = "subdomains"
@get external xhr: request => bool = "xhr"

// This is a bit unfortunate, as it breaks the zero-cost philosophy,
// but the `string | false` signature doesn't play well with an ML type-system
external asString: 'a => string = "%identity"
let parseValue: 'a => option<string> = value =>
  switch Js.typeof(value) {
  | "boolean" => None
  | _ => Some(value->asString)
  }

// request methods
@send external accepts: (request, array<string>) => 'a = "accepts"
@send external acceptsCharset: (request, array<string>) => 'a = "acceptsCharset"
@send external acceptsEncodings: (request, array<string>) => 'a = "acceptsEncodings"
@send external acceptsLanguages: (request, array<string>) => 'a = "acceptsLanguages"

let accepts: (request, array<string>) => option<string> = (req, value) =>
  req->accepts(value)->parseValue
let acceptsCharset: (request, array<string>) => option<string> = (req, value) =>
  req->acceptsCharset(value)->parseValue
let acceptsEncodings: (request, array<string>) => option<string> = (req, value) =>
  req->acceptsEncodings(value)->parseValue
let acceptsLanguages: (request, array<string>) => option<string> = (req, value) =>
  req->acceptsLanguages(value)->parseValue

@send external getRequestHeader: (request, string) => option<string> = "get"
@send external is: (request, string) => 'a = "is"

let is: (request, string) => option<string> = (req, value) => req->is(value)->parseValue

@send external param: (request, string) => option<string> = "param"

// response properties
@get external headersSent: response => bool = "headersSent"
@get external locals: response => {..} = "locals"

// response methods
@send external append: (response, string, string) => response = "append"
@send external attachment: (response, ~filename: string=?) => response = "attachment"
@send
external cookie: (response, ~name: string, ~value: string, ~options: {..}=?) => response = "cookie"
@send external clearCookie: (response, string) => response = "clearCookie"
@send external download: (response, ~path: string) => response = "download"
@send
external downloadWithFilename: (response, ~path: string, ~filename: string) => response = "download"
@send external end: (response, ~data: 'a=?, ~encoding: string=?) => response = "end"
@send external format: (response, {..}) => response = "format"
@send external getResponseHeader: (response, string) => option<string> = "get"
@send external json: (response, 'a) => response = "json"
@send external jsonp: (response, 'a) => response = "jsonp"
@send external links: (response, Js.Dict.t<string>) => response = "links"
@send external location: (response, string) => response = "location"
@send external redirect: (response, string, ~statusCode: int=?) => response = "redirect"
@send
external render: (response, string, ~locals: {..}=?, ~fn: (exn, string) => unit=?) => unit =
  "render"
@send external send: (response, 'a) => response = "send"
@send external sendFile: (response, string, ~options: {..}=?) => response = "sendFile"
@send external setStatus: (response, int) => response = "status"
@send external sendStatus: (response, int) => response = "sendStatus"
@send external setRes: (response, string, string) => unit = "set"
@send external type_: (response, string) => string = "type"
@send external vary: (response, string) => response = "vary"

// Define a variant for HTTP status codes
type httpStatus =
  | OK
  | Created
  | Accepted
  | NoContent
  | MovedPermanently
  | Found
  | SeeOther
  | NotModified
  | TemporaryRedirect
  | PermanentRedirect
  | BadRequest
  | Unauthorized
  | Forbidden
  | NotFound
  | InternalServerError
  | NotImplemented
  | BadGateway
  | ServiceUnavailable
  | GatewayTimeout
  | HTTPVersionNotSupported

// Map the variant to the corresponding integer status code
let getStatusCode: httpStatus => int = status =>
  switch status {
  | OK => 200
  | Created => 201
  | Accepted => 202
  | NoContent => 204
  | MovedPermanently => 301
  | Found => 302
  | SeeOther => 303
  | NotModified => 304
  | TemporaryRedirect => 307
  | PermanentRedirect => 308
  | BadRequest => 400
  | Unauthorized => 401
  | Forbidden => 403
  | NotFound => 404
  | InternalServerError => 500
  | NotImplemented => 501
  | BadGateway => 502
  | ServiceUnavailable => 503
  | GatewayTimeout => 504
  | HTTPVersionNotSupported => 505
  }

// Helper function to use the variant with the `status` binding
let status: (response, httpStatus) => response = (res, code) => res->setStatus(getStatusCode(code))

// Helper function to use the variant with the `sendStatus` binding
let sendStatus: (response, httpStatus) => response = (res, code) =>
  res->sendStatus(getStatusCode(code))

module Router = {
  type t
  @module("express") external make: unit => t = "Router"
  @send
  external use: (
    t,
    @unwrap
    [
      | #Mid(middleware)
      | #AsyncMid(asyncMiddleware)
      | #CatchErr(errorMiddleware)
      | #AsyncCatchErr(asyncErrorMiddleware)
    ],
    ~path: string=?,
  ) => unit = "use"

  @send
  external allWithMiddlewares: (
    t,
    apiRoute,
    array<'a>,
    @unwrap [#Handler(handler) | #AsyncHandler(asyncHandler)],
  ) => unit = "all"
  @send
  external getWithMiddlewares: (
    t,
    apiRoute,
    array<'a>,
    @unwrap [#Handler(handler) | #AsyncHandler(asyncHandler)],
  ) => unit = "get"
  @send
  external postWithMiddlewares: (
    t,
    apiRoute,
    array<'a>,
    @unwrap [#Handler(handler) | #AsyncHandler(asyncHandler)],
  ) => unit = "post"
  @send
  external deleteWithMiddlewares: (
    t,
    apiRoute,
    array<'a>,
    @unwrap [#Handler(handler) | #AsyncHandler(asyncHandler)],
  ) => unit = "delete"
  @send
  external patchWithMiddlewares: (
    t,
    apiRoute,
    array<'a>,
    @unwrap [#Handler(handler) | #AsyncHandler(asyncHandler)],
  ) => unit = "patch"
  @send
  external putWithMiddlewares: (
    t,
    apiRoute,
    array<'a>,
    @unwrap [#Handler(handler) | #AsyncHandler(asyncHandler)],
  ) => unit = "put"

  let all: (
    t,
    apiRoute,
    apiHandler,
    ~middlewares: array<[#Mid(middleware) | #AsyncMid(asyncMiddleware)]>=?,
  ) => unit = (router, route, handler, ~middlewares as mds=[]) =>
    switch handler {
    | Handler(fn) => router->allWithMiddlewares(route, mds->unwrapMiddleware, #Handler(fn))
    | AsyncHandler(fn) =>
      router->allWithMiddlewares(route, mds->unwrapMiddleware, #AsyncHandler(fn))
    }

  let get: (
    t,
    apiRoute,
    apiHandler,
    ~middlewares: array<[#Mid(middleware) | #AsyncMid(asyncMiddleware)]>=?,
  ) => unit = (router, route, handler, ~middlewares as mds=[]) =>
    switch handler {
    | Handler(fn) => router->getWithMiddlewares(route, mds->unwrapMiddleware, #Handler(fn))
    | AsyncHandler(fn) =>
      router->getWithMiddlewares(route, mds->unwrapMiddleware, #AsyncHandler(fn))
    }

  let post: (
    t,
    apiRoute,
    apiHandler,
    ~middlewares: array<[#Mid(middleware) | #AsyncMid(asyncMiddleware)]>=?,
  ) => unit = (router, route, handler, ~middlewares as mds=[]) =>
    switch handler {
    | Handler(fn) => router->postWithMiddlewares(route, mds->unwrapMiddleware, #Handler(fn))
    | AsyncHandler(fn) =>
      router->postWithMiddlewares(route, mds->unwrapMiddleware, #AsyncHandler(fn))
    }

  let delete: (
    t,
    apiRoute,
    apiHandler,
    ~middlewares: array<[#Mid(middleware) | #AsyncMid(asyncMiddleware)]>=?,
  ) => unit = (router, route, handler, ~middlewares as mds=[]) =>
    switch handler {
    | Handler(fn) => router->deleteWithMiddlewares(route, mds->unwrapMiddleware, #Handler(fn))
    | AsyncHandler(fn) =>
      router->deleteWithMiddlewares(route, mds->unwrapMiddleware, #AsyncHandler(fn))
    }

  let patch: (
    t,
    apiRoute,
    apiHandler,
    ~middlewares: array<[#Mid(middleware) | #AsyncMid(asyncMiddleware)]>=?,
  ) => unit = (router, route, handler, ~middlewares as mds=[]) =>
    switch handler {
    | Handler(fn) => router->patchWithMiddlewares(route, mds->unwrapMiddleware, #Handler(fn))
    | AsyncHandler(fn) =>
      router->patchWithMiddlewares(route, mds->unwrapMiddleware, #AsyncHandler(fn))
    }

  let put: (
    t,
    apiRoute,
    apiHandler,
    ~middlewares: array<[#Mid(middleware) | #AsyncMid(asyncMiddleware)]>=?,
  ) => unit = (router, route, handler, ~middlewares as mds=[]) =>
    switch handler {
    | Handler(fn) => router->putWithMiddlewares(route, mds->unwrapMiddleware, #Handler(fn))
    | AsyncHandler(fn) =>
      router->putWithMiddlewares(route, mds->unwrapMiddleware, #AsyncHandler(fn))
    }

  type paramHandler = (request, response, unit => unit, string, string) => unit

  @send external param: (t, string, paramHandler) => unit = "param"
  //@deprecated("deprecated as of v4.11.0")
  //@send external defineParamBehavior: ((string, 'a) => paramHandler) => unit = "param"

  @send external route: string => t = "route"
}

@send external useRouter: (express, Router.t) => unit = "use"
@send external useRouterWithPath: (express, string, Router.t) => unit = "use"
let useForRouter: (express, Router.t, ~path: string=?) => unit = (app, router, ~path="/") =>
  switch path {
  | p if p->String.length > 1 => app->useRouterWithPath(p, router)
  | _ => app->useRouter(router)
  }
