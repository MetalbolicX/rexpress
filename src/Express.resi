/** The main Express application type. */
type express

/** Create an Express app using CommonJS import. */
@module external expressCjs: unit => express = "express"

/** Create an Express app using ES module import. */
@module("express") external express: unit => express = "default"

/** The Express request object. */
type request

/** The Express response object. */
type response

/** Synchronous middleware function type. */
type middleware = (request, response, unit => unit) => unit

/** Synchronous error-handling middleware function type. */
type errorMiddleware = (exn, request, response, unit => unit) => unit

/** Asynchronous middleware function type. */
type asyncMiddleware = (request, response, unit => unit) => promise<unit>

/** Asynchronous error-handling middleware function type. */
type asyncErrorMiddleware = (exn, request, response, unit => unit) => promise<unit>

/** Synchronous route handler type. */
type handler = (request, response) => unit

/** Asynchronous route handler type. */
type asyncHandler = (request, response) => promise<unit>

/** Convert an Express app to middleware. */
external asMiddleware: express => middleware = "%identity"

/** JSON body parser middleware. */
@module("express") external jsonParser: (~options: {..}=?) => middleware = "json"

/** Raw body parser middleware. */
@module("express") external rawParser: (~options: {..}=?) => middleware = "raw"

/** Text body parser middleware. */
@module("express") external text: (~options: {..}=?) => middleware = "text"

/** URL-encoded body parser middleware. */
@module("express") external urlencoded: (~options: {..}=?) => middleware = "urlencoded"

/** Static file serving middleware. */
@module("express") external static: (string, ~options: {..}=?) => middleware = "static"

/**
  Use middleware or error handlers on the app.
  @param express The Express app.
  @param middlewares The middleware or error handlers to use.
  @param path Optional path to mount the middleware.
*/
@send
external use: (
  express,
  @unwrap
  [
    | #Mid(middleware)
    | #AsyncMid(asyncMiddleware)
    | #Err(errorMiddleware)
    | #AsyncErr(asyncErrorMiddleware)
  ],
  ~path: string=?,
) => unit = "use"

/** Set a setting on the Express app. */
@send external set: (express, string, string) => unit = "set"

/** Route type for API endpoints. */
@unboxed
type apiRoute =
  | Path(string)
  | PathMatch(RegExp.t)
  | ListPath(array<string>)

