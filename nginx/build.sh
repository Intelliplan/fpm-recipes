#!/bin/bash
set -e
description='a high performance web server and a reverse proxy server'
name='nginx'
version='1.9.0'
revision='1'
homepage='http://nginx.org/'
source="http://nginx.org/download/nginx-${version}.tar.gz"
section='System Environment/Daemons'

function download_and_extract {
	curl -sSL $1 | tar -C $2 --strip-components=1 -xzf -
}
rm -rf build
mkdir -p build/{nginx,install}

## build
download_and_extract "http://nginx.org/download/nginx-${version}.tar.gz" build/nginx
(cd build/nginx
	./configure \
		--with-http_gzip_static_module \
		--with-http_stub_status_module \
		--with-http_ssl_module \
		--with-pcre \
		--with-file-aio \
		--with-http_realip_module \
		--without-http_scgi_module \
		--without-http_uwsgi_module \
		--with-http_auth_request_module \
		--prefix=/usr \
		--user=nginx \
		--group=nginx \
		--pid-path=/var/run/nginx.pid \
		--lock-path=/var/lock/subsys/nginx \
		--conf-path=/etc/nginx/nginx.conf \
		--http-log-path=/var/log/nginx/access.log \
		--error-log-path=/var/log/nginx/error.log \
		--http-proxy-temp-path=/var/lib/nginx/tmp/proxy \
		--http-fastcgi-temp-path=/var/lib/nginx/tmp/fastcgi \
		--http-client-body-temp-path=/var/lib/nginx/tmp/client_body

	export DESTDIR="$(pwd)/../install"
	make
	make install
)

## create package
function cpd {
	mkdir -p $(dirname $2)
	cp $1 $2
}

### startup script
cpd init.d.nginx build/install/etc/init.d/nginx
chmod +x build/install/etc/init.d/nginx
cpd sysconfig.nginx build/install/etc/sysconfig/nginx

### man page
gzip build/nginx/objs/nginx.8
cpd build/nginx/objs/nginx.8.gz build/install/usr/share/man/man8/nginx.8.gz

### support dirs
mkdir -p build/install/var/{run,lock,log/nginx,lib/nginx}

### make rpm
mkdir -p pkg
fpm \
 	-s dir \
	-t rpm \
 	--name "$name" \
	--version "$version" \
	--iteration "$revision" \
	--description "$description" \
	--url "$homepage" \
	--category "$section" \
	--depends openssl \
	--depends glibc \
	--depends zlib \
	--depends pcre \
	--depends libxslt \
	--depends gd \
	--depends GeoIP \
	--depends libxml2 \
	--depends perl \
	--depends bash \
	--depends shadow-utils \
	--depends initscripts \
	--depends chkconfig \
	-C build/install \
	-p pkg/ \
	--after-install postinstall \
 	.
