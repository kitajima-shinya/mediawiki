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