/** HTTP method type. */
type method = [#GET | #POST | #PUT | #DELETE | #PATCH]

/** API handler type, synchronous or asynchronous. */
type apiHandler =
  | Handler(handler)
  | AsyncHandler(asyncHandler)

/**
  Register a GET route handler.
  @param express The Express app.
  @param apiRoute The route path or regex.
  @param apiHandler The handler function.
  @param middlewares Optional array of middleware.
*/
let get: (
  express,
  apiRoute,
  apiHandler,
  ~middlewares: array<[#Mid(middleware) | #AsyncMid(asyncMiddleware)]>=?,
) => unit

/**
  Register a POST route handler.
  @param express The Express app.
  @param apiRoute The route path or regex.
  @param apiHandler The handler function.
  @param middlewares Optional array of middleware.
*/
let post: (
  express,
  apiRoute,
  apiHandler,
  ~middlewares: array<[#Mid(middleware) | #AsyncMid(asyncMiddleware)]>=?,
) => unit

/**
  Register a PUT route handler.
  @param express The Express app.
  @param apiRoute The route path or regex.
  @param apiHandler The handler function.
  @param middlewares Optional array of middleware.
*/
let put: (
  express,
  apiRoute,
  apiHandler,
  ~middlewares: array<[#Mid(middleware) | #AsyncMid(asyncMiddleware)]>=?,
) => unit

/**
  Register a DELETE route handler.
  @param express The Express app.
  @param apiRoute The route path or regex.
  @param apiHandler The handler function.
  @param middlewares Optional array of middleware.
*/
let delete: (
  express,
  apiRoute,
  apiHandler,
  ~middlewares: array<[#Mid(middleware) | #AsyncMid(asyncMiddleware)]>=?,
) => unit

/**
  Register a PATCH route handler.
  @param express The Express app.
  @param apiRoute The route path or regex.
  @param apiHandler The handler function.
  @param middlewares Optional array of middleware.
*/
let patch: (
  express,
  apiRoute,
  apiHandler,
  ~middlewares: array<[#Mid(middleware) | #AsyncMid(asyncMiddleware)]>=?,
) => unit

/**
  Register a route handler for all HTTP methods.
  @param express The Express app.
  @param apiRoute The route path or regex.
  @param apiHandler The handler function.
  @param middlewares Optional array of middleware.
*/
let all: (
  express,
  apiRoute,
  apiHandler,
  ~middlewares: array<[#Mid(middleware) | #AsyncMid(asyncMiddleware)]>=?,
) => unit

/** Enable a setting on the Express app. */
@send external enable: (express, string) => unit = "enable"

/** Check if a setting is enabled on the Express app. */
@send external enabled: (express, string) => bool = "enabled"

/** Disable a setting on the Express app. */
@send external disable: (express, string) => unit = "disable"

/** Express app properties */
@get external locals: express => {..} = "locals"
@get external mountpath: express => string = "mountpath"

/** Express app events */
@send external on: (express, string, 'a => unit) => unit = "on"

/** The Express server type. */
type server

/**
  Start the Express server.
  @param express The Express app.
  @param port Optional port number.
  @param host Optional host.
  @param fn Optional callback for errors.
*/
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

/**
  Check if the request accepts the given content types.
  @param request The Express request object.
  @param types Array of content types to check.
  @return The matched content type, or None if not accepted.
*/
let accepts: (request, array<string>) => option<string>

/**
  Check if the request accepts the given character sets.
  @param request The Express request object.
  @param charsets Array of character sets to check.
  @return The matched character set, or None if not accepted.
*/
let acceptsCharset: (request, array<string>) => option<string>

/**
  Check if the request accepts the given encodings.
  @param request The Express request object.
  @param encodings Array of encodings to check.
  @return The matched encoding, or None if not accepted.
*/
let acceptsEncodings: (request, array<string>) => option<string>

/**
  Check if the request accepts the given languages.
  @param request The Express request object.
  @param languages Array of languages to check.
  @return The matched language, or None if not accepted.
*/
let acceptsLanguages: (request, array<string>) => option<string>

@send external getRequestHeader: (request, string) => option<string> = "get"

/**
  Check if the request matches the given content type.
  @param request The Express request object.
  @param type The content type to check.
  @return The matched type, or None if not matched.
*/
let is: (request, string) => option<string>

@send external param: (request, string) => option<string> = "param"

// response properties
@get external headersSent: response => bool = "headersSent"
@get external localsRes: response => {..} = "locals"

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

/** Variant type for HTTP status codes. */
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

/**
  Set the HTTP status code on the response.
  @param response The Express response object.
  @param httpStatus The status code variant.
  @return The response object.
*/
let status: (response, httpStatus) => response

/**
  Set the HTTP status code and send its string representation as the response body.
  @param response The Express response object.
  @param httpStatus The status code variant.
  @return The response object.
*/
let sendStatus: (response, httpStatus) => response

/** Express Router module. */
module Router: {
  /** The Express Router type. */
  type t

  /** Create a new Express Router instance. */
  @module("express") external make: (~options: {..}=?) => t = "Router"

  /**
    Use middleware or error handlers on the router.
    @param t The Router instance.
    @param middlewares The middleware or error handlers to use.
    @param path Optional path to mount the middleware.
  */
  @send
  external use: (
    t,
    @unwrap
    [
      | #Mid(middleware)
      | #AsyncMid(asyncMiddleware)
      | #Err(errorMiddleware)
      | #AsyncErr(asyncErrorMiddleware)
    ],
    ~path: string=?,
  ) => unit = "use"

  /**
    Register a GET route handler.
    @param t The Router instance.
    @param apiRoute The route path or regex.
    @param apiHandler The handler function.
    @param middlewares Optional array of middleware.
  */
  let get: (
    t,
    apiRoute,
    apiHandler,
    ~middlewares: array<[#Mid(middleware) | #AsyncMid(asyncMiddleware)]>=?,
  ) => unit

  /**
    Register a POST route handler.
    @param t The Router instance.
    @param apiRoute The route path or regex.
    @param apiHandler The handler function.
    @param middlewares Optional array of middleware.
  */
  let post: (
    t,
    apiRoute,
    apiHandler,
    ~middlewares: array<[#Mid(middleware) | #AsyncMid(asyncMiddleware)]>=?,
  ) => unit

  /**
    Register a PUT route handler.
    @param t The Router instance.
    @param apiRoute The route path or regex.
    @param apiHandler The handler function.
    @param middlewares Optional array of middleware.
  */
  let put: (
    t,
    apiRoute,
    apiHandler,
    ~middlewares: array<[#Mid(middleware) | #AsyncMid(asyncMiddleware)]>=?,
  ) => unit

  /**
    Register a DELETE route handler.
    @param t The Router instance.
    @param apiRoute The route path or regex.
    @param apiHandler The handler function.
    @param middlewares Optional array of middleware.
  */
  let delete: (
    t,
    apiRoute,
    apiHandler,
    ~middlewares: array<[#Mid(middleware) | #AsyncMid(asyncMiddleware)]>=?,
  ) => unit

  /**
    Register a PATCH route handler.
    @param t The Router instance.
    @param apiRoute The route path or regex.
    @param apiHandler The handler function.
    @param middlewares Optional array of middleware.
  */
  let patch: (
    t,
    apiRoute,
    apiHandler,
    ~middlewares: array<[#Mid(middleware) | #AsyncMid(asyncMiddleware)]>=?,
  ) => unit

  /**
    Register a route handler for all HTTP methods.
    @param t The Router instance.
    @param apiRoute The route path or regex.
    @param apiHandler The handler function.
    @param middlewares Optional array of middleware.
  */
  let all: (
    t,
    apiRoute,
    apiHandler,
    ~middlewares: array<[#Mid(middleware) | #AsyncMid(asyncMiddleware)]>=?,
  ) => unit

  /** Enable a setting on the Router instance. */
  type paramHandler = (request, response, unit => unit, string, string) => unit

  /** Register a param handler on the router. */
  @send external param: (t, string, paramHandler) => unit = "param"

  /** Create a route on the router. */
  @send external route: string => t = "route"
}

/**
  Attach a Router to an Express app, optionally at a path.
  @param express The Express app.
  @param router The Router instance.
  @param path Optional path to mount the router.
*/
let useForRouter: (express, Router.t, ~path: string=?) => unit
