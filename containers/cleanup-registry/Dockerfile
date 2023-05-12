FROM python:3.11-alpine@sha256:b7ff125887d3f0a353496134bbdd493ee9c51f629154ea78585c3f7e6d37363f
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
