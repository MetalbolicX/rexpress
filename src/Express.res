type express

// "default" &  seem to conflict a bit right now
// https://github.com/rescript-lang/rescript-compiler/issues/5004
@module external expressCjs: unit => express = "express"
@module("express") external express: unit => express = "default"

type request
type response

// type middleware = (req, res, unit => unit) => unit
type middleware = (request, response, unit => unit, ~error: exn=?) => unit
// type middlewareWithError = (Js.Exn.t, req, res, unit => unit) => unit
type handler = (request, response) => unit
type asyncHandler = (request, response) => promise<unit>

external asMiddleware: express => middleware = "%identity"

// The *Middleware suffixes aren't really nice but avoids forcing people to disable warning 44
// @module("express") external jsonMiddleware: unit => middleware = "json"
// @module("express") external jsonMiddlewareWithOptions: {..} => middleware = "json"
@module("express") external jsonMiddleware: (~options: {..}=?) => middleware = "json"
// @module("express") external rawMiddleware: unit => middleware = "raw"
// @module("express") external rawMiddlewareWithOptions: {..} => middleware = "raw"
@module("express") external rawMiddleware: (~options: {..}=?) => middleware = "raw"
// @module("express") external textMiddleware: unit => middleware = "text"
// @module("express") external textMiddlewareWithOptions: {..} => middleware = "text"
@module("express") external textMiddleware: (~options: {..}=?) => middleware = "text"
// @module("express")
// external urlencodedMiddleware: unit => middleware = "urlencoded"
// @module("express")
// external urlencodedMiddlewareWithOptions: {..} => middleware = "urlencoded"
@module("express") external urlencodedMiddleware: (~options: {..}=?) => middleware = "urlencoded"
// @module("express") external staticMiddleware: string => middleware = "static"
// @module("express")
// external staticMiddlewareWithOptions: (string, {..}) => middleware = "static"
@module("express") external staticMiddleware: (string, ~options: {..}=?) => middleware = "static"

@send external use: (express, middleware, ~path: string=?) => unit = "use"
@send external set: (express, string, string) => unit = "set"

// @send external useWithError: (express, middlewareWithError) => unit = "use"
// @send external useWithPathAndError: (express, string, middlewareWithError) => unit = "use"

@unboxed
type apiRoute =
  | String(string)
  | RegExp(RegExp.t)

@send external get: (express, apiRoute, handler) => unit = "get"
@send external post: (express, apiRoute, handler) => unit = "post"
@send external delete: (express, apiRoute, handler) => unit = "delete"
@deprecated("Express 5.0 deprecates app.del(), use app.delete() instead")
@send external del: (express, apiRoute, handler) => unit = "del"
@send external patch: (express, apiRoute, handler) => unit = "patch"
@send external put: (express, apiRoute, handler) => unit = "put"
@send external all: (express, apiRoute, handler) => unit = "all"

// Asynchronous cases
@send external allAsync: (express, apiRoute, asyncHandler) => promise<unit> = "all"
@send external getAsync: (express, apiRoute, asyncHandler) => promise<unit> = "get"
@send external postAsync: (express, apiRoute, asyncHandler) => promise<unit> = "post"
@send external deleteAsync: (express, apiRoute, asyncHandler) => promise<unit> = "delete"
@send external delAsync: (express, apiRoute, asyncHandler) => promise<unit> = "del"
@send external patchAsync: (express, apiRoute, asyncHandler) => promise<unit> = "patch"
@send external putAsync: (express, apiRoute, asyncHandler) => promise<unit> = "put"

@send external enable: (express, string) => unit = "enable"
@send external enabled: (express, string) => bool = "enabled"
@send external disable: (express, string) => unit = "disable"

type server

@send external listen: (express,  ~port: int=?, ~host: string=?, ~fn: exn => unit=?) => server = "listen"
// @send
// external listenWithCallback: (express, int, option<Js.Exn.t> => unit) => server = "listen"
// @send
// external listenWithHostAndCallback: (
//   express,
//   ~port: int,
//   ~host: string,
//   option<Js.Exn.t> => unit,
// ) => server = "listen"

