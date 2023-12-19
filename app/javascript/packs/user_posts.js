// これは廃棄
document.addEventListener('turbolinks:load', function() {
  document.querySelectorAll('input[name="post_filter"]').forEach(function(filter) {
    filter.addEventListener('change', function() {
      var postsPublished = document.getElementById('posts_published');
      var postsDraft = document.getElementById('posts_draft');
      var postsUnpublished = document.getElementById('posts_unpublished');

      if(postsPublished && postsDraft && postsUnpublished) {
        postsPublished.style.display = 'none';
        postsDraft.style.display = 'none';
        postsUnpublished.style.display = 'none';

        if (document.getElementById('filter_published').checked) {
          postsPublished.style.display = 'block';
        } else if (document.getElementById('filter_draft').checked) {
          postsDraft.style.display = 'block';
        } else if (document.getElementById('filter_unpublished').checked) {
          postsUnpublished.style.display = 'block';
        }
      }
    });
  });
});
