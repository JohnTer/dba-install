FROM python:3.6.8-stretch
RUN apt-get -y update
RUN apt-get install -y python3-pip
COPY . /server/
WORKDIR /server
EXPOSE 80
RUN pip3 install -r ./server/requirements.txt
ENTRYPOINT ["python3"]
CMD ["./server/server.py"]
