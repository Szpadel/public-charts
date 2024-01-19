FROM python:3.12-alpine@sha256:4a156f7a9345db240524356459eca141f02a9bfebdb8a311d1cf982aa2e99210
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
