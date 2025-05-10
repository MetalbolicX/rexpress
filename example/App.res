open Express

let app = express()

let router = Router.make()

router->Router.use((req, _res, next) => {
  Console.log(req)
  next()
})

router->Router.useWithError((err, _req, res, _next) => {
  Console.error(err)
  let _ = res->setStatus(InternalServerError)->endWithData("An error occured")
})

app->useRouterWithPath("/someRoute", router)
// app->useRouter(router, ~path="/someRoute")
app->use(jsonMiddleware())

app->get(String("/"), (_req, res) => {
  let _ = res->setStatus(OK)->json({"ok": true})
})

app->post(String("/ping"), (req, res) => {
  let body = req->body
  let _ = switch body["name"]->Js.Nullable.toOption {
  | Some(name) => res->setStatus(OK)->json({"message": `Hello ${name}`})
  | None => res->setStatus(BadRequest)->json({"error": `Missing name`})
  }
})

app->all("/allRoute", (_req, res) => {
  res->setStatus(OK)->json({"ok": true})->ignore
})

app->useWithError((err, _req, res, _next) => {
  Console.error(err)
  let _ = res->setStatus(InternalServerError)->endWithData("An error occured")
})

let port = 8081
app->listen(~port=port, ~fn=_  => {
  Console.log(`Listening on http://localhost:${port->Belt.Int.toString}`)
})->ignore