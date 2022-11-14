PHPUNIT_FLAGS :=--stop-on-failure --colors="always" --no-coverage
PHPUNIT_FLAGS_DEBUG :=--colors="always" --no-coverage --printer="tests\blazemeter\PHPUnitPrinter\Printer"
SRC_DIR := src
TESTS_DIR := tests

test: ./${TESTS_DIR}
	./vendor/bin/phpunit ${PHPUNIT_FLAGS} --configuration ./${TESTS_DIR}/phpunit.xml $</$(patsubst $(TESTS_DIR)/%,%,$(TEST_FILE))
	date

run:
	./run.sh

update: composer.json
	composer update

install: update
	composer install

container-build:
	docker build -f Dockerfile -t ghcr.io/mosermichael/phpdocker-mm:latest . 2>&1 | tee container-build.log


