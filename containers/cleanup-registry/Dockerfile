FROM python:3.11-alpine@sha256:537b7980bc438b55f3a27806e034ba50cb8e45338596e3b1928e6b25c1169a60
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
