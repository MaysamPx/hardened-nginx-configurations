#In order to disable the unwanted vulnerable modules, Nginx must be recompiled from the source.

ARG VERSION=alpine
FROM nginx:${VERSION} as builder

ENV MORE_HEADERS_VERSION=0.34
ENV MORE_HEADERS_GITREPO=openresty/headers-more-nginx-module

# Download sources
RUN wget "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" -O nginx.tar.gz && \
    wget "https://github.com/${MORE_HEADERS_GITREPO}/archive/v${MORE_HEADERS_VERSION}.tar.gz" -O extra_module.tar.gz

# For latest build deps, see https://github.com/nginxinc/docker-nginx/blob/master/mainline/alpine/Dockerfile
RUN  apk add --no-cache --virtual .build-deps \
    gcc \
    libc-dev \
    make \
    openssl-dev \
	openssl \
    pcre-dev \
    zlib-dev \
    linux-headers \
    libxslt-dev \
    gd-dev \
    geoip-dev \
    perl-dev \
    libedit-dev \
    mercurial \
    bash \
    alpine-sdk \
    findutils

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

RUN rm -rf /usr/src/nginx /usr/src/extra_module && mkdir -p /usr/src/nginx /usr/src/extra_module && \
    tar -zxC /usr/src/nginx -f nginx.tar.gz && \
    tar -xzC /usr/src/extra_module -f extra_module.tar.gz

WORKDIR /usr/src/nginx/nginx-${NGINX_VERSION}

# Reuse same cli arguments as the nginx:alpine image used to build
RUN CONFARGS=$(nginx -V 2>&1 | sed -n -e 's/^.*arguments: //p') && \
    sh -c "./configure \
		--with-compat \
		--user=nginx \
		--group=nginx \
		--without-http_gzip_module \
		--without-http_autoindex_module \
#		--without-http_dav_module \
#		--without-http_mp4_module \
		$CONFARGS --add-dynamic-module=/usr/src/extra_module/*" && make modules


# Starting point of the production container
FROM nginx:${VERSION}

COPY --from=builder /usr/src/nginx/nginx-${NGINX_VERSION}/objs/*_module.so /etc/nginx/modules/

ENV TZ=Asia/Tehran
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Expose ports
EXPOSE 80
EXPOSE 443

# Copy custom configuration file from the current directory
COPY nginx.conf /etc/nginx/nginx.conf

# Copy cert files
COPY ./certs /etc/nginx/certs

# Copy static assets into var/www
COPY ./build-directory-containing-static-files /var/www/

#Maybe it's better to be reconfigured in a different static way.
#CIS - 4.1.6 Ensure custom Diffie-Hellman parameters are used.
RUN apk add openssl
RUN mkdir /etc/nginx/ssl
RUN openssl dhparam -out /etc/nginx/ssl/dhparam.pem 2048 # Increase this value to 2048 in the productiuon.
RUN chmod 400 /etc/nginx/ssl/dhparam.pem


# Validate the config
RUN nginx -t


#CIS- 2.2.2 (Ensure the NGINX service account is locked.)
SHELL ["/bin/ash", "passwd -l nginx"]


#CIS- 2.3.2 (Ensure access to NGINX directories and files is restricted.)
SHELL ["/bin/ash", "find /etc/nginx -type d | xargs chmod 750"]
SHELL ["/bin/ash", "find /etc/nginx -type f | xargs chmod 640"]

#CIS - 3.4 Ensure log files are rotated.
SHELL ["/bin/ash", "sed -i 's/daily/weekly/' /etc/logrotate.d/nginx"]
SHELL ["/bin/ash", "sed -i 's/rotate 52/rotate 13/' /etc/logrotate.d/nginx"]

#CIS - 4.1.3 Ensure private key permissions are restricted.
SHELL ["/bin/ash", "chmod 400 /etc/nginx/certs/subdomain.goodreads.com.key"]

#CIS - 4.1.4 Ensure only modern TLS protocols are used.
# TLSv1.2 prefered.
SHELL ["/bin/ash", "sed -i 's/ssl_protocols[^;]*;/ssl_protocols TLSv1.2;/' /etc/nginx/nginx.conf"]

