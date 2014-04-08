REPORTER = dot

build:
	@./node_modules/.bin/coffee -o lib/ -b -c app/
	@./node_modules/.bin/coffee -o test/ -b -c test/js
	@./node_modules/.bin/jade app/views/* -o public/

test: build
	@NODE_ENV=test ./node_modules/.bin/mocha test/*

start: build
	node lib/controllers/server.js

.PHONY: test
