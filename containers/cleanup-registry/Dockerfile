FROM python:3.12-alpine@sha256:15e516965a60d66273ae8795fc9f15f25b97fbc1f1e51caa747002e0ace62ef7
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
