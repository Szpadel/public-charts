FROM python:3.12-alpine@sha256:98a1fdb8d0594f4743b7cfcff4e31f32dd3caf5c049c8697f89949212427752c
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
