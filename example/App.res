open Express

let app = express()

let router = Router.make()

router->Router.get(Path("/hello"), Handler((_req, res) => {
  res->status(OK)->json({"message": "Hello from the Router!"})->ignore
}))

app->useForRouter(router, ~path="/api")
app->use(jsonMiddleware()->#Mid)

app->get(Path("/"), Handler((_req, res) => {
  res->status(OK)->json({"message": "Hello World!"})->ignore
}))

type pingBody = {
  name?: string,
}

app->post(Path("/ping"), Handler((req, res) => {
  let content: pingBody = req->body
  switch content.name {
  | Some(n) => res->status(OK)->json({"message": `Hello ${n}`})->ignore
  | None => res->status(BadRequest)->json({"error": `Missing name`})->ignore
  }
}))

app->use(#Mid(
  (_req, res, _next) => {
    res->status(InternalServerError)->end(~data="An error occured")->ignore
  },
))

let port = 8081
app->listen(~port=port, ~fn=_ => {
  Console.log(`Listening on http://localhost:${port->Belt.Int.toString}`)
})->ignore