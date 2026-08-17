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


def create_dbt_task_group(group_id: str,select_path: str,):
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
