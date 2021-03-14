FROM mcr.microsoft.com/azure-cli
RUN apk --update add --no-cache libc6-compat

# Download and install glibc
RUN apk add --update curl && \
  curl -Lo /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
  curl -Lo glibc.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk" && \
  curl -Lo glibc-bin.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk" && \
  apk add glibc-bin.apk glibc.apk && \
  /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib && \
  echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
  apk del curl && \
  rm -rf glibc.apk glibc-bin.apk /var/cache/apk/*

RUN ln -s /lib/libc.musl-x86_64.so.1 /lib/ld-linux-x86-64.so.2
RUN az bicep install
RUN mkdir -p /azgitops
COPY ./runtime/sync.sh /azgitops
COPY ./bicep/main.bicep /azgitops
ENTRYPOINT [ "sh", "/azgitops/sync.sh" ]
# ENTRYPOINT ["tail", "-f", "/dev/null"]