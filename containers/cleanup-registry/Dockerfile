FROM python:3.12-alpine@sha256:d696c999babcff2d6194727e5c36908e7741aa530e6ed0d8e2fb4b6cfb7be43d
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
