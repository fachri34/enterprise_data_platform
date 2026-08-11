include .env

compose-up: postgres-up minio-up airflow-up metabase-up	
	@echo '__________________________________________________________'
	@echo 'All containers are up and running...'
	@echo '==========================================================='

postgres-up:
	@echo '__________________________________________________________'
	@echo 'Creating PostgreSQL Source...'
	@echo '__________________________________________________________'
	@docker compose -f ./docker/postgres/docker-compose.yml --env-file .env up -d
	@echo '==========================================================='

minio-up:
	@echo '__________________________________________________________'
	@echo 'Creating MinIO Data Lake...'
	@echo '__________________________________________________________'
	@docker compose -f ./docker/minio/docker-compose.yml --env-file .env up -d
	@echo '==========================================================='

airflow-up:
	@echo '__________________________________________________________'
	@echo 'Creating Airflow Instance...'
	@echo '__________________________________________________________'
	@docker compose -f ./docker/airflow/docker-compose.yml --env-file .env up -d
	@echo '==========================================================='

metabase-up:
	@echo '__________________________________________________________'
	@echo 'Initializing Metabase...'
	@echo '__________________________________________________________'
	@docker compose -f ./docker/metabase/docker-compose.yml --env-file .env up -d
	@echo '==========================================================='

airflow-compose-build:
	@echo '__________________________________________________________'
	@echo 'Building Airflow Instance...'
	@echo '__________________________________________________________'
	@docker compose -f ./docker/airflow/docker-compose.yml --env-file .env build --no-cache
	@echo '==========================================================='

airflow-connection:
	@echo '__________________________________________________________'
	@echo 'Creating Connection and Variables Airflow Instance...'
	@docker exec -i airflow-webserver airflow connections import /init/variables_and_connections/airflow_connections_init.yml
	@docker exec -i airflow-webserver airflow variables import -a overwrite /init/variables_and_connections/airflow_variables_init.json
	@echo '==========================================================='

compose-down: postgres-down minio-down airflow-down metabase-down
	@echo '__________________________________________________________'
	@echo 'All containers are down...'
	@echo '==========================================================='

postgres-down:
	@echo 'Stopping PostgreSQL...'
	@docker compose -f ./docker/postgres/docker-compose.yml --env-file .env down

minio-down:
	@echo 'Stopping MinIO...'
	@docker compose -f ./docker/minio/docker-compose.yml --env-file .env down

airflow-down:
	@echo 'Stopping Airflow...'
	@docker compose -f ./docker/airflow/docker-compose.yml --env-file .env down

metabase-down:
	@echo 'Stopping Metabase...'
	@docker compose -f ./docker/metabase/docker-compose.yml --env-file .env down
