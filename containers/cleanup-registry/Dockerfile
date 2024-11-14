FROM python:3.13-alpine@sha256:fcbcbbecdeae71d3b77445d9144d1914df55110f825ab62b04a66c7c33c09373
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
