# おべんきょう for iOS

勉強した時間を記録するiOSアプリです。

# はじめに
1. Xcode 9 をダウンロードする。
2. 本リポジトリをクローンする。
3. ``pod install`` を実行してライブラリをインストールする。

![RecordStudy for iOS](.github/app.jpg)

# UserDefault
## Dictionary
|Key|Type|Value|
|-|-|-|
|setting|SettingModel|目標|
|YYYYMMDD|PerformModel|実績|
|medals|MedalModel[79]|取得メダル|
|isInitialized|Bool|初期化済みフラグ|

### SettingModel(目標)
|Property|Type|Value|
|-|-|-|
|homeWork|Date(hm)|目標[宿題]|
|study|Date(hm)|目標[勉強]|

### PerformModel(実績)
|Property|Type|Value|備考|
|-|-|-|-|
|homeWork|Date(hm)|実績[宿題]||
|study|Date(hm)|実績[勉強]||
|isAchieveHomeWork|Bool|目標達成フラグ[宿題]|過去の値は修正不可|
|isAchieveStudy|Bool|目標達成フラグ[勉強]|過去の値は修正不可|
|medal|Int|獲得メダル番号|過去の値は修正不可|

### MedalModel\[79](取得メダル)
|Property|Type|Value|備考|
|-|-|-|-|
|count|Int|取得数|実績のサマリ値|
|isNew|Bool|Newフラグ||

# 用語集
|用語|意味|備考|
|-|-|-|
|setting|目標||
|perform|実績||
|achieve|達成|goalではない|

# シミュレータ
## 言語設定について
曜日の日本語対応のため、Edit Schemeで以下を設定している。
+ Default Location = Tokyo, Japan
+ Application Language = Japanese
+ Application Region = 日本

シミュレータではデバッグ時とアイコンから起動時で言語設定が異なる。
シミュレータの仕様により、アイコンから起動すると端末の言語設定に関係なく英語になる。

## シミュレータのパスを調べるには
```
~/Library/Developer/CoreSimulator/Devices/
find . | grep com.ahoworld.RecordStudy.plist
```

# 備考

## 画像について
著作権に関わるものはNoImage画像としています。

## 組み込み

* [CVCalendar](https://github.com/CVCalendar/CVCalendar) - カレンダーライブラリ

## 著者

* 角倉 優一

## ライセンス

このプロジェクトはMITライセンスの下でライセンスされています - 詳細については、[LICENSE.md](LICENSE.md)ファイルを参照してください。
