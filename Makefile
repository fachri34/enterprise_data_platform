include .env

compose-up: postgres minio
	@echo '__________________________________________________________'
	@echo 'All containers are up and running...'
	@echo '==========================================================='

postgres:
	@echo '__________________________________________________________'
	@echo 'Creating PostgreSQL Source...'
	@echo '__________________________________________________________'
	@docker compose -f ./docker/postgres/docker-compose.yml --env-file .env up -d
	@echo '__________________________________________________________'
	@echo 'Postgres running at port ${SRC_POSTGRES_PORT}'
	@echo '==========================================================='

minio:
	@echo '__________________________________________________________'
	@echo 'Creating MinIO Data Lake...'
	@echo '__________________________________________________________'
	@docker compose -f ./docker/minio/docker-compose.yml --env-file .env up -d
	@echo '==========================================================='


compose-down:
	@echo '__________________________________________________________'
	@echo 'Stopping and removing containers...'
	@echo '__________________________________________________________'
	@docker compose -f ./docker/postgres/docker-compose.yml --env-file .env down
	@docker compose -f ./docker/minio/docker-compose.yml --env-file .env down
	@echo '==========================================================='

delete-volumes:
	@echo '__________________________________________________________'
	@echo 'Deleting volumes...'
	@echo '__________________________________________________________'
	@docker volume rm source-volume
	@echo '==========================================================='