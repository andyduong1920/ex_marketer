import socket from "../socket";

class UserChannel {
  constructor() {
    this.channel = socket.channel(`user:${window.userId}`, {});

    this._setup();
  }

  _setup() {
    this.channel
      .join()
      .receive("ok", (resp) => {
        this.channel.on("keyword_successed", (message) => {
          console.log(message);
        });

        this.channel.on("keyword_fail", (message) => {
          console.log(message);
        });
      })
      .receive("error", (resp) => {
        throw resp;
      });
  }
}

export default UserChannel;
