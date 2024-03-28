install:
	sudo apt install docker-compose && \
	sudo usermod -aG docker $$USER && \
	sudo service docker restart

rm:
	docker-compose -f ./docker-compose-MeAndFlora.yml stop && \
	docker-compose -f ./docker-compose-MeAndFlora.yml rm && \
	docker volume rm MeAndFlora-Database && \
	docker volume rm MeAndFlora-Cachebase && \
	sudo rm -rf /server/

up:
	sudo mkdir /server
	sudo mkdir  /server/MeAndFlora-Database && \
	sudo mkdir /server/MeAndFlora-Cachebase && \
	docker-compose -f ./docker-compose-MeAndFlora.yml up -d

# "make up" to up the docker containers