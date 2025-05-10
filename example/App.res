open Express

let app = express()

let router = Router.make()

// router->Router.use((req, _res, next, ~error=_err) => {
//   Console.log(req)
//   next()
// })

// router->Router.useWithError((err, _req, res, _next) => {
//   Console.error(err)
//   let _ = res->setStatus(InternalServerError)->endWithData("An error occured")
// })

app->useRouterWithPath("/someRoute", router)
// app->useRouter(~router=router, ~path="/someRoute")
app->use(jsonMiddleware())

app->get(String("/"), (_req, res) => {
  res->status(OK)->json({"ok": true})->ignore
})

type pingBody = {
  name?: string,
}

app->post(String("/ping"), (req, res) => {
  let content: pingBody = req->body
  switch content.name {
  | Some(n) => res->status(OK)->json({"message": `Hello ${n}`})->ignore
  | None => res->status(BadRequest)->json({"error": `Missing name`})->ignore
  }
})

app->all(String("/allRoute"), (_req, res) => {
  res->status(OK)->json({"ok": true})->ignore
})

// app->useWithError((err, _req, res, _next) => {
app->use((_req, res, _next, ~error=Exn.raiseError("There was an error")) => {
  Console.error(error)
  let _ = res->status(InternalServerError)->endWithData("An error occured")
})

let port = 8081
app->listen(~port=port, ~fn=_  => {
  Console.log(`Listening on http://localhost:${port->Belt.Int.toString}`)
})->ignore