import socket from "../components/socket";
import LobbyRoomChannel from "../components/lobbyRoomChannel";

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
