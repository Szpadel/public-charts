FROM python:3.12-alpine@sha256:afb155bd14a4bb37f30c683a6a7e8b21f18b40f07e819379273f702d9efcbf1a
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
