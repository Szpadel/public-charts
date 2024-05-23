FROM python:3.12-alpine@sha256:5365725a6cd59b72a927628fdda9965103e3dc671676c89ef3ed8b8b0e22e812
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
