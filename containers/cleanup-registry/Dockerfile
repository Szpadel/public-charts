FROM python:3.12-alpine@sha256:bb5d0ac04679d78a1258e7dfacdb4d9bdefe9a10480eaf9b4bb09445d076369f
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
