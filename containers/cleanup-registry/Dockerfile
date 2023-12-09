FROM python:3.12-alpine@sha256:401aa105e81895c2da152b97907502972de5b2f779c87dcae556f091119c2c0f
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
