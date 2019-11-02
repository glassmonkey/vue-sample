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
.PHONY: run
# 開発モードでコンテナに入る。主にライブラリインストールなどに
.PHONY: run
run: build
	docker-compose run  --run app /bin/ash
# 起動済みのコンテナの中に入る
.PHONY: attach
attach:
	docker-compose exec app
