FROM python:3.12-alpine@sha256:3d75b059b5341f6e25d854395e54dea7158874e82b14c442be948ce3c62a9784
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
