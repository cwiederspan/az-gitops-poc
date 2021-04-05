FROM mcr.microsoft.com/azure-cli

# The version of Go Lang install found at https://golang.org/dl/
ARG GO_VERSION=1.16

# Create a temp directory for downloads
RUN mkdir -p /tmp/downloads

# Install Go
RUN curl -sSL -o /tmp/downloads/golang.tar.gz https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz  \
    && tar -C /usr/local -xzf /tmp/downloads/golang.tar.gz

ENV GOPATH=/usr/local/go
ENV PATH=$PATH:$GOPATH/bin

# Install go-getter
RUN go get github.com/hashicorp/go-getter \
    && go install github.com/hashicorp/go-getter/cmd/go-getter@latest

# Install the Azure Bicep extension
RUN az bicep install

# Clean up
RUN rm -rf /tmp/downloads

# Setup the required shell files
RUN mkdir -p /azgitops
COPY ./sync.sh /azgitops

ENTRYPOINT [ "sh", "/azgitops/sync.sh" ]