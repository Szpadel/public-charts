FROM python:3.11-alpine@sha256:721023564970262d6ac79d30e2a2399d32555220e4f37bfe2c3a687b4f9721d9
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
