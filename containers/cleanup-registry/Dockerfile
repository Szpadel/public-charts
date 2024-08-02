FROM python:3.12-alpine@sha256:2abecb741d63f6627f318377cd5886bf89069458007317488b0e9fe06d3c11f6
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
