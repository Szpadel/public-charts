FROM python:3.12-alpine@sha256:1d688a37293956d3e0658dfb54938082933cca848ec9105c1680b39d91b912a8
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
