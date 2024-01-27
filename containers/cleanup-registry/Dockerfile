FROM python:3.12-alpine@sha256:277299d479e5f73430765336a4407d21116bf1a84a2597b77d1f6743a90537f7
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
