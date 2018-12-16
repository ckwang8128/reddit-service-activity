# Dockerfile for a test-running environment
FROM ubuntu:trusty

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:reddit/ppa

RUN apt-get update && \
    apt-get install -y \
        python3 \
        python-virtualenv \
        fbthrift-compiler

WORKDIR /opt/activity
COPY ./requirements.txt ./test-requirements.txt ./Makefile /opt/activity/

# Set up Virtualenv
ENV VENV_PATH=/opt/venvs/activity
ENV WHEELHOUSE_INDEX=https://reddit-wheels.s3.amazonaws.com/index.html
RUN mkdir /opt/venvs && \
    virtualenv -p python3 $VENV_PATH

# Upgrade pip and install dependencies here for layer-caching.
RUN $VENV_PATH/bin/pip install --no-index --find-links $WHEELHOUSE_INDEX  --upgrade pip && \
    . $VENV_PATH/bin/activate && \
    make dependencies && \
    make test-dependencies

# Link rest of source code
ADD . /opt/activity

# Build and setup python project
RUN . $VENV_PATH/bin/activate && /usr/bin/make setup

CMD $VENV_PATH/bin/baseplate-serve --debug --bind 0.0.0.0:9090 --reload example.ini
