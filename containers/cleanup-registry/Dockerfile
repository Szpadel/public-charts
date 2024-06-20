FROM python:3.12-alpine@sha256:35cd9154c2743c2fc9488be209e299d72eaa588af33524b13e7679f195e5bfe8
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
