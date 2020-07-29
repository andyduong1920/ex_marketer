import socket from "../components/socket";
import LobbyRoomChannel from "../components/lobby_room_channel";

const SELECTOR = {
  appLayout: "body.app-layout.authenticated",
};

document.addEventListener("DOMContentLoaded", () => {
  const isAppLayout = document.querySelector(SELECTOR.appLayout) !== null;

  if (isAppLayout) {
    socket.connect();

    new LobbyRoomChannel();
  }
});
