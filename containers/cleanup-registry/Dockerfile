FROM python:3.12-alpine@sha256:37b26b80c83affc18bb132b7659dea649d6c21702edb2799cc2b43ca26dca5ce
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
