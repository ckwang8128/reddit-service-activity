all: thrift

.PHONY: thrift
thrift:
	python setup.py build

develop:
	python setup.py develop --no-deps
