import os
import shlex
import fabric
from invoke import task

SERVER_HOST_FILE = "ansible/hosts_prod"
DOKER_REGISTRY = "cr.yandex/crplfk0168i4o8kd7ade"


@task(name="deploy:gitea")
def deploy_gitea(context):
    deploy("gitea", dirs=["data"])


@task(name="deploy:wiki")
def deploy_wiki(context):
    deploy("wiki")


@task(name="deploy:keycloak")
def deploy_wiki(context):
    deploy("keycloak", compose_file="docker-compose.prod.yml", dirs=["data"])


@task(name="deploy:outline")
def deploy_wiki(context):
    deploy("outline", compose_file="docker-compose.prod.yml", dirs=["data/postgres"])


def read_host():
    with open(SERVER_HOST_FILE) as f:
        return f.read().strip()


def ssh_host(app_name):
    return f"{app_name}@{read_host()}"


def deploy(app_name: str, compose_file="docker-compose.yml", dirs=None):
    docker_compose = os.path.join("app", app_name, compose_file)
    assert os.path.exists(docker_compose)
    conn_str = ssh_host(app_name)
    dirs = dirs or []
    print("Deploy app from", docker_compose)
    print("Start setup remote host", conn_str)
    with fabric.Connection(conn_str) as c:
        print("Copy docker compose file to remote host")
        c.put(
            local=docker_compose,
            remote=f"/home/{app_name}/docker-compose.yml",
        )
        print("Copy environment file")
        c.run("cp .env .env.prod")
        for d in dirs:
            print("Create remote directory", d)
            c.run(f"mkdir -p {d}")
        print("Up services")
        c.run(
            f"docker-compose --project-name {shlex.quote(app_name)} --env-file=.env.prod up --detach --remove-orphans"
        )
    print("Done.")
