FROM python:3.12-alpine@sha256:b7662fc33e07f05fb2f579c3634e1e4d2e30c02553397c6c24f775cb360dbc03
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
