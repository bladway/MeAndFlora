# on windows needs to install mingw32-make.exe from mingw
# before using application you need to receive or define application-hidden.yml
# file in resources folder

# usage: mingw32-make.exe jib-build tag=<tag>
jib-build:
	mvn compile jib:build -Dimage=bladway/maf-mainserver:$(tag)

# usage: mingw32-make.exe dockerfile-build tag=<tag>
dockerfile-build:
	mvn clean install && \
	docker build -t bladway/maf-mainserver:$(tag) . && \
	docker push bladway/maf-mainserver:$(tag)

