FROM python:3.12-alpine@sha256:d24ed567ee3b972478a232ceff84b0d002e18ee9f5d38234ecbffece23dfa084
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
