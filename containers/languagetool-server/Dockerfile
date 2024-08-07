FROM alpine@sha256:0a4eaa0eecf5f8c050e5bba433f58c052be7587ee8af3e8b3910ef9ab5fbe9f5 AS build-languagetool
ENV VERSION=6.4
RUN apk add --no-cache curl
WORKDIR /build
RUN curl -fL https://languagetool.org/download/LanguageTool-${VERSION}.zip -O
RUN unzip LanguageTool-${VERSION}.zip && mv LanguageTool-${VERSION} /app

FROM alpine@sha256:0a4eaa0eecf5f8c050e5bba433f58c052be7587ee8af3e8b3910ef9ab5fbe9f5 AS build-fasttext
ENV VERSION=0.9.2
RUN apk add --no-cache git make g++ linux-headers
WORKDIR /build
RUN git clone https://github.com/facebookresearch/fastText.git && cd fastText \
    # Fix compilation error in gcc >= 13
    && sed -i '13a #include <cstdint>' src/args.h
RUN cd fastText && make && mkdir /app && mv fasttext /app/fasttext

FROM alpine@sha256:0a4eaa0eecf5f8c050e5bba433f58c052be7587ee8af3e8b3910ef9ab5fbe9f5 AS fasttext-model
RUN apk add --no-cache curl
WORKDIR /app
RUN curl -fL https://dl.fbaipublicfiles.com/fasttext/supervised-models/lid.176.bin -O

FROM alpine@sha256:0a4eaa0eecf5f8c050e5bba433f58c052be7587ee8af3e8b3910ef9ab5fbe9f5 AS languagetool-server
RUN apk add --no-cache openjdk11-jre-headless tini libhunspell
RUN addgroup -S languagetool && adduser -S languagetool -G languagetool
COPY --from=build-languagetool /app /app
COPY --from=build-fasttext /app/fasttext /app/fasttext
COPY --from=fasttext-model /app /app
WORKDIR /app
RUN echo "fasttextModel=/app/lid.176.bin" > server.properties \
    && echo "fasttextBinary=/app/fasttext" >> server.properties

EXPOSE 8081
USER languagetool
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["java", "-cp", "languagetool-server.jar", "org.languagetool.server.HTTPServer", \
    "--config", "server.properties", "--public", "--port", "8081", "--allow-origin"]
