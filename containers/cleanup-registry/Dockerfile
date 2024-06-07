FROM python:3.12-alpine@sha256:30e8e8cd36e3a4c55c1406c3de928dfef1bc1669df3587dd241d1c33b6615291
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
