/* 関係者向けデモ・パスワードゲート（カジュアル）
   sessionStorage に正しいハッシュが入っていなければ gate.html へリダイレクト */
(function () {
  var EXPECTED = '838a91acf0d88dcdb7648a295d5ddb7ae7dd59a31d6d7c445c6bb68cbde962ba';
  try {
    if (sessionStorage.getItem('rinran_demo_auth') !== EXPECTED) {
      // 相対パスでルートの gate.html へ
      var path = location.pathname;
      // docs/ 配下から飛ぶ場合に備えて prefix 計算
      var depth = (path.replace(/^\/+|\/+$/g, '').match(/\//g) || []).length;
      var prefix = '';
      // GitHub Pages の /rinran-demo/ サブパスを尊重する simple 戦略: gate.html は同階層を期待
      // docs/ から呼ばれた場合は ../gate.html
      if (/\/docs\//.test(path)) prefix = '../';
      location.replace(prefix + 'gate.html');
    }
  } catch (e) {
    // sessionStorage 不可ならゲートにフォールバック
    location.replace('gate.html');
  }
})();
