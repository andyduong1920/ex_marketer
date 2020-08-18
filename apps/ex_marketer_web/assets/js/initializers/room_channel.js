import RoomChannel from "../components/channel/roomChannel";

const SELECTOR = {
  appLayout: "body.app-layout.authenticated",
};

document.addEventListener("DOMContentLoaded", () => {
  const isAppLayout = document.querySelector(SELECTOR.appLayout) !== null;

  if (isAppLayout) {
    new RoomChannel();
  }
});
