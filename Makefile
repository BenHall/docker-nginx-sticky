IMAGE=benhall/nginx-sticky
TAG=1.9.10

default: build

build:
	docker build -t $(IMAGE):$(TAG) .

test:
	docker run -p 80 -d --name nginx-sticky $(IMAGE):$(TAG)

push:
	docker push $(IMAGE):$(TAG)
