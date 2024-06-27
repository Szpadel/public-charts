FROM python:3.12-alpine@sha256:99fd0972496d48f2cd6302696fe33d88c9a3461ce493bf5d1b2ace93c4302a45
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
