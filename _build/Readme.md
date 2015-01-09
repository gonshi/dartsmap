# Readme

## init
* npm install
* bower install


##### dev
* 開発用タスク

#### build
* production版のファイルを作成
* destinationは1階層下のディレクトリ(開発ディレクトリは/\_buildを想定)

### sass
- src/sass: sassファイルを管理
- base: reset, mixin, 変数などを管理
- \_value.scss: グローバル変数をここで定義


### Jade
- includeファイルはすべて'/jade/include'以下にまとめて管理する
- mixinファイルはすべて'/jade/mixin'以下にまとめて管理する
