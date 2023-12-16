$(document).on('turbolinks:load', function () {
  // ページロード時にユーザー情報タブをアクティブにする
  $('.tab-buttons span').removeClass('active');
  $('.tab-buttons .content1').addClass('active');
  // タブのコンテンツを非表示にし、最初のコンテンツだけ表示する
  $('.tab-content > div').hide();
  $('.tab-content > div:first').show();

  // タブのボタンがクリックされた時の動作
  $('.tab-buttons span').click(function() {
    // 全てのタブコンテンツを非表示にし、クリックされたタブに関連するコンテンツを表示
    var index = $(this).index();
    $('.tab-content > div').hide();
    $('.tab-content > div').eq(index).fadeIn(800);
    $('.tab-buttons span').removeClass('active'); // 他のすべてのタブから.activeを削除
    $(this).addClass('active'); // クリックされたタブに.activeを追加
  });
});