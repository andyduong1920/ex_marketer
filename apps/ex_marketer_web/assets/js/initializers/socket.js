import socket from "../components/socket";

const SELECTOR = {
  appLayout: "body.app-layout.authenticated",
};

document.addEventListener("DOMContentLoaded", () => {
  const isAppLayout = document.querySelector(SELECTOR.appLayout) !== null;

  if (isAppLayout) {
    socket.connect();
  }
});
