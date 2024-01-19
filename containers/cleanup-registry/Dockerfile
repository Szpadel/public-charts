FROM python:3.12-alpine@sha256:9e075a0b151a13ce5cddb523996b8a295557d840cd95ff930636fefe7e7b6f07
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
