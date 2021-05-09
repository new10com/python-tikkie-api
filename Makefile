PACKAGE_DIR = src/tikkie2
VENV_DIR = .venv
BIN = $(VENV_DIR)/bin

.PHONY: black
black:
	$(BIN)/black ${PACKAGE_DIR} tests

.PHONY: black-check
black-check:
	$(BIN)/black ${PACKAGE_DIR} tests --check

.PHONY: build
build: clean
	$(BIN)/pip install wheel
	python setup.py sdist bdist_wheel

.PHONY: clean
clean:
	find . -name '*.pyc' -delete
	find . -name '__pycache__' -type d | xargs rm -fr
	rm -rf dist build src/*.egg-info

.PHONY: flake8
flake8:
	$(BIN)/flake8 ${PACKAGE_DIR} tests

.PHONY: install
install:
	pyenv install -s
	pyenv local
	python -m venv $(VENV_DIR)
	$(BIN)/pip install -U pip setuptools --quiet
	$(BIN)/pip install -U -e .[tests] --quiet
	$(BIN)/pre-commit install

.PHONY: isort-check
isort-check:
	$(BIN)/isort --check-only ${PACKAGE_DIR} tests

.PHONY: isort-fix
isort-fix:
	$(BIN)/isort ${PACKAGE_DIR} tests

.PHONY: mypy
mypy:
	$(BIN)/mypy ${PACKAGE_DIR}

.PHONY: test
test:
	$(BIN)/pytest tests

.PHONY: upload
upload: build
	$(BIN)/pip install twine wheel keyring
	$(BIN)/twine upload --repository new10 dist/*


.PHONY: z-ci-test
z-ci-test:
	$(BIN)/pytest tests --cov=${PACKAGE_DIR}

.PHONY: z-ci-install
z-ci-install:
	python -m venv $(VENV_DIR)
	$(BIN)/pip install -U pip setuptools --quiet
	$(BIN)/pip install -U -e .[tests] --quiet
