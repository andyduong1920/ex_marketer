import socket from "./socket";

class LobbyRoomChannel {
  constructor() {
    this.channel = socket.channel(`room:lobby`, {});

    this._setup();
  }

  _setup() {
    this.channel
      .join()
      .receive("ok", (resp) => {
        this._bindChannelEvent();
      })
      .receive("error", (resp) => {
        throw resp;
      });
  }

  _bindChannelEvent() {
    this.channel.on("user_joined", (message) => {
      console.log("message", message);
    });
  }
}

export default LobbyRoomChannel;
