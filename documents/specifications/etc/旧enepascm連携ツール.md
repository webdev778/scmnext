旧enepascm連携機能ツールについて
================================

概要
----

### 目的

新システムについては機能を段階的に移行するため、実装が完了するまでは旧enepascm(以下レガシー)と平行稼働することになるが、
レガシーのデータ、特にマスター系のデータについては、

* 移行作業の円滑化
* 運用サイドにおける2重メンテナンスの回避

のために、レガシー、新システム間での連携を行う必要がある。
また、その際、個々にに連携用のプログラム作成する手間を極力避けるため、レガシー、新システム間の連携用を行うために連携機能ツールを作成する。

### 概要

````puml

database legacy as "レガシーDB"

rectangle "連携機能ツール" {
  component legacy_tables_pg as "レガシー定義情報作成処理"
  component converter_pg as "変換定義情報テンプレート作成処理プログラム"
  file converter as "変換定義ファイル(yaml)"
  file legacy_tables as "レガシー定義情報ファイル(yaml)"
  component mainbatch as "連携バッチ"
}

database new as "新システムDB"

legacy -> mainbatch : 内容を取得
mainbatch -> new : 定義情報に基づいて変換し出力

converter -do-> mainbatch : 変換定義を取得
legacy_tables -do-> mainbatch : レガシーのテーブル情報を取得

legacy -> legacy_tables_pg : 定義情報を参照
legacy_tables_pg -do-> legacy_tables : レガシー定義情報作成処理
converter_pg -do-> converter : テンプレート作成
````

#### 主処理

連携機能ツールはその主たる目的であるデータ連携を行うバッチプログラム(以下連携バッチ)を主たる構成要素とする。連携バッチは、新システムのモデル1つごとに作成される変換定義ファイル(yaml)に基づいて旧システムの定義情報をレガシー定義情報ファイル(yaml)から取得し、新システムへ変換する。

#### 周辺処理

##### レガシー定義情報作成処理

レガシーのテーブルについて、変換プログラムで使用するために定義情報(yaml)を生成するレガシー定義情報作成処理プログラムを作成する。

##### 変換定義情報テンプレート作成処理

レガシーから新システムへのデータ変換を行うための変換定義情報を使用するが、この定義情報の雛形を作成するために変換定義情報テンプレート作成処理プログラムを作成する。

参照ファイルについて
--------------------

### レガシー定義情報

レガシー定義情報には旧システムのテーブル定義情報を記述する。記述する内容は以下の通りである。

* 縦横テーブルか通常のテーブルかの区分情報
* テーブル名
* フィールド名

#### 配置

config/legacy_convert/legacy_tables/[テーブル名].yml

#### ファイル内容サンプル

```yaml
---
:table_name: tbl_facility # テーブル名を記載
:table_type: :key_value   # テーブルの種別、縦横の場合はkey_value,通常のテーブルはsimple
:fields: # 以下に、配列形式でフィールド名を列挙
- facility_name
- supplying_point_number
- tbl_contract_customer_id
```

### 変換定義情報

変換定義情報にはレガシーから新システムのデータ変換方法などを記述する。記述する内容は以下のとおりである。

* 変換処理実施の有無
* 変換処理時にtruncateを実施するかの有無
* モデル名
* 変換定義(取得元や変換先後に格納するフィールドをSQLライクなyamlで記述)
* その他データ定義(レガシー変換以外で固定的にデータ登録を行う場合)

#### 配置

config/legacy_convert/converter/[クラス名(スネークケース)].yml
(尚、名前空間が定義されている場合は、名前空間単位でディレクトリを作成する)

#### ファイル内容サンプル

```yaml
---
:skip: false                    # 処理対象とするか否か
:truncate: true                 # 変換処理前にTRUNCATEするか否か
:model_class: District          # 対象となるモデルクラス
:sources:                       # 変換元の定義(unionしたい場合はそれごとにfieds,from,where等を作成する)
- :fields:                      # 登録先をkey登録元を値とするハッシュ(尚、変換元はsqlとして評価される)
    id: tbl_district.id
    code: SUBSTRING(tbl_district.district_code, 5, 1)
    is_partial_included: 'TRUE' # 定数を使用したい場合はシングルクォートで囲う
    updated_at: tbl_district.modified
    updated_by: acc.id
  :from: tbl_district           # 変換元のテーブル名
  :where: tbl_district.id < 10  # 変換元を絞りたい場合はwhereで制御する
  :joins:                       # 結合したい場合はjoinsをしたいテーブルごとに配列で定義する
  - :table: tbl_account         # テーブル名
    :type: inner                # 結合の種別(inner or outer)
    :on: acc.id = tbl_district.tbl_account_id # 結合条件
    :as: acc                    # 別名(任意)
:extra:                         # 外部テーブル以外のデータを登録する場合はextraを定義する
- :cond:                        # sourcesで登録されたデータに対し更新をかけたい場合は、こちらで条件を定義する。条件を指定しない場合は新規登録扱いになる
    id: 1
  :fields:                      # 登録先をkey登録元を値とするハッシュ。なお、登録先のフィールド名が存在しない場合は、ActiveStorageのファイルと看做してconfig/legacy_convert以下の相対パスに置かれたファイルのアップロードを試みる
    dlt_host: https://pu00.www6.tepco.co.jp
    dlt_path: "/LNXWPWSS01OH/LNXWPWSS01I"
```

コマンド
--------

基本的に各プログラムはrakeタスクで構成する。

### 主処理

```sh
rails legacy:convert [TARGET=/some/file/path]
```

環境変数TARGETで変換定義情報のパス名を指定した場合、当該変換定義のみを処理する。指定しない場合は、すべての変換定義を処理する。

### 変換定義情報テンプレート作成処理

```sh
rails legacy:generate:converter
```

オプションなし。実行するとモデルクラス(ActiveRecordを継承したクラス)全てに対して変換定義情報を作成する。すでに変換定義情報ファイルがある場合、既存の記述はそのまま保持されるが以下に留意する必要がある。

* フィールドが追加された場合、そのフィールドの変換定義情報がブランクで作成される
* フィールドが削除された場合、そのフィールドの変換定義情報は削除される

また、現状はsourcesが一つも定義されていない場合はsourcesに雛形を作成してしまうため、extraのみの場合は留意する必要がある。

### レガシー定義情報作成処理

```sh
rails legacy:generate:legacy_tables
```

オプションなし。実行するとレガシーのテーブルを読み込み定義情報を作成する。なお、縦横テーブルの判別のため、tbl_sys_item_meta_dataを読み込むため、その接続先に当該テーブルがない場合は、例外で落ちる。