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

let get: (
  express,
  apiRoute,
  apiHandler,
  ~middlewares: array<[#Mid(middleware) | #AsyncMid(asyncMiddleware)]>=?,
) => unit

let post: (
  express,
  apiRoute,
  apiHandler,
  ~middlewares: array<[#Mid(middleware) | #AsyncMid(asyncMiddleware)]>=?,
) => unit

let put: (
  express,
  apiRoute,
  apiHandler,
  ~middlewares: array<[#Mid(middleware) | #AsyncMid(asyncMiddleware)]>=?,
) => unit

let delete: (
  express,
  apiRoute,
  apiHandler,
  ~middlewares: array<[#Mid(middleware) | #AsyncMid(asyncMiddleware)]>=?,
) => unit

let patch: (
  express,
  apiRoute,
  apiHandler,
  ~middlewares: array<[#Mid(middleware) | #AsyncMid(asyncMiddleware)]>=?,
) => unit

let all: (
  express,
  apiRoute,
  apiHandler,
  ~middlewares: array<[#Mid(middleware) | #AsyncMid(asyncMiddleware)]>=?,
) => unit

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

let accepts: (request, array<string>) => option<string>
let acceptsCharset: (request, array<string>) => option<string>
let acceptsEncodings: (request, array<string>) => option<string>
let acceptsLanguages: (request, array<string>) => option<string>

@send external getRequestHeader: (request, string) => option<string> = "get"

let is: (request, string) => option<string>

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

let status: (response, httpStatus) => response
let sendStatus: (response, httpStatus) => response

module Router: {
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

  let get: (
    t,
    apiRoute,
    apiHandler,
    ~middlewares: array<[#Mid(middleware) | #AsyncMid(asyncMiddleware)]>=?,
  ) => unit

  let post: (
    t,
    apiRoute,
    apiHandler,
    ~middlewares: array<[#Mid(middleware) | #AsyncMid(asyncMiddleware)]>=?,
  ) => unit

  let put: (
    t,
    apiRoute,
    apiHandler,
    ~middlewares: array<[#Mid(middleware) | #AsyncMid(asyncMiddleware)]>=?,
  ) => unit

  let delete: (
    t,
    apiRoute,
    apiHandler,
    ~middlewares: array<[#Mid(middleware) | #AsyncMid(asyncMiddleware)]>=?,
  ) => unit

  let patch: (
    t,
    apiRoute,
    apiHandler,
    ~middlewares: array<[#Mid(middleware) | #AsyncMid(asyncMiddleware)]>=?,
  ) => unit

  let all: (
    t,
    apiRoute,
    apiHandler,
    ~middlewares: array<[#Mid(middleware) | #AsyncMid(asyncMiddleware)]>=?,
  ) => unit

  type paramHandler = (request, response, unit => unit, string, string) => unit

  @send external param: (t, string, paramHandler) => unit = "param"
  //@deprecated("deprecated as of v4.11.0")
  //@send external defineParamBehavior: ((string, 'a) => paramHandler) => unit = "param"

  @send external route: string => t = "route"
}

let useForRouter: (express, Router.t, ~path: string=?) => unit
