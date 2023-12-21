$(document).on('turbolinks:load', function () {
  $('.menu-trigger').on('click', function(event) {
    $(this).toggleClass('active');
    $('#sp-menu').fadeToggle();
    $('#overlay').fadeToggle(); // オーバーレイの表示・非表示を切り替え
    event.preventDefault();
  });

  // オーバーレイがクリックされたときのイベント
  $('#overlay').on('click', function() {
    $('.menu-trigger').removeClass('active');
    $('#sp-menu').fadeOut();
    $(this).fadeOut(); // オーバーレイを非表示にする
  });
});

