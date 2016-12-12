BIN = ./node_modules/.bin
SRC = $(shell find ./src -name '*.js')
LIB = $(SRC:./src/%=lib/%)

build:: $(LIB)

lint::
	@$(BIN)/eslint $(SRC)

release-patch: build lint
	@$(call release,patch)

release-minor: build lint
	@$(call release,minor)

release-major: build lint
	@$(call release,major)

publish:
	git push --tags origin HEAD:master
	npm publish

lib/%.js: src/%.js
	@echo "building $@"
	@mkdir -p $(@D)
	@$(BIN)/babel --source-maps-inline -o $@ $<

clean:
	@rm -rf lib/

define release
	npm version $(1)
endef