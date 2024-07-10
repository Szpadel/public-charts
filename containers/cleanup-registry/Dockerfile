FROM python:3.12-alpine@sha256:29d92b7ff927005ffc223e6413ccb990aa04557ee97436526e62cd60dd537c1f
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
