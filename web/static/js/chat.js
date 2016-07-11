class Chat {

  static init(current_user, socket){
    var $messages = $("#messages")
    var $input    = $("#message-input")

    var chan = socket.channel("room:lobby", { user: current_user })

    chan
      .join()
      .receive("ignore", () => console.log("auth error"))
      .receive("ok", () => console.log("connected"))
      .receive("timeout", () => console.log("Connection interruption"))

    chan.onError(e => console.log("something went wrong", e))
    chan.onClose(e => console.log("channel closed", e))

    $input.off("keypress").on("keypress", e => {
      if (e.keyCode == 13) {
        chan.push("new:msg", {user: current_user, body: $input.val()}, 10000)
        $input.val("")
      }
    })

    chan.on("new:msg", msg => {
      let user     = msg.user || "anonymous"
      let body     = msg.body
      let $message = $(this.messageTemplate(user, body))
      $message
        .find("canvas")
        .jdenticon(md5(user))
      $messages.append($message)

      this.checkMentions(current_user, msg.body)

      scrollTo(0, document.body.scrollHeight)
    })

    chan.on("user:entered", msg => {
      var username = msg.user || "anonymous"
      $messages.append(`<div class="row"><div class="col-sm-12"><b><i>${username} entered the lobby</i></b></div></div>`)
    })

    chan.on("user:exited", msg => {
      var username = msg.user || "anonymous"
      $messages.append(`<div class="row"><div class="col-sm-12"><b><i>${username} left the lobby</i></b></div></div>`)
    })
  }

  static checkMentions(username, body) {
    if (body.toLowerCase().indexOf(username) >= 0) {
      $.playSound("http://www.noiseaddicts.com/samples_1w72b820/3724")
    }
  }

  static messageTemplate(username, body) {
return(`<div class="row"><div class="col-sm-1 pull-left"><canvas width="50" height="50" class="identicon">${username}</canvas></div><div class="col-sm-11 pull-left"><div class="row"><div class="col-sm-12"><strong class="primary-font">${username}</strong></div></div><div class="row"><div class="col-sm-12"><p>${body}</p></div></div></div></div>`)
  }
}

export default Chat
