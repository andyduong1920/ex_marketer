import socket from "../socket";

const SELECTOR = {
  keywordList: ".list-keyword",
};

class UserChannel {
  constructor() {
    this.channel = socket.channel(`user:${window.userId}`, {});
    this.keywordList = document.querySelector(SELECTOR.keywordList);

    this._setup();
  }

  _setup() {
    this.channel
      .join()
      .receive("ok", (resp) => {
        this.channel.on("keyword_completed", (message) => {
          this._reDisplayKeyword(message.keyword_id, message.keyword_view);
        });
      })
      .receive("error", (resp) => {
        throw resp;
      });
  }

  _reDisplayKeyword(keyword_id, keyword_view) {
    const keywordCard = this.keywordList.querySelector(
      `#keyword-${keyword_id}`
    );

    if (keywordCard) {
      this.keywordList.removeChild(keywordCard);
    }

    this.keywordList.insertAdjacentHTML("afterbegin", keyword_view);
  }
}

export default UserChannel;
