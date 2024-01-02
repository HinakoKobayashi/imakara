document.addEventListener('turbolinks:load', function() {
  var tagInput = document.getElementById('post_tag_list');

  if (tagInput) {
    tagInput.addEventListener('input', function() {
      var tags = tagInput.value.split(/、/); // 全角読点で分割
      tags = tags.map(function(tag) {
        return tag.trim(); // トリムして余白を削除
      }).filter(function(tag) {
        return tag.length > 0; // 空のタグを除去
      });

      // ここで tags 配列を処理（例：タグの表示更新など）
    });
  }
});
