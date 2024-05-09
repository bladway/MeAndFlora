# Attention, before using commands
# make sure you have received or done the correct files:
# deployment.env, kafka_server_jaas.conf

include deployment.env

install:
	sudo apt install docker-compose && \
	sudo usermod -aG docker $$USER && \
	sudo service docker restart

hard-rm:
	sudo rm -rf /server/ && \
	docker-compose -f ./docker-compose-MeAndFlora.yml --env-file ./deployment.env stop && \
	docker-compose -f ./docker-compose-MeAndFlora.yml --env-file ./deployment.env rm -f && \
	docker volume rm MeAndFlora-Database && \
	docker volume rm MeAndFlora-Mongo && \
	docker volume rm MeAndFlora-Cachebase && \
	docker volume rm MeAndFlora-Images

hard-up:
	sudo mkdir /server
	sudo mkdir  /server/MeAndFlora-Database && \
	sudo mkdir /server/MeAndFlora-Mongo && \
	sudo mkdir /server/MeAndFlora-Cachebase && \
	sudo mkdir /server/MeAndFlora-Images && \
	docker pull ${MAINSERVER_REPOSITORY}
	docker-compose -f ./docker-compose-MeAndFlora.yml --env-file ./deployment.env up -d

hard-restart:
	make hard-rm && \
	make hard-up

soft-rm:
	docker-compose -f ./docker-compose-MeAndFlora.yml --env-file ./deployment.env stop && \
	docker-compose -f ./docker-compose-MeAndFlora.yml --env-file ./deployment.env rm -f

soft-up:
	docker pull ${MAINSERVER_REPOSITORY}
	docker-compose -f ./docker-compose-MeAndFlora.yml --env-file ./deployment.env up -d

soft-restart:
	make soft-rm && \
	make soft-up



