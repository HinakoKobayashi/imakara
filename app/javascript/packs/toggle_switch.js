$(document).on('turbolinks:load', function() {
  // トグルスイッチの変更イベント
  $('#postTypeToggle').change(function() {
    var isChecked = $(this).is(':checked');

    // トグルがオンかオフかによって適切なボタンを切り替え
    if (isChecked) {
      $('#draftButton').removeClass('d-none');   // 下書き保存ボタンを表示
      $('#publishButton').addClass('d-none');    // 公開するボタンを非表示
    } else {
      $('#draftButton').addClass('d-none');      // 下書き保存ボタンを非表示
      $('#publishButton').removeClass('d-none'); // 公開するボタンを表示
    }
  });

  // 初期設定：トグルの状態に応じたボタンを表示
  $('#postTypeToggle').change();
});
