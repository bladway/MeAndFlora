install:
	sudo apt install docker-compose && \
	sudo usermod -aG docker $$USER && \
	sudo service docker restart

rm:
	docker-compose -f ./docker-compose-MeAndFlora.yml stop && \
	docker-compose -f ./docker-compose-MeAndFlora.yml rm && \
	docker volume rm MeAndFlora-Database \
	docker volume rm MeAndFlora-Cachebase \
	sudo rm -rf /server/

up:
	docker volume create --driver local --opt type=volume --opt device=:/server/MeAndFlora-Database MeAndFlora-Database \
	docker volume create --driver local --opt type=volume --opt device=:/server/MeAndFlora-Cachebase MeAndFlora-Cachebase \
	docker-compose -f ./docker-compose-MeAndFlora.yml up -d

# "make up" to up the docker containers