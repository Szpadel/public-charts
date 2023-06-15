FROM python:3.11-alpine@sha256:ff5ba62d2619a26086d6c96efc855150e4f50b3c5bdf3afb79beeb9f549067d5
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
