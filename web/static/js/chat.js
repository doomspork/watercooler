class Chat {

  static init(current_user, socket){
    var $messages     = $("#messages")
    var $input        = $("#message-input")
    var guardianToken = $("meta[name=\"guardian_token\"]").attr("content")
    var uid           = $("meta[name=\"uid\"]").attr("content")

    var chan = socket.channel("room:lobby", {user: uid, guardian_token: guardianToken})

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
      let avatar           = msg.avatar
      let body             = this.checkMentions(current_user, msg.body)
      let username         = msg.username
      let message          = this.messageTemplate(avatar, body, username)

      $messages.append(message)

      scrollTo(0, document.body.scrollHeight)
    })

    chan.on("user:entered", msg => {
      var username = msg.user
      $messages.append(`<div class="row"><div class="col-sm-12"><b><i>${username} entered the lobby</i></b></div></div>`)
    })

    chan.on("user:exited", msg => {
      var username = msg.user
      $messages.append(`<div class="row"><div class="col-sm-12"><b><i>${username} left the lobby</i></b></div></div>`)
    })
  }

  static checkMentions(username, body) {
    let index = body.toLowerCase().indexOf(username)
    if (index >= 0) {
      let length = index + username.length
      let token  = body.substring(index, length)
      body = body.replace(token, `<b>${token}</b>`)
      $.playSound("http://www.noiseaddicts.com/samples_1w72b820/3724")
    }
    return body
  }

  static messageTemplate(avatar, body, username) {
return(`<div class="row"><div class="col-sm-1 pull-left"><img width="50" height="50" src="${avatar}" class="identicon"></div><div class="col-sm-11 pull-left"><div class="row"><div class="col-sm-12"><strong class="primary-font">${username}</strong></div></div><div class="row"><div class="col-sm-12"><p>${body}</p></div></div></div></div>`)
  }
}

export default Chat
