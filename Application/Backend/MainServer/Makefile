# on windows needs to install mingw32-make.exe from mingw
# before using application you need to receive or define develop.env
# file in resources folder
# for running tests it needs to be spring profile "test" yml file

include develop.env

# usage: mingw32-make.exe jib-build
jib-build:
	mvn compile jib:build \
		-Djib.from.image=openjdk:22-ea-19-slim-bullseye \
		-Djib.from.auth.username=${DOCKER_USER} \
    	-Djib.from.auth.password=${DOCKER_PASSWORD} \
		-Djib.to.image=${MAINSERVER_REPOSITORY}:${MAINSERVER_VERSION} \
    	-Djib.to.auth.username=${DOCKER_USER} \
    	-Djib.to.auth.password=${DOCKER_PASSWORD} \
		-Djib.container.environment=MAINSERVER_VERSION="${MAINSERVER_VERSION}",MAINSERVER_SSL_PASSWORD="${MAINSERVER_SSL_PASSWORD}",\
POSTGRES_HOST="",POSTGRES_DB="",POSTGRES_USER="",POSTGRES_PASSWORD="",POSTGRES_PORT="",MAINSERVER_PORT="" 

# usage: mingw32-make.exe dockerfile-build
# dockerfile-build:
#	mvn clean install && \
#	docker build -t bladway/maf-mainserver:$ . && \
#	docker push ${MAINSERVER_REPOSITORY}:${MAINSERVER_VERSION}

# usage: mingw32-make.exe tests-deploy
tests-deploy:
	mvn -DMAINSERVER_VERSION=${MAINSERVER_VERSION} -Dspring.profiles.active=test clean install 

# usage: mingw32-make.exe run-deploy
run-deploy:
	mvn -DMAINSERVER_VERSION=${MAINSERVER_VERSION} -DskipTests clean install 

# usage: mingw32-make.exe run-local
run-local:
	mingw32-make.exe run-deploy && \
	java \
		-DPOSTGRES_HOST=${POSTGRES_HOST} \
		-DPOSTGRES_PORT=${POSTGRES_PORT} \
		-DPOSTGRES_DB=${POSTGRES_DB} \
		-DPOSTGRES_USER=${POSTGRES_USER} \
		-DPOSTGRES_PASSWORD=${POSTGRES_PASSWORD} \
		-DMAINSERVER_PORT=${MAINSERVER_PORT} \
		-DMAINSERVER_VERSION=${MAINSERVER_VERSION} \
		-DMAINSERVER_SSL_PASSWORD=${MAINSERVER_SSL_PASSWORD} \
		-jar target/MainServer-${MAINSERVER_VERSION}.jar
