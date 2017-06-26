FROM python:2.7
RUN mkdir /app
ADD . /app
RUN pip install boto3
WORKDIR /app
ENTRYPOINT ["python", "entry.py"]