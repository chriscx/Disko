REPORTER = dot

build:
		@./node_modules/.bin/jade views/* -o public/

test: build
		@NODE_ENV=test ./node_modules/.bin/mocha test/*

.PHONY: test