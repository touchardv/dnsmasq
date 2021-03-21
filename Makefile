ARCH ?= $(shell uname -m)
IMAGE = touchardv/dnsmasq
TAG = latest

build:
	docker build --no-cache --file $(ARCH)/Dockerfile --tag $(IMAGE):$(ARCH)-$(TAG) .

clean:
	docker rmi -f $(IMAGE):$(TAG)
	rm -rf build

install: build
	mkdir build
	docker save $(IMAGE):$(TAG) | gzip > build/deploy.tar.gz
	scp build/deploy.tar.gz $(HOST):/tmp/deploy.tar.gz
	ssh $(HOST) sudo podman load -i /tmp/deploy.tar.gz

publish:
	docker login quay.io -u "$(ROBOT_USER)" -p $(ROBOT_TOKEN)
	docker tag $(IMAGE):$(ARCH)-$(TAG) quay.io/$(IMAGE):$(ARCH)-$(TAG)
	docker push quay.io/$(IMAGE):$(ARCH)-$(TAG)

run:
	docker run -it --rm \
		--cap-add NET_ADMIN \
		--cap-add NET_BROADCAST \
		--cap-add NET_RAW \
		--publish 8080:8080 \
		--name dnsmasq \
		$(IMAGE):$(TAG)

shell:
	docker run -it --rm --entrypoint /bin/sh $(IMAGE):$(TAG)
