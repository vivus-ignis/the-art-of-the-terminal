FROM python:3.10.17-bookworm
RUN pip3 install transformers[torch] redis[hiredis]
ADD classifier.py /classifier.py
RUN chmod +x /classifier.py
ENTRYPOINT [ "/classifier.py" ]
