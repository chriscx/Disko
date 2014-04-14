REPORTER = dot

build:
	@./node_modules/.bin/coffee -o lib/ -b -c app/
	@./node_modules/.bin/coffee -o test/ -b -c test/build
	@./node_modules/.bin/jade app/views/* -o public/ -P

test: build
	@NODE_ENV=test ./node_modules/.bin/mocha test/*

start: build
	coffee app/server.coffee
.PHONY: test
