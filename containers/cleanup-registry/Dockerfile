FROM python:3.12-alpine@sha256:c793b92fd9e0e2a0b611756788a033d569ca864b733461c8fb30cfd14847dbcf
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
