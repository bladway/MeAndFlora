# on windows needs to install mingw32-make.exe from mingw
# before using application you need to receive or define application-hidden.yml
# file in resources folder
# Please use tag of version typed in application.yml
version := 1.1
# usage: mingw32-make.exe jib-build
jib-build:
	mvn compile jib:build -Dimage=bladway/maf-mainserver:${version}

# usage: mingw32-make.exe dockerfile-build
dockerfile-build:
	mvn clean install && \
	docker build -t bladway/maf-mainserver:${version} . && \
	docker push bladway/maf-mainserver:${version}

