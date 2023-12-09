FROM python:3.12-alpine@sha256:97906094825ed3a22435176b7b638dcf07974917f8868f0741898faeb7cf39ac
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
