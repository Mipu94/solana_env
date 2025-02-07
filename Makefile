PROJECT = test_solana
COMPOSE_FILE = docker-compose.yml

.PHONY: install
install:
	sudo docker-compose -f $(COMPOSE_FILE) -p $(PROJECT) up -d --build

.PHONY: deploy
deploy:
	sudo docker exec -it ${PROJECT}_app /bin/sh -c 'npm install'


.PHONY: create_wallet
create_wallet:
	sudo docker exec -it ${PROJECT}_app /bin/sh -c 'solana-keygen new --outfile ./solana-config/id.json --no-bip39-passphrase'
	sudo docker exec -it ${PROJECT}_app /bin/sh -c 'solana airdrop 2 --keypair ./solana-config/id.json'

.PHONY: restart
restart:
	sudo docker-compose -f $(COMPOSE_FILE) -p $(PROJECT) kill && \
	sudo docker-compose -f $(COMPOSE_FILE) -p $(PROJECT) rm -f && \
	sudo docker-compose -f $(COMPOSE_FILE) -p $(PROJECT) up -d --build


.PHONY: clean
clean:
	sudo docker-compose -f $(COMPOSE_FILE) -p $(PROJECT) down --rmi all

.PHONY: shell
shell:
	sudo docker exec -u root -it ${PROJECT}_app /bin/bash
