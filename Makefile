TAG := $(shell tar -cf - . | md5sum | cut -f 1 -d " ")

build:
	docker build -t charlieegan3/serializer:latest -t charlieegan3/serializer:${TAG} .

push: build
	docker push charlieegan3/serializer:latest
	docker push charlieegan3/serializer:${TAG}
