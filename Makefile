PHPUNIT_FLAGS :=--stop-on-failure --colors="always" --no-coverage
PHPUNIT_FLAGS_DEBUG :=--colors="always" --no-coverage --printer="tests\blazemeter\PHPUnitPrinter\Printer"
SRC_DIR := src
TESTS_DIR := tests

test: ./${TESTS_DIR}
	./vendor/bin/phpunit ${PHPUNIT_FLAGS} --configuration ./${TESTS_DIR}/phpunit.xml $</$(patsubst $(TESTS_DIR)/%,%,$(TEST_FILE))
	date

run: runphpsrv

runphpsrv:
	PHP_CLI_SERVER_WORKERS=10 php -S 0.0.0.0:8001

runwss:
	php wssrv.php 8002 

update: composer.json
	composer update

install: update
	composer install


