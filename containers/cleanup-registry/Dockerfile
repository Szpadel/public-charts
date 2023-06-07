FROM python:3.11-alpine@sha256:acd740d47d84a96bc8194fe6202a295929402034eb83a601b30fcaac3140326e
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
