# ゴミファイルの掃除
.PHONY: clean
clean:
	docker system prune -fa --volumes
# アプリケーションのビルド
.PHONY: build
build:
	docker-compose build
# 開発モードでアプリケーションを起動する
.PHONY: up
up: build
	docker-compose up
# 開発モードのアプリケーションを落とす
.PHONY: down
down:
	docker-compose down
.PHONY: run
# 開発モードでコンテナに入る。主にライブラリインストールなどに
.PHONY: run
run: build
	docker-compose run app /bin/ash
# 起動済みのコンテナの中に入る
.PHONY: attach
attach:
	docker-compose exec app /bin/ash
# リリース状態でコンテナをビルドする
.PHONY: release-build
release-build:
	docker-compose -f docker-compose.release.yml build
# リリース状態でコンテナを立ち上げる
.PHONY: release-up
release-up: release-build
	docker-compose -f docker-compose.release.yml up
# lint実行
.PHONY: lint
lint:
	docker-compose run app npm run lint
# 本番ビルドファイル生成
.PHONY: distribute
distribute:
	docker-compose run app npm run build