type method = [#GET | #POST | #PUT | #DELETE | #PATCH]

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

let accepts: (request, array<string>) => option<string> = (req, value) => req->accepts(value)->parseValue
let acceptsCharset: (request, array<string>) => option<string> = (req, value) => req->acceptsCharset(value)->parseValue
let acceptsEncodings: (request, array<string>) => option<string> = (req, value) => req->acceptsEncodings(value)->parseValue
let acceptsLanguages: (request, array<string>) => option<string> = (req, value) => req->acceptsLanguages(value)->parseValue

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
@send external cookie: (response, ~name: string, ~value: string) => response = "cookie"
@send external cookieWithOptions: (response, ~name: string, ~value: string, {..}) => response = "cookie"
@send external clearCookie: (response, string) => response = "clearCookie"
@send external download: (response, ~path: string) => response = "download"
@send external downloadWithFilename: (response, ~path: string, ~filename: string) => response = "download"
@send external end: response => response = "end"
@send external endWithData: (response, 'a) => response = "end"
@send external endWithDataAndEncoding: (response, 'a, ~encoding: string) => response = "end"
@send external format: (response, {..}) => response = "format"
@send external getResponseHeader: (response, string) => option<string> = "get"
@send external json: (response, 'a) => response = "json"
@send external jsonp: (response, 'a) => response = "jsonp"
@send external links: (response, Js.Dict.t<string>) => response = "links"
@send external location: (response, string) => response = "location"
@send external redirect: (response, string) => response = "redirect"
@send external redirectWithStatusCode: (response, ~statusCode: int, string) => response = "redirect"
@send external render: (response, string, ~locals: {..}=?, ~fn: (exn, string) => unit=?) => unit = "render"
@send external send: (response, 'a) => response = "send"
@send external sendFile: (response, string) => response = "sendFile"
@send external sendFileWithOptions: (response, string, {..}) => response = "sendFile"
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
  | BadRequest
  | Unauthorized
  | Forbidden
  | NotFound
  | InternalServerError
  | NotImplemented

// Map the variant to the corresponding integer status code
let getStatusCode: httpStatus => int = status => switch status {
  | OK => 200
  | Created => 201
  | Accepted => 202
  | NoContent => 204
  | BadRequest => 400
  | Unauthorized => 401
  | Forbidden => 403
  | NotFound => 404
  | InternalServerError => 500
  | NotImplemented => 501
}

// Helper function to use the variant with the `status` binding
let status: (response, httpStatus) => response = (res, code) => res->setStatus(getStatusCode(code))

module Router = {
  type t
  @module("express") external make: () => t = "Router"
  @send external use: (t, middleware, ~path: string=?) => unit = "use"
  // @send external useWithPath: (t, string, middleware) => unit = "use"

  // @send external useWithError: (t, middlewareWithError) => unit = "use"
  // @send external useWithPathAndError: (t, string, middlewareWithError) => unit = "use"

  @send external get: (t, apiRoute, handler) => unit = "get"
  @send external post: (t, apiRoute, handler) => unit = "post"
  @send external delete: (t, apiRoute, handler) => unit = "delete"
  @deprecated("Express 5.0 deprecates app.del(), use app.delete() instead")
  @send external del: (t, apiRoute, handler) => unit = "del"
  @send external patch: (t, apiRoute, handler) => unit = "patch"
  @send external put: (t, apiRoute, handler) => unit = "put"
  @send external all: (t, apiRoute, handler) => unit = "all"

  // Asynchronous cases
  @send external getAsync: (t, apiRoute, asyncHandler) => promise<unit> = "get"
  @send external postAsync: (t, apiRoute, asyncHandler) => promise<unit> = "post"
  @send external deleteAsync: (t, apiRoute, asyncHandler) => promise<unit> = "delete"
  @send external patchAsync: (t, apiRoute, asyncHandler) => promise<unit> = "patch"
  @send external putAsync: (t, apiRoute, asyncHandler) => promise<unit> = "put"
  @send external allAsync: (t, apiRoute, asyncHandler) => promise<unit> = "all"

  type paramHandler = (request, response, unit => unit, string, string) => unit

  @send external param: (t, string, paramHandler) => unit = "param"
  @deprecated("deprecated as of v4.11.0")
  @send external defineParamBehavior: ((string, 'a) => paramHandler) => unit = "param"

  @send external route: string => t = "route"
}

@send external useRouter: (express, Router.t) => unit = "use"
@send external useRouterWithPath: (express, string, Router.t) => unit = "use"
// @send external useRouter: (express, ~router: Router.t, ~path: string=?) => unit = "use"