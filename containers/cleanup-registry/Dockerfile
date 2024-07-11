FROM python:3.12-alpine@sha256:0bd77ae937dce9037e136ab35f41eaf9e012cfd741fc3c8dd4b3e2b63499f12c
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
