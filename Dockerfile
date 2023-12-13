FROM alpine:3.16 as build

ENV CRAWL_REPO="https://github.com/crawl/crawl.git"
ENV APP_DEPS="bzip2 git lua-dev python3 python3-dev py3-pip py3-yaml ncurses-terminfo-base libc-utils sqlite-libs pcre-dev musl-locales lsof sudo autoconf bison build-base flex git ncurses-dev sqlite-dev zlib-dev pkgconf binutils freetype-dev libpng-dev ttf-dejavu advancecomp pngcrush libexecinfo-dev"

RUN apk update && apk add --no-cache $APP_DEPS

RUN git clone --filter=tree:0 ${CRAWL_REPO} /src/

WORKDIR /src/crawl-ref/source

# related to https://github.com/crawl/crawl/issues/2446
RUN sed -i "/#define BACKTRACE_SUPPORTED/d" crash.cc
RUN make install -j$(nproc) EXTERNAL_DEFINES="-lexecinfo" DESTDIR=/app/ USE_DGAMELAUNCH=y WEBTILES=y

FROM python:alpine3.19

COPY --from=build /app /app
COPY --from=build /src/crawl-ref/source/util /app/util
COPY --from=build /src/crawl-ref/source/webserver /app/webserver

RUN pip install --no-cache-dir -r /app/webserver/requirements/base.py3.txt

RUN cp /app/bin/crawl /app/crawl

EXPOSE 8080
CMD python /app/webserver/server.py
