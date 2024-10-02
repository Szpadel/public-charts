FROM python:3.12-alpine@sha256:cf0a16847d2d1e561677f5ddd924aa5c47eb2050147b6e4020588d30b6bde427
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
