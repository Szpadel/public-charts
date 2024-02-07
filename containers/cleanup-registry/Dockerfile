FROM python:3.12-alpine@sha256:ca540b46e116cec0d409cb4275cc121cc378d43e0553b8bf940e4d48fb94b4ba
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
