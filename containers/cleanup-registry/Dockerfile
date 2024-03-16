FROM python:3.12-alpine@sha256:6deafe0dd6043df014df7b78c4da976f008a77d160c8d1857dd83b50d88b2aae
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
