let get_interface () =
  match Sys.getenv_opt "INTERFACE" with
  | Some interface -> interface
  | None -> (
      match Sys.getenv_opt "WEBSITE_SITE_NAME" with
      | Some _ -> "0.0.0.0" (* Azure App Service - allows external connections *)
      | None -> "127.0.0.1" (* Local development - secure default *))

let get_port () =
  match Sys.getenv_opt "PORT" with
  | Some port -> int_of_string port 
  | None -> (
      match Sys.getenv_opt "WEBSITE_SITE_NAME" with
      | Some _ -> 80  (* Azure App Service - allows external connections *)
      | None -> 8080 (* Local development - secure default *))

let () =
  Dream.run ~interface:(get_interface ()) ~port:(get_port ()) (fun _ ->
      Dream.html "Hello, world!")
