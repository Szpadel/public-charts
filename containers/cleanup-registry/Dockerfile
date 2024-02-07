FROM python:3.12-alpine@sha256:295687155071f0d59deb6295dccd3eb76a10c1b18253a75997f3086e8f91e192
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
