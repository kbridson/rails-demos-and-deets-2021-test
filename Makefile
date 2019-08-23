.PHONY: usage bdeploy blocal clean serve build deploy

usage:
	@echo ''
	@echo SYNOPSIS
	@echo '     'make \[usage \| clean \| serve \| build \| deploy\]
	@echo ''

clean:
	rm -rf _site

blocal: clean
	jekyll build --verbose --baseurl ''

serve: clean
	jekyll serve --baseurl ''

bdeploy: clean
	jekyll build --verbose

build: bdeploy

deploy: build
	git rm -r docs
	git add -A
	git commit -m "Removed old docs"
	cp -a _site docs
	git add -A
	git commit -m "Added new docs for deployment"
	git push
