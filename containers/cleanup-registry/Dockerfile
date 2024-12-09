FROM python:3.13-alpine@sha256:5dcc4bdd33c7ed3a43d64495fb83bb38653ab5cd776dd97e63e9b6499fc8fc89
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
