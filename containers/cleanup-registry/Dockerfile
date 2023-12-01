FROM python:3.12-alpine@sha256:85eaef27f58a5fd6074f5353449156bc5651131d17018864c275d5c7b960ca9a
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
