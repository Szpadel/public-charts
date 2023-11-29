FROM python:3.12-alpine@sha256:f1d0d03700fb2d4480e89fb807e7346c14b88952f7bd58d56de54a24817cc2e8
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
