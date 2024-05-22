# Attention, before using commands
# make sure you have received or done the correct files:
# deployment.env, kafka_server_jaas.conf

include deployment.env

install:
	sudo apt install docker-compose && \
	sudo usermod -aG docker $$USER && \
	sudo service docker restart

hard-rm:
	docker-compose -f ./docker-compose-MeAndFlora.yml --env-file ./deployment.env stop && \
	docker-compose -f ./docker-compose-MeAndFlora.yml --env-file ./deployment.env rm -f && \
	docker volume rm MeAndFlora-Database && \
	docker volume rm MeAndFlora-Mongo && \
	docker volume rm MeAndFlora-Cachebase && \
	docker volume rm MeAndFlora-GetImages && \
	docker volume rm MeAndFlora-ProcImages && \
	sudo rm -rf /server/

hard-up:
	sudo mkdir /server && \
	sudo mkdir /server/MeAndFlora-Database && \
	sudo mkdir /server/MeAndFlora-Mongo && \
	sudo mkdir /server/MeAndFlora-Cachebase && \
	sudo mkdir /server/MeAndFlora-GetImages && \
	sudo mkdir /server/MeAndFlora-ProcImages && \
	docker pull bladway/maf-mainserver && \
	docker pull dkotx/detector && \
	docker-compose -f ./docker-compose-MeAndFlora.yml --env-file ./deployment.env up -d

hard-restart:
	make hard-rm && \
	make hard-up

soft-rm:
	docker-compose -f ./docker-compose-MeAndFlora.yml --env-file ./deployment.env stop && \
	docker-compose -f ./docker-compose-MeAndFlora.yml --env-file ./deployment.env rm -f && \
	docker volume rm MeAndFlora-GetImages && \
	sudo rm -rf /server/MeAndFlora-GetImages/

soft-up:
	sudo mkdir /server/MeAndFlora-GetImages && \
	docker pull bladway/maf-mainserver && \
	docker pull dkotx/detector && \
	docker-compose -f ./docker-compose-MeAndFlora.yml --env-file ./deployment.env up -d

soft-restart:
	make soft-rm && \
	make soft-up



