all:
	${MAKE} build
	${MAKE} manifest

build: build_x86_64 build_aarch64

manifest:
	docker manifest rm \
		accupara/termux-docker:latest
	docker manifest create \
		accupara/termux-docker:latest \
		--amend accupara/termux-docker:x86_64 \
		--amend accupara/termux-docker:aarch64
	docker manifest push accupara/termux-docker:latest

build_%:
	docker pull termux/termux-docker:$*
	-docker rm -f saveit-$*
	@echo "Run the following in the docker container: 'pkg upgrade -y && exit 0'"
	docker run --name saveit-$* -it --privileged --platform $* termux/termux-docker:$* bash
	docker commit saveit accupara/termux-docker:$*
	docker push accupara/termux-docker:$*

