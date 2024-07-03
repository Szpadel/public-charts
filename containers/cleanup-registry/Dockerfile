FROM python:3.12-alpine@sha256:ab8bec34de4202398fc8c28229ae6510cee874ae35c579090f1f8a9197deec29
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
