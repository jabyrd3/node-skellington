FROM alpine:latest
WORKDIR /app
COPY package.json /app/package.json
# we need upx to compress nodejs binary, we strip it at the end
# we need npm to install deps, we strip it at the end
# nodejs is needed at runtime, we compress it with upx
RUN apk update && apk add nodejs npm upx \
  && npm install --production \
  && rm -rf /app/package-lock.json \
  # tinies up nodejs binary to 14mb
  && upx $(which node) \
  # remove alpine deps we don't need at runtime
  && apk del npm upx \
  # this is stupid, h8 u npm
  && rm -rf /root/.npm/* \
  # npm leftover global cruft
  && rm -rf /usr/lib/node_modules/* \
  # clears apk metadata we don't need
  && rm -rf /var/cache/apk/* \
  && rm -rf /lib/apk/db/* \
  && rm -rf /etc/profile.d/README


COPY ./server /app
# if you strip layers, this can cut package weight down,
# experiment with it.
# RUN tar -czf /app.tar.gz * && rm -rf /app
COPY entrypoint /usr/bin/entrypoint
ENTRYPOINT ["/usr/bin/entrypoint"]
