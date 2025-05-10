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
// app->use(jsonMiddleware())
app->use(jsonMiddleware())

app->get(String("/"), (_req, res) => {
  res->setStatus(OK)->json({"ok": true})->ignore
})

type pingBody = {
  name?: string,
}

app->post(String("/ping"), (req, res) => {
  let content: pingBody = req->body
  switch content.name {
  | Some(n) => res->setStatus(OK)->json({"message": `Hello ${n}`})->ignore
  | None => res->setStatus(BadRequest)->json({"error": `Missing name`})->ignore
  }
})

app->all(String("/allRoute"), (_req, res) => {
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