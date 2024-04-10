FROM python:3.12-alpine@sha256:cb72885ab952a5150e5ef9486de161b45c6de7a5adcb20c7e970f16e1fbf40a9
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
