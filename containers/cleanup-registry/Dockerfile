FROM python:3.12-alpine@sha256:500c53884dcc36a8eff18a183f02476635c4ace4f362c569993963217c010d26
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
