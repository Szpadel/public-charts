FROM python:3.12-alpine@sha256:64aee10ca0feab5a4a2e092b01605b7fdf2f99b5583eae649696c98ce46f41de
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
