FROM alpine
RUN apk add --no-cache \
        bash jq python3 py3-pip curl helm git coreutils \
    && pip install yq
RUN curl -L \
    "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    -o /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl
