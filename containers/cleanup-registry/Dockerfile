FROM python:3.11-alpine@sha256:df75afcc3c85a6eb238b3e499a3b0c464b21ba7023a51f8c5ea9c8f3cd78763d
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
