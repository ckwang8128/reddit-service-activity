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
COPY ./requirements.txt ./test-requirements.txt /opt/activity/

# Set up Virtualenv
RUN mkdir /opt/venvs && \
    virtualenv -p python3 /opt/venvs/activity

# upgrade pip
# Install requirements in virtualenv
RUN /opt/venvs/activity/bin/pip install --no-index --find-links https://reddit-wheels.s3.amazonaws.com/index.html --upgrade pip && \
    /opt/venvs/activity/bin/pip install --pre --no-index --find-links https://reddit-wheels.s3.amazonaws.com/index.html -r requirements.txt && \
     /opt/venvs/activity/bin/pip install --pre --no-index --find-links https://reddit-wheels.s3.amazonaws.com/index.html -r test-requirements.txt

# Link rest of source code
ADD . /opt/activity

# Build and setup python project
RUN . /opt/venvs/activity/bin/activate && /usr/bin/make thrift && \
    /opt/venvs/activity/bin/python setup.py develop --no-deps

CMD  /opt/venvs/websockets/bin/python setup.py develop && \
    /opt/venvs/websockets/bin/python setup.py build && \
    /opt/venvs/activity/bin/baseplate-serve --debug --bind 0.0.0.0:9090 --reload example.ini
