IMAGE=benhall/nginx-sticky

default: build

build:
	docker build -t $(IMAGE) .

test:
	docker run -p 80 -d --name nginx-sticky $(IMAGE)

push:
	docker push $(IMAGE)
