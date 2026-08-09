# AdventureWorks Data Platform

End-to-end data platform project built using the **AdventureWorks dataset** to demonstrate modern data engineering, analytics, machine learning, MLOps, AI, and event-driven architecture.

## Tech Stack

### Core Platform

- Python
- SQL
- Docker
- Apache Airflow
- dbt

### Data Platform

- PostgreSQL
- MinIO
- BigQuery

### Analytics

- Metabase

## Milestones

| Milestone | Description                       | Status         |
| --------- | --------------------------------- | -------------- |
| 1         | Modern ELT Platform               | ✅ Completed |
| 2         | Analytics & Reverse ETL           | 🚧 In Progress  |
| 3         | ML Platform & Feature Store       | ⏳ Planned      |
| 4         | Production MLOps Platform         | ⏳ Planned      |
| 5         | AI Analytics Platform / RAG       | ⏳ Planned      |
| 6         | Agent Platform / MCP              | ⏳ Planned      |
| 7         | Event-Driven Application Platform | ⏳ Planned      |


## How to Run

### Prerequisites

* Docker
* Docker Compose
* Git
* Google Cloud / BigQuery credentials
* Makefile

### Setup

```bash
git clone https://github.com/fachri34/enterprise_data_platform.git
cd enterprise_data_platform
```

Configure the required environment variables and credentials, then start the services:

```bash
make compose-up
```

The detailed execution steps for each milestone are documented in its respective README.

## Project Goal

The goal of this project is to demonstrate the evolution of a data platform from a **modern ELT pipeline** into a broader platform covering:

**Data Engineering → Analytics → Machine Learning → MLOps → AI → Agents → Event-Driven Applications**
