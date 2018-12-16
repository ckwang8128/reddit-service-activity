all: thrift

.PHONY: thrift
thrift:
	python setup.py build

.PHONY: dependencies
dependencies:
	pip install --no-index --find-links ${WHEELHOUSE_INDEX} -r requirements.txt

.PHONY: test-dependencies
test-dependencies:
	pip install --no-index --find-links ${WHEELHOUSE_INDEX} -r test-requirements.txt

.PHONY: develop
setup:
	make dependencies && make thrift && python setup.py develop --no-deps

.PHONY: test
test:
	make test-dependencies && nosetests
