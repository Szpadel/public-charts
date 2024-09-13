FROM python:3.12-alpine@sha256:7593fc658f7565d8e340714cb6219bfb0737d4b942034fe0f4cc9296a8b36a29
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
