FROM python:3.11-alpine@sha256:137bccf22ff89ad5fb48cac18506ef5b0e95df61295dd3afe99fa864f8af427d
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
