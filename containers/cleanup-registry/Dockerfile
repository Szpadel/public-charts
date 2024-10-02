FROM python:3.12-alpine@sha256:6666ea354f193c7a296dc2ce0188f318c9d69cb572eceaac1f7dbebd6791431f
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
