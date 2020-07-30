import UserChannel from "../../components/channel/userChannel";

const SELECTOR = {
  appLayout: "body.app-layout.authenticated.KeywordController.index",
};

document.addEventListener("DOMContentLoaded", () => {
  const isAppLayout = document.querySelector(SELECTOR.appLayout) !== null;

  if (isAppLayout) {
    new UserChannel();
  }
});
