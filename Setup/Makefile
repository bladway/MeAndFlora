install:
	sudo apt install docker-compose && \
	sudo usermod -aG docker $$USER && \
	sudo service docker restart

rm:
	docker-compose stop && \
	docker-compose rm && \
	sudo rm -rf /server/

up:
	docker-compose -f ./docker-compose-MeAndFlora.yml up -d

# "make up" to up the docker containers