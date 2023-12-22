// これは廃棄
document.addEventListener('turbolinks:load', function() {
  document.querySelectorAll('input[name="post_filter"]').forEach(function(filter) {
    filter.addEventListener('change', function() {
      var postsPublicized = document.getElementById('posts_publicized');
      var postsDraft = document.getElementById('posts_draft');
      var postsUnpublicized = document.getElementById('posts_unpublicized');

      if(postsPublicized && postsDraft && postsUnpublicized) {
        postsPublicized.style.display = 'none';
        postsDraft.style.display = 'none';
        postsUnpublicized.style.display = 'none';

        if (document.getElementById('filter_publicized').checked) {
          postsPublicized.style.display = 'block';
        } else if (document.getElementById('filter_draft').checked) {
          postsDraft.style.display = 'block';
        } else if (document.getElementById('filter_unpublicized').checked) {
          postsUnpublicized.style.display = 'block';
        }
      }
    });
  });
});
