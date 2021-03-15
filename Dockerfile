FROM debian:10

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# The version of Go Lang install found at https://golang.org/dl/
ARG GO_VERSION=1.16

# Latest version of Terraform may be found at https://www.terraform.io/downloads.html
ARG TERRAFORM_VERSION=0.14.7

# Azure Functions CLI may be found at https://github.com/Azure/azure-functions-core-tools/releases
ARG AZFUNC_CLI_VERSION=3.0.3284

# Create a temp directory for downloads
RUN mkdir -p /tmp/downloads

# Configure apt and install generic packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends apt-utils dialog 2>&1 \
    #
    # Verify git, process tools installed
    && apt-get install -y \
        git \
        openssh-client \
        iproute2 \
        curl \
        procps \
        unzip \
        apt-transport-https \
        ca-certificates \
        gnupg-agent \
        software-properties-common \
        gnupg2 \
        python3-pip \
        lsb-release 2>&1

# Install Go
RUN curl -sSL -o /tmp/downloads/golang.tar.gz https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz  \
    && tar -C /usr/local -xzf /tmp/downloads/golang.tar.gz

ENV GOPATH=/usr/local/go
ENV PATH=$PATH:$GOPATH/bin

# Install the Azure CLI
RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" > /etc/apt/sources.list.d/azure-cli.list \
    && curl -sL https://packages.microsoft.com/keys/microsoft.asc | apt-key add - 2>/dev/null \
    && apt-get update \
    && apt-get install -y azure-cli \
    && az bicep install

# Install Terraform, tflint, and graphviz
RUN curl -sSL -o /tmp/downloads/terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip /tmp/downloads/terraform.zip \
    && mv terraform /usr/local/bin

# Clean up
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/downloads

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog

# Setup the required shell files
RUN mkdir -p /azgitops
COPY ./runtime/sync.sh /azgitops
COPY ./bicep/main.bicep /azgitops

ENTRYPOINT [ "sh", "/azgitops/sync.sh" ]