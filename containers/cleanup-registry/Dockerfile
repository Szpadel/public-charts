FROM python:3.12-alpine@sha256:25a82f6f8b720a6a257d58e478a0a5517448006e010c85273f4d9c706819478c
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
