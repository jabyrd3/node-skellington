FROM alpine:latest
WORKDIR /app
COPY package.json /app/package.json
# we need upx to compress nodejs binary, we strip it at the end
# we need npm to install deps, we strip it at the end
# nodejs openssh-keygen openssl and gnupg are needed at runtime
# its dumb to manually strip the bullshit out of these, i need to find a better way
RUN apk update && apk add nodejs npm upx \
  && npm install --production \
  # tinies up nodejs binary to 14mb
  && upx $(which node) \
  # remove alpine deps we don't need at runtime
  && apk del npm upx \
  # this is stupid, h8 u npm
  && rm -rf /root/.npm/* \
  # don't need
  && rm -rf /app/node_modules/.package-lock.json \
  # catch any stray jpegs
  && rm -f $(find / -iname *.jp*) \
  # catch any stray svg
  && rm -f $(find / -iname *.svg) \
  # catch any stray png
  && rm -f $(find / -iname *.png) \
  # catch any stray html
  && rm -f $(find / -iname *.html) \
  # catch any stray gifs
  && rm -f $(find / -iname *.gif) \
  # catch any stray txt
  && rm -f $(find / -iname *.txt) \
  # catch any stray markdown
  && rm -f $(find / -iname *.md) \
  # catch any stray windows binaries 
  && rm -f $(find / -iname *.exe) \
  # remove any licenses, only uncomment if you know what you're doing
  # && rm -f $(find / -iname licens*) \
  # remove any stray readmes that aren't markdown
  && rm -f $(find / -iname readme*) \
  # remove all package-lock.json files
  && rm -f $(find /app/node_modules -iname package-lo*) \
  # a few files for universal modules aren't needed
  && rm -f $(find /app/node_modules -iname *.browser.js) \
  # don't need anybodys circleci or drone configs
  && rm -f $(find /app/node_modules -iname *.yml) \
  # don't need sourcemaps, they're not even loaded by devtools
  && rm -f $(find /app/node_modules -iname *.map) \
  # we're not doing any typescript transpilation
  && rm -f $(find /app/node_modules -iname *.ts) \
  # some packages have react-native bundles that're huge
  && rm -rf $(find /app/node_modules -iname *react-*) \
  # strip all changelogs
  && rm -rf $(find / -iname changelog) \
  # we don't need bluebirds browser polyfills, which're big
  && rm -rf /app/node_modules/bluebird/js/browser \
  # we're not running anybody elses tests
  && rm -rf /app/node_modules/*/tests/ \
  && rm -rf /app/node_modules/*/test/ \
  && rm -rf /app/node_modules/*/*/tests/ \
  && rm -rf /app/node_modules/*/*/test/ \
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
