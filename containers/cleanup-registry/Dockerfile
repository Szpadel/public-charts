FROM python:3.12-alpine@sha256:ab1b9846297e0039c4f646b09feed739e8e72647a099d5b08fe5a785a42139e6
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
