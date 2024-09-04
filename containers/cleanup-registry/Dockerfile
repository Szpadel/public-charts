FROM python:3.12-alpine@sha256:8077d0497053dfaeabc55c9f4920dac07db174ee4bb583b1bdc4ee104ddf16f4
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
