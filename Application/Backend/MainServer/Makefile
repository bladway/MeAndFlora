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
		-Djib.container.environment=
		POSTGRES_HOST="",\
		POSTGRES_DB="",\
		POSTGRES_USER="",\
		POSTGRES_PASSWORD="",\
		POSTGRES_PORT="",\
		KAFKA_USER="",\
		KAFKA_PASSWORD="",\
		KAFKA_HOST="",\
		KAFKA_PORT="",\
		MAINSERVER_KAFKA_CLIENT_ID="${MAINSERVER_KAFKA_CLIENT_ID}",\
		MAINSERVER_VERSION="${MAINSERVER_VERSION}",\
		MAINSERVER_SSL_PASSWORD="${MAINSERVER_SSL_PASSWORD}",\
		MAINSERVER_PORT="",\
		MAINSERVER_SSL_PATH="/ssl/MeAndFlora-SSL.p12",\
		MAINSERVER_IMAGES_PATH="/images/",\
		MAINSERVER_IMAGES_PROC_PATH="proc/",\
		MAINSERVER_IMAGES_GET_PATH="get/",\
		MAINSERVER_JWT_PASSWORD="${MAINSERVER_JWT_PASSWORD}",\
		MAINSERVER_JWT_R_PASSWORD="${MAINSERVER_JWT_R_PASSWORD}",\
		MAINSERVER_JWT_LIFETIME="${MAINSERVER_JWT_LIFETIME}",\
		MAINSERVER_JWT_R_LIFETIME="${MAINSERVER_JWT_R_LIFETIME}"


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
		-DKAFKA_USER=${KAFKA_USER} \
		-DKAFKA_PASSWORD=${KAFKA_PASSWORD} \
		-DKAFKA_HOST=${KAFKA_HOST} \
		-DKAFKA_PORT=${KAFKA_PORT} \
		-DMAINSERVER_KAFKA_CLIENT_ID=${MAINSERVER_KAFKA_CLIENT_ID} \
		-DMAINSERVER_PORT=${MAINSERVER_PORT} \
		-DMAINSERVER_VERSION=${MAINSERVER_VERSION} \
		-DMAINSERVER_SSL_PASSWORD=${MAINSERVER_SSL_PASSWORD} \
		-DMAINSERVER_SSL_PATH=${MAINSERVER_SSL_PATH} \
		-DMAINSERVER_IMAGES_PATH=${MAINSERVER_IMAGES_PATH} \
		-DMAINSERVER_IMAGES_PROC_PATH=${MAINSERVER_IMAGES_PROC_PATH} \
		-DMAINSERVER_IMAGES_GET_PATH=${MAINSERVER_IMAGES_GET_PATH} \
		-DMAINSERVER_JWT_PASSWORD=${MAINSERVER_JWT_PASSWORD} \
		-DMAINSERVER_JWT_R_PASSWORD=${MAINSERVER_JWT_R_PASSWORD} \
		-DMAINSERVER_JWT_LIFETIME=${MAINSERVER_JWT_LIFETIME} \
		-DMAINSERVER_JWT_R_LIFETIME=${MAINSERVER_JWT_R_LIFETIME} \
		-jar target/MainServer-${MAINSERVER_VERSION}.jar
