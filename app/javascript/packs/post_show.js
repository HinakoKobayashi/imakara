// いいね・コメント非同期
document.addEventListener('DOMContentLoaded', function() {
  document.querySelectorAll('.favorite-action').forEach(button => {
    button.addEventListener('click', function(e) {
      e.preventDefault();
      var postId = this.dataset.postId;

      fetch('/posts/' + postId + '/favorite', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
        },
        body: JSON.stringify({ post_id: postId })
      })
      .then(response => response.json())
      .then(data => {
        console.log(data);
        // ここでいいねの状態を更新する処理を記述
      })
      .catch(error => {
        console.error('Error:', error);
      });
    });
  });
});