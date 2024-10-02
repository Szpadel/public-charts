FROM python:3.12-alpine@sha256:e75de178bc15e72f3f16bf75a6b484e33d39a456f03fc771a2b3abb9146b75f8
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
