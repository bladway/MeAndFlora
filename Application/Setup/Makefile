# Attention, before using commands
# make sure you have received or done the correct files:
# hidden.env, kafka_server_jaas.conf
install:
	sudo apt install docker-compose && \
	sudo usermod -aG docker $$USER && \
	sudo service docker restart

rm:
	sudo rm -rf /server/ && \
	docker-compose -f ./docker-compose-MeAndFlora.yml --env-file ./hidden.env stop && \
	docker-compose -f ./docker-compose-MeAndFlora.yml --env-file ./hidden.env rm -f && \
	docker volume rm MeAndFlora-Database && \
	docker volume rm MeAndFlora-Mongo && \
	docker volume rm MeAndFlora-Cachebase


up:
	sudo mkdir /server
	sudo mkdir  /server/MeAndFlora-Database && \
	sudo mkdir /server/MeAndFlora-Mongo && \
	sudo mkdir /server/MeAndFlora-Cachebase && \
	docker-compose -f ./docker-compose-MeAndFlora.yml --env-file ./hidden.env up -d

restart:
	make rm && \
	make up