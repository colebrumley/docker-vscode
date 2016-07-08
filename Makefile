NAME = elcolio/vscode
VERSION = $$(git symbolic-ref HEAD 2>/dev/null | cut -d"/" -f 3)
APP_NAME = Containerized VSCode
ICNS_URL = https://github.com/Microsoft/vscode/blob/master/resources/darwin/code.icns

.PHONY: all build tag_latest release app

all: build tag_latest app

build:
	docker build -t $(NAME):$(VERSION) --rm ./

tag_latest:
	docker tag $(NAME):$(VERSION) $(NAME):latest

release: build tag_latest app
	docker push $(NAME)

app:
	curl -v -o "./$(APP_NAME).app/Contents/Resources/appIcon.icns" $(ICNS_URL) && \
	cp -f ./start.sh "./$(APP_NAME).app/Contents/Resources/script"
