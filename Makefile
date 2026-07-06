include .env

compose-up: postgres minio airflow
	@echo '__________________________________________________________'
	@echo 'All containers are up and running...'
	@echo '==========================================================='

postgres:
	@echo '__________________________________________________________'
	@echo 'Creating PostgreSQL Source...'
	@echo '__________________________________________________________'
	@docker compose -f ./docker/postgres/docker-compose.yml --env-file .env up -d
	@echo '==========================================================='

minio:
	@echo '__________________________________________________________'
	@echo 'Creating MinIO Data Lake...'
	@echo '__________________________________________________________'
	@docker compose -f ./docker/minio/docker-compose.yml --env-file .env up -d
	@echo '==========================================================='

airflow:
	@echo '__________________________________________________________'
	@echo 'Creating Airflow Instance...'
	@echo '__________________________________________________________'
	@docker compose -f ./docker/airflow/docker-compose.yml --env-file .env up -d
	@echo '==========================================================='

airflow-down:
	@echo 'Stopping Airflow...'
	@docker compose -f ./docker/airflow/docker-compose.yml --env-file .env down

airflow-reset:
	@echo 'Removing Airflow Containers & Volumes...'
	@docker compose -f ./docker/airflow/docker-compose.yml --env-file .env down -v

airflow-connection:
	@echo '__________________________________________________________'
	@echo 'Creating Connection and Variables Airflow Instance...'
	@docker exec -i airflow-webserver airflow connections import /init/variables_and_connections/airflow_connections_init.yml
	@docker exec -i airflow-webserver airflow variables import -a overwrite /init/variables_and_connections/airflow_variables_init.json
	@echo '==========================================================='


compose-down:
	@echo '__________________________________________________________'
	@echo 'Stopping and removing containers...'
	@echo '__________________________________________________________'
	@docker compose -f ./docker/postgres/docker-compose.yml --env-file .env down
	@docker compose -f ./docker/minio/docker-compose.yml --env-file .env down
	@docker compose -f ./docker/airflow/docker-compose.yml --env-file .env down
	@echo '==========================================================='

delete-volumes:
	@echo '__________________________________________________________'
	@echo 'Deleting volumes...'
	@echo '__________________________________________________________'
	@docker volume rm source-volume
	@echo '==========================================================='