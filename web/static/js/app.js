import "phoenix_html"

import socket from "./socket"
import Chat from "./chat"

let login = $("div.login")

if(!login.length) {
  let username = $("meta[name='username']").attr("content")
  socket.connect()
  Chat.init(username, socket)
}
