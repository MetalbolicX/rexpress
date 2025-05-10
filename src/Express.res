type express

// "default" &  seem to conflict a bit right now
// https://github.com/rescript-lang/rescript-compiler/issues/5004
@module external expressCjs: unit => express = "express"
@module("express") external express: unit => express = "default"

type req
type res

// type middleware = (req, res, unit => unit) => unit
type middleware = (req, res, unit => unit, ~error: exn=?) => unit
// type middlewareWithError = (Js.Exn.t, req, res, unit => unit) => unit
type handler = (req, res) => unit
type asyncHandler = (req, res) => promise<unit>

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

// req properties
@get external baseUrl: req => string = "baseUrl"
@get external body: req => 'a = "body"
@get external cookies: req => 'a = "cookies"
@get external fresh: req => bool = "fresh"
@get external hostname: req => string = "hostname"
@get external ip: req => string = "ip"
@get external ips: req => array<string> = "ips"
@get external method: req => method = "method"
@get external originalUrl: req => string = "originalUrl"
@get external params: req => 'a = "params"
@get external path: req => string = "path"
@get external protocol: req => string = "protocol"
@get external query: req => 'a = "query"
@get external route: req => 'a = "route"
@get external secure: req => bool = "secure"
@get external signedCookies: req => 'a = "signedCookies"
@get external stale: req => bool = "stale"
@get external subdomains: req => array<string> = "subdomains"
@get external xhr: req => bool = "xhr"

// This is a bit unfortunate, as it breaks the zero-cost philosophy,
// but the `string | false` signature doesn't play well with an ML type-system
external asString: 'a => string = "%identity"
let parseValue = value =>
  switch Js.typeof(value) {
  | "boolean" => None
  | _ => Some(value->asString)
  }

// req methods
@send external accepts: (req, array<string>) => 'a = "accepts"
@send external acceptsCharset: (req, array<string>) => 'a = "acceptsCharset"
@send external acceptsEncodings: (req, array<string>) => 'a = "acceptsEncodings"
@send external acceptsLanguages: (req, array<string>) => 'a = "acceptsLanguages"

let accepts = (req, value) => req->accepts(value)->parseValue
let acceptsCharset = (req, value) => req->acceptsCharset(value)->parseValue
let acceptsEncodings = (req, value) => req->acceptsEncodings(value)->parseValue
let acceptsLanguages = (req, value) => req->acceptsLanguages(value)->parseValue

@send external getRequestHeader: (req, string) => option<string> = "get"
@send external is: (req, string) => 'a = "is"

let is = (req, value) => req->is(value)->parseValue

@send external param: (req, string) => option<string> = "param"

// res properties
@get external headersSent: res => bool = "headersSent"
@get external locals: res => {..} = "locals"

// res methods
@send external append: (res, string, string) => res = "append"
@send external attachment: (res, ~filename: string=?) => res = "attachment"
@send external cookie: (res, ~name: string, ~value: string) => res = "cookie"
@send external cookieWithOptions: (res, ~name: string, ~value: string, {..}) => res = "cookie"
@send external clearCookie: (res, string) => res = "clearCookie"
@send external download: (res, ~path: string) => res = "download"
@send external downloadWithFilename: (res, ~path: string, ~filename: string) => res = "download"
@send external end: res => res = "end"
@send external endWithData: (res, 'a) => res = "end"
@send external endWithDataAndEncoding: (res, 'a, ~encoding: string) => res = "end"
@send external format: (res, {..}) => res = "format"
@send external getResponseHeader: (res, string) => option<string> = "get"
@send external json: (res, 'a) => res = "json"
@send external jsonp: (res, 'a) => res = "jsonp"
@send external links: (res, Js.Dict.t<string>) => res = "links"
@send external location: (res, string) => res = "location"
@send external redirect: (res, string) => res = "redirect"
@send external redirectWithStatusCode: (res, ~statusCode: int, string) => res = "redirect"
@send external render: (res, string, ~locals: {..}=?, ~fn: (exn, string) => unit=?) => unit = "render"
@send external send: (res, 'a) => res = "send"
@send external sendFile: (res, string) => res = "sendFile"
@send external sendFileWithOptions: (res, string, {..}) => res = "sendFile"
@send external setStatus: (res, int) => res = "status"
@send external sendStatus: (res, int) => res = "sendStatus"
@send external setRes: (res, string, string) => unit = "set"
@send external type_: (res, string) => string = "type"
@send external vary: (res, string) => res = "vary"

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
let status: (res, httpStatus) => res = (response, code) => response->setStatus(getStatusCode(code))

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

  type paramHandler = (req, res, unit => unit, string, string) => unit

  @send external param: (t, string, paramHandler) => unit = "param"
  @deprecated("deprecated as of v4.11.0")
  @send external defineParamBehavior: ((string, 'a) => paramHandler) => unit = "param"

  @send external route: string => t = "route"
}

@send external useRouter: (express, Router.t) => unit = "use"
@send external useRouterWithPath: (express, string, Router.t) => unit = "use"
// @send external useRouter: (express, ~router: Router.t, ~path: string=?) => unit = "use"