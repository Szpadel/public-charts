FROM python:3.12-alpine@sha256:7d282ebed7afa88bfd08385a432d573e5b8469ceb8da5ccf56014272214c0fd5
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
