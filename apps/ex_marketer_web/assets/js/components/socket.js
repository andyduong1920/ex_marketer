import { Socket } from "phoenix";

const socket = new Socket("/socket", {
  params: { token: window.userSocketToken },
});

export default socket;
