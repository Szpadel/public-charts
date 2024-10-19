FROM python:3.13-alpine@sha256:92e0e7f0e119e631e5d08a77bab4e2f35a93c727057cae6528d58880f8e77f6e
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
