FROM python:3.12-alpine@sha256:00321257a7e262b20a66a299d2c1232c60604f8cdd254aaecf8c7f19daf8b691
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
