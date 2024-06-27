FROM python:3.12-alpine@sha256:ff870bf7c2bb546419aaea570f0a1c28c8103b78743a2b8030e9e97391ddf81b
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
