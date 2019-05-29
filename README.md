# mediawiki

## .gitlab-ci.yml セッティング

事前に以下の変数をSetting->CI / CD->Environment variablesに定義すること

- CI_REGISTRY
- CI_REGISTRY_PASSWORD
- CI_REGISTRY_USER
- http_proxy
- https_proxy

## 手動ビルド

```
# docker build -t stratus159.stratus.flab.fujitsu.co.jp:9000/kitajima/mediawiki:1.0.0 --build-arg http_proxy=http://stratus159.stratus.flab.fujitsu.co.jp:13128 --build-arg https_proxy=http://stratus159.stratus.flab.fujitsu.co.jp:13128 .
```

## 手動Push

```
# docker push stratus159.stratus.flab.fujitsu.co.jp:9000/kitajima/mediawiki:1.0.0
```

## 起動
### 初回起動時

docker-compose.ymlの以下の行をコメントアウトしておくこと

```
      - /mnt/data/mediawiki/LocalSettings.php:/var/www/wiki/LocalSettings.php
```


```
# git clone http://stratus159.stratus.flab.fujitsu.co.jp:10080/kitajima/mediawiki.git
# cd mediawiki
# docker-compose up -d
```

上記で立ち上げた後，`http://xxxx/wiki`にアクセスし，初期設定を行ってダウンロードしたLocalSettings.phpを`/mnt/data/mediawiki/LocalSettings.php`に格納する

その後，docker-compose.ymlのコメントアウトを解除し，以下の起動手順を実行する

### 2回目移行の起動時

```
# cd mediawiki
# docker-compose up -d
```

## 停止

```
# docker-compose down
```

## アップグレード

起動後に`http://xxxx/wiki/mw-config/`にアクセスし，

```
# cat LocalSettings.php | grep wgUpgradeKey
$wgUpgradeKey = "****";
```

の値を入れてDBをアップグレードする

## バックアップ

/mnt/data/mediawiki/imagesフォルダとDBデータのバックアップが必要

### imagesフォルダ

```
# tar zcf /mnt/data/mediawiki/backup/wiki-images.tgz /mnt/data/mediawiki/images
```

### DBデータ

```
# DBNAME=wiki
# DBUSER=wikiuser
# DBPASS=wikiuser
# DBCHARSET=utf8
# docker exec -i wiki-db sh -c "exec mysqldump -u${DBUSER} -p${DBPASS} --default-character-set=${DBCHARSET} ${DBNAME} | gzip -9" > /mnt/data/mediawiki/backup/wiki-sql.sql.gz
```

## リストア

### imagesフォルダ

```
# tar zxvf /mnt/data/mediawiki/backup/wiki-images.tgz -C /mnt/data/mediawiki
```

### DBデータ

```
# cat cat wiki-sql-20190528.sql | docker exec -i wiki-db /usr/bin/mysql -uwikiuser -pwikiuser wiki | docker exec -i wiki-db /usr/bin/mysql -uwikiuser -pwikiuser wiki
```