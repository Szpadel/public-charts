FROM python:3.12-alpine@sha256:71543730c2aa034656492adcff96cd9b00b84939985c479a4f764eaffa92ef77
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
