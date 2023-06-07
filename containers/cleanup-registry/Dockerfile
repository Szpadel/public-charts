FROM python:3.11-alpine@sha256:15ac22e55be7161db16e5004e5854d79269b3585af39053d2504646b5bc7080f
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
