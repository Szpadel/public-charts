FROM python:3.12-alpine@sha256:100d96cd32e818e470a4793ef56806c52052e7f76de0093a012625a02eb0a780
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
