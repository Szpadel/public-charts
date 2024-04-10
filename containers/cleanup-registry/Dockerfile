FROM python:3.12-alpine@sha256:ef097620baf1272e38264207003b0982285da3236a20ed829bf6bbf1e85fe3cb
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
