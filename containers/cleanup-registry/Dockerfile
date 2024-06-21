FROM python:3.12-alpine@sha256:44a5b997abb8de1ea47a4a91a81431f8dc8f789e2bf45530aa0db85344d70bad
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
