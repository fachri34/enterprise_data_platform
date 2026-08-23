from cosmos import DbtTaskGroup
from cosmos.config import ProjectConfig, ProfileConfig, RenderConfig, ExecutionConfig
from cosmos.constants import TestBehavior
from cosmos.profiles import GoogleCloudServiceAccountFileProfileMapping
import os 


DBT_PROJECT_PATH = f"{os.environ['AIRFLOW_HOME']}/dags/warehouse"


project_config = ProjectConfig(
    dbt_project_path=DBT_PROJECT_PATH,
    project_name="warehouse_pipeline",
)


execution_config = ExecutionConfig(
    dbt_executable_path="/opt/airflow/dbt_venv/bin/dbt",
)


profile_config = ProfileConfig(
    profile_name="warehouse_pipeline",
    target_name="dev",
    profile_mapping=GoogleCloudServiceAccountFileProfileMapping(
        conn_id="google_cloud_default",
        profile_args={
            "project": "adventureworks-pipeline-501611",
            "dataset": "raw",
        },
    ),
)


def create_dbt_task_group(group_id: str, select_path: str):

    return DbtTaskGroup(
        group_id=group_id,
        project_config=project_config,
        profile_config=profile_config,
        execution_config=execution_config,
        render_config=RenderConfig(
            select=[select_path],
            emit_datasets=True,
            test_behavior=TestBehavior.AFTER_ALL,
        ),
        operator_args={
            "install_deps": True,
        },
    )


def main():

    dbt_staging = create_dbt_task_group(
        group_id="dbt_staging",
        select_path="path:models/staging",
    )

    dbt_intermediate = create_dbt_task_group(
        group_id="dbt_intermediate",
        select_path="path:models/intermediate",
    )

    dbt_marts = create_dbt_task_group(
        group_id="dbt_marts",
        select_path="path:models/marts",
    )

    dbt_analytics = create_dbt_task_group(
        group_id="dbt_analytics",
        select_path="path:models/analytics",
    )

    dbt_features = create_dbt_task_group(
        group_id="dbt_features",
        select_path="path:models/features",
    )

    dbt_staging >> dbt_intermediate >> dbt_marts

    dbt_marts >> dbt_analytics
    dbt_marts >> dbt_features

    return dbt_analytics