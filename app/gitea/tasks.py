from fabric import Connection
from invoke import task
import shlex

APP_NAME = "gitea"
SSH_HOST = f"{APP_NAME}@51.250.85.23"
DOCKER_REGISTRY = "cr.yandex/crplfk0168i4o8kd7ade"


@task
def deploy(c):
    print("Ready to setup remote host")
    with Connection(SSH_HOST) as c:
        c.put(
            local="docker-compose.yml",
            remote=f"/home/{APP_NAME}/docker-compose.yml",
        )
        c.run("cp .env .env.prod")
        c.run("mkdir -p data")
        c.run(f"docker-compose --project-name {shlex.quote(APP_NAME)} --env-file=.env.prod up --detach --remove-orphans")
