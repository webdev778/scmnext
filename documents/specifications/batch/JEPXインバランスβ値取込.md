JEPXインバランスβ値取込
=======================

概要
----

JEPXのサイトよりインバランスβ値のExcelを取得し、関連テーブルへの登録・更新を行う

## 概要図

````puml
cloud JEPX {
  file "インバランスβ値ファイル" as input
}

rectangle SCM {
  (JEPXインバランスβ値取込) as (main)
  database "JEPXインバランスβ値" as output
}

input --> main : input
main --> output : output

````

## I/O

| 名称                    | 物理名               | 種類 | I/O種別 | 備考 |
|-------------------------|----------------------|------|---------|------|
| インバランスβ値ファイル | http://www.jepx.org/market/excel/imbalance_beta.xlsx | xlsx | I       |      |
| JEPXインバランスβ値     | jepx_imbalance_betas | DB   | O       |      |

## パラメータ

なし

処理詳細
--------

### STEP 1 取込処理

1. 指定されたURLよりxlsxファイルをダウンロードする
2. xlsxを読み込み、年、月、エリアごとにデータをDBに登録する。この際、同一年、月、エリアのデータが存在しない場合は、登録、存在する場合は更新を行う。

備考
----

ファイルのダウンロードにはFaradayを使用のこと。
Excelの読み込みはRubyXLを使用のこと。
沖縄エリアのデータは取込の対象外とする。
処理はRakeタスクを起点として作成し、実装は、データを登録するモデルクラスのクラスメソッドに記述する。(lib/tasks/jepx.rake)
