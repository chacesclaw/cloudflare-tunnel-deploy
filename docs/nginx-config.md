# Nginx 配置指南

## 默认站点配置

```nginx
server {
    listen 80;
    listen [::]:80;
    server_name yourdomain.com;
    root /var/www/html;
    index index.html index.htm;
    absolute_redirect off;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

## 添加子路径

```nginx
location /app/ {
    alias /var/www/html/app/;
    index index.html;
}
location = /app { return 301 /app/; }
```

## 多站点配置

复制 `/etc/nginx/sites-available/` 中的配置文件，修改 `server_name` 和 `root`。
