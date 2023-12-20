$(document).on('turbolinks:load', function () {

  // メインタブの初期化
  $('.main-tab-content > div').hide(); // すべてのメインタブコンテンツを非表示に
  $('.main-tab-content > div:first').show(); // 最初のメインタブコンテンツのみ表示
  $('.main-tab-buttons span').removeClass('active'); // すべてのタブからactiveクラスを削除
  $('.main-tab-buttons .content1').addClass('active'); // 最初のタブにactiveクラスを追加

  // メインタブのクリックイベント
  $('.main-tab-buttons span').click(function() {
    var index = $('.main-tab-buttons span').index(this);
    $('.main-tab-content > div').hide(); // すべてのコンテンツを非表示に
    $('.main-tab-content > div').eq(index).fadeIn(800); // 選択されたコンテンツを表示
    $('.main-tab-buttons span').removeClass('active'); // 他のすべてのタブからactiveクラスを削除
    $(this).addClass('active'); // 選択されたタブにactiveクラスを追加
    $('.main-tab-buttons span').removeClass('main-active'); // すべてのタブからmain-activeクラスを削除
    $(this).addClass('main-active'); //選択されたタブにmain-activeクラスを追加
  });
});

$(document).on('turbolinks:load', function () {
  // マイページのサブタブの初期化
  $('.post-tab-content > div').hide(); // すべてのサブタブコンテンツを非表示に
  $('.post-tab-content > div:first').show(); // 最初のサブタブコンテンツのみ表示
  $('.post-tab-buttons span').removeClass('active'); // すべてのサブタブからactiveクラスを削除
  $('.post-tab-buttons .post-content1').addClass('active'); // 最初のサブタブにactiveクラスを追加

  // サブタブのクリックイベント
  $('.post-tab-buttons span').click(function() {
    var index = $('.post-tab-buttons span').index(this);
    $('.post-tab-content > div').hide(); // すべてのコンテンツを非表示に
    $('.post-tab-content > div').eq(index).fadeIn(800); // 選択されたコンテンツを表示
    $('.post-tab-buttons span').removeClass('active'); // 他のすべてのタブからactiveクラスを削除
    $(this).addClass('active'); // 選択されたタブにactiveクラスを追加
    $('.post-tab-buttons span').removeClass('post-active'); // すべてのタブからpost-activeクラスを削除
    $(this).addClass('post-active'); //選択されたタブにpost-activeクラスを追加
  });
});
