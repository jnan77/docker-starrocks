VERSION := 2.3.0
IMG=ionio/starrocks:${VERSION}
build:
	docker build -t ${IMG} .
push:
	docker push ${IMG}
all:build push
