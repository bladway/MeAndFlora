install:
	sudo apt install docker-compose && \
	sudo usermod -aG docker $$USER && \
	sudo service docker restart

rm:
	sudo rm -rf /server/ && \
	docker-compose -f ./docker-compose-MeAndFlora.yml --env-file ./config.env stop && \
	docker-compose -f ./docker-compose-MeAndFlora.yml --env-file ./config.env rm && \
	docker volume rm MeAndFlora-Database && \
	docker volume rm MeAndFlora-Cachebase

up:
	sudo mkdir /server
	sudo mkdir  /server/MeAndFlora-Database && \
	sudo mkdir /server/MeAndFlora-Cachebase && \
	docker-compose -f ./docker-compose-MeAndFlora.yml --env-file ./config.env up -d

# "make up" to up the docker containers