reddit-service-activity
=======================

[![Build Status](https://travis-ci.org/reddit/reddit-service-activity.svg?branch=master)](https://travis-ci.org/reddit/reddit-service-activity)

A service for real-time counting of visitors.

### Testing and Development

There are two Docker images provided for development and testing.

* `Dockerfile`: A Docker image definition for running a local version of the service.
* `Dockerfile.test`: A Docker image definition for running tests.

```
# Exposes activity service at 127.0.0.1:9090
docker build . -t activity-server -f Dockerfile  && docker run --rm -p 9090:9090 activity-server

# Run code tests
docker build . -t activity-tests -f Dockerfile.test  && docker run activity-tests
```
