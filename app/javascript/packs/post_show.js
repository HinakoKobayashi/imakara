document.addEventListener('DOMContentLoaded', function () {
  var postThumbnails = document.querySelectorAll('.post-thumbnail');

  postThumbnails.forEach(function (thumbnail) {
    thumbnail.addEventListener('click', function () {
      var postId = this.dataset.postId;

      // Ajaxリクエストを発行してshowアクションを呼び出し、モーダルを表示する
      Rails.ajax({
        type: 'GET',
        url: '/user/posts/' + postId,
        dataType: 'script'
      });
    });
  });
});