import socket from "../socket";
import { Presence } from "phoenix";
import { Alert } from "bootstrap.native/dist/bootstrap-native";

const SELECTOR = {
  notification: ".notification",
  alert: ".alert",
  onlineUser: ".online-user ul",
};

class RoomChannel {
  constructor() {
    this.channel = socket.channel(`room:lobby`, {});
    this.notification = document.querySelector(SELECTOR.notification);
    this.onlineUser = document.querySelector(SELECTOR.onlineUser);
    this.presence = new Presence(this.channel);

    this._setup();
  }

  _setup() {
    this.presence.onSync(() => this._renderOnlineUsers());

    this.channel
      .join()
      .receive("ok", (resp) => {
        this.channel.on("user_joined", (message) => {
          this._onUserJoined(message.email);
        });
      })
      .receive("error", (resp) => {
        throw resp;
      });
  }

  _onUserJoined(email) {
    this.notification.innerHTML = "";

    this.notification.insertAdjacentHTML(
      "afterbegin",
      this._alertContent(email)
    );

    let alert = this.notification.querySelector(SELECTOR.alert);

    new Alert(alert);
  }

  _alertContent(email) {
    return `<div class="alert alert-info alert-dismissible fade show" role="alert">
      <strong>${email}</strong> just login.

      <button type="button" class="close" data-dismiss="alert" aria-label="Close">
        <span aria-hidden="true">&times;</span>
      </button>
    </div>
    `;
  }

  _renderOnlineUsers() {
    let listUserTemplare = "";

    this.presence.list((id, { metas: metas }) => {
      const item = metas[0];

      listUserTemplare = listUserTemplare.concat(
        `<li>${item.email} - ${item.last_seen_at}</li>`
      );
    });

    this.onlineUser.innerHTML = listUserTemplare;
  }
}

export default RoomChannel;
