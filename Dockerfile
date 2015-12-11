FROM ubuntu:14.04

RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y build-essential && \
  apt-get install -y software-properties-common && \
  apt-get install -y wget git && \
  rm -rf /var/lib/apt/lists/*

ENV NGINX 1.9.7

RUN \
  add-apt-repository -y ppa:nginx/stable && \
  apt-get update && \
  apt-get install -y libpcre3-dev libpcrecpp0 libssl-dev zlib1g-dev && \
  rm -rf /var/lib/apt/lists/* && \
  mkdir ~/sources && \
  cd ~/sources && \
  wget http://nginx.org/download/nginx-$NGINX.tar.gz && \
  tar -zxvf nginx-$NGINX.tar.gz && \
  git clone https://bitbucket.org/nginx-goodies/nginx-sticky-module-ng.git && \
  cd nginx-$NGINX && \
  ./configure \
    --prefix=/etc/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --sbin-path=/usr/sbin/nginx \
    --pid-path=/var/log/nginx/nginx.pid \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --with-http_ssl_module \
    --with-http_gzip_static_module \
    --with-http_stub_status_module \
    --with-http_realip_module \
    --add-module=/root/sources/nginx-sticky-module-ng && \
  make && \
  make install && \
  rm -rf ~/sources

RUN useradd nginx
COPY nginx.conf /etc/nginx/nginx.conf

VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx"]

WORKDIR /etc/nginx

CMD ["/usr/sbin/nginx"]

EXPOSE 80 443
