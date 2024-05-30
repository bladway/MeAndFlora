# Attention, before using commands
# make sure you have received or done the correct file:
# deployment.env

include deployment.env

install:
	echo ${SERVER_PASSWORD} | sudo -S apt install docker-compose && \
	echo ${SERVER_PASSWORD} | sudo -S usermod -aG docker $$USER && \
	echo ${SERVER_PASSWORD} | sudo -S service docker restart

hard-rm:
	docker-compose -f ./docker-compose-MeAndFlora.yml --env-file ./deployment.env stop && \
	docker-compose -f ./docker-compose-MeAndFlora.yml --env-file ./deployment.env rm -f && \
	docker volume rm MeAndFlora-Database && \
	docker volume rm MeAndFlora-Mongo && \
	docker volume rm MeAndFlora-Cachebase && \
	docker volume rm MeAndFlora-GetImages && \
	docker volume rm MeAndFlora-ProcImages && \
	echo ${SERVER_PASSWORD} | sudo -S rm -rf /server/

hard-up:
	echo ${SERVER_PASSWORD} | sudo -S mkdir /server && \
	echo ${SERVER_PASSWORD} | sudo -S mkdir /server/MeAndFlora-Database && \
	echo ${SERVER_PASSWORD} | sudo -S mkdir /server/MeAndFlora-Mongo && \
	echo ${SERVER_PASSWORD} | sudo -S mkdir /server/MeAndFlora-Cachebase && \
	echo ${SERVER_PASSWORD} | sudo -S mkdir /server/MeAndFlora-GetImages && \
	echo ${SERVER_PASSWORD} | sudo -S mkdir /server/MeAndFlora-ProcImages && \
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
	echo ${SERVER_PASSWORD} | sudo -S rm -rf /server/MeAndFlora-GetImages/

soft-up:
	echo ${SERVER_PASSWORD} | sudo -S mkdir /server/MeAndFlora-GetImages && \
	docker pull bladway/maf-mainserver && \
	docker pull dkotx/detector && \
	docker-compose -f ./docker-compose-MeAndFlora.yml --env-file ./deployment.env up -d

soft-restart:
	make soft-rm && \
	make soft-up



