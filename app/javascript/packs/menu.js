// javascript/packs/menu.js
import "jquery";  // jQuery をインポートする
document.addEventListener('DOMContentLoaded', function () {
  var menuBtn = $('.menu-btn');  // jQuery を使って .menu-btn を選択
  var menu = $('.menu');  // jQuery を使って .menu を選択

  if (menuBtn.length > 0) {
    menuBtn.on('click', function () {
      menu.toggleClass('show');
    });
  }
});