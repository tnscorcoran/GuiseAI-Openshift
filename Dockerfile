FROM openvino/ubuntu20_runtime
ENV TZ=Australia/Sydney \
    DEBIAN_FRONTEND=noninteractive
WORKDIR /app
USER root
RUN apt-get update -y \
    && apt-get install -y python3-pip python3-dev \
    && apt-get install -y ffmpeg
COPY ./requirements.txt ./app ./
RUN python3 -m pip install -r /app/requirements.txt
# RUN python3 -m pip install openvino
EXPOSE 30000
CMD [ "python3","-u","./run.py" ]