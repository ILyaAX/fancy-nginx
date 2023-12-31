FROM nginx:mainline-bookworm as builder

RUN apt update && apt install -y git \
	build-essential libssl-dev libgeoip-dev \ 
	libxslt1-dev zlib1g-dev libgd-dev; \
	cd /opt; \	
	curl -O https://nginx.org/download/nginx-1.25.1.tar.gz; \
	tar -xf nginx-1.25.1.tar.gz; \
	git clone https://github.com/aperezdc/ngx-fancyindex.git; \
	cd /opt/nginx-1.25.1; \
    	./configure --prefix=/etc/nginx \
    	--sbin-path=/usr/sbin/nginx \ 
    	--modules-path=/usr/lib/nginx/modules \
    	--conf-path=/etc/nginx/nginx.conf \ 
    	--error-log-path=/var/log/nginx/error.log \
    	--http-log-path=/var/log/nginx/access.log \
    	--pid-path=/var/run/nginx.pid \
    	--lock-path=/var/run/nginx.lock \
    	--http-client-body-temp-path=/var/cache/nginx/client_temp \
    	--http-proxy-temp-path=/var/cache/nginx/proxy_temp \
    	--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
    	--http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
    	--http-scgi-temp-path=/var/cache/nginx/scgi_temp \
    	--user=nginx \
    	--group=nginx \
    	--with-compat \
    	--with-file-aio \
    	--with-threads \
    	--with-http_addition_module \
    	--with-http_auth_request_module \
    	--with-http_dav_module \
    	--with-http_flv_module \
    	--with-http_gunzip_module \
    	--with-http_gzip_static_module \
    	--with-http_mp4_module \
    	--with-http_random_index_module \
    	--with-http_realip_module \
    	--with-http_secure_link_module \
    	--with-http_slice_module \
    	--with-http_ssl_module \
    	--with-http_stub_status_module \
    	--with-http_sub_module \
    	--with-http_v2_module \
    	--with-http_v3_module \
    	--with-mail \
    	--with-mail_ssl_module \
    	--with-stream \
    	--with-stream_realip_module \
    	--with-stream_ssl_module \
    	--with-stream_ssl_preread_module \
    	--add-module=../ngx-fancyindex \
    	--without-http_rewrite_module; \
    	make; \
    	make install

FROM nginx:mainline-bookworm
COPY --from=builder /usr/sbin/nginx /usr/sbin/nginx
COPY ./nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80 443
CMD ["nginx", "-g", "daemon off;"]
