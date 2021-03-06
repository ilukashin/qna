import consumer from "./consumer"

consumer.subscriptions.create("CommentsChannel", {
    connected() {
        this.perform('follow', gon.params)
    },

    received(data) {
        if (!(gon.user === data.user_id)) {
          let commentHtml = require('templates/comment.hbs')(data)
          $('#' + data.commentable_type.toLowerCase() + '-' + data.commentable_id + ' .comments').append(commentHtml);
        }
    }
});
