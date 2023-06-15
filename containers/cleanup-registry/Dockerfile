FROM python:3.11-alpine@sha256:64d8232e5b2293871f89335ff85745a4281616b12710d3e214ce04e3da9e34ca
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
