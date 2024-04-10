FROM python:3.12-alpine@sha256:803cb528ae9ee943284c63efa770281916fd61a950fab7339fc970460f934cef
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
