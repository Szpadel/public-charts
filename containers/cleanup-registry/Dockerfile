FROM python:3.12-alpine@sha256:dbb264b17d3b5724e3487b2c685f5552a1cd66fa19864adc529d5ec09da13fb9
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
