NAME = elcolio/vscode
VERSION = $$(git symbolic-ref HEAD 2>/dev/null | cut -d"/" -f 3)
APP_NAME = Containerized VSCode

.PHONY: all build tag_latest release app

all: build tag_latest

build:
	docker build -t $(NAME):$(VERSION) --rm ./

tag_latest:
	docker tag $(NAME):$(VERSION) $(NAME):latest

release: build tag_latest app
	docker push $(NAME)

install:
	test -f /usr/bin/code || cp wrapper /usr/bin/code
	chmod a+x /usr/bin/code
