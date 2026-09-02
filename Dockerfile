# Dockerfile
FROM nginx:latest

# 標準のnginx設定ファイルを削除して、自前の設定に置き換える
COPY nginx.conf /etc/nginx/conf.d/default.conf

# HTMLファイルを配置する
COPY index.html /usr/share/nginx/html/index.html

# Cloud Runの仕様に合わせて8080を開放
EXPOSE 8080
