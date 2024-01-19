FROM python:3.12-alpine@sha256:801b54e1ec51c23dd6f174f3f26a0ff5bf2a002c4bc0bf05b0e2b9237e10f5b8
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
