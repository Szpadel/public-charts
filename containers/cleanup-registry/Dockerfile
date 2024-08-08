FROM python:3.12-alpine@sha256:c2f41e6a5a67bc39b95be3988dd19fbd05d1b82375c46d9826c592cca014d4de
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
