from fabric import Connection
import os
import shlex


def deploy(context, app_name, ssh_host):
    docker_compose = os.path.join(os.path.dirname(__file__), "docker-compose.yml")
    print("Deploy app from", docker_compose)
    print("Start setup remote host", ssh_host)
    with Connection(ssh_host) as c:
        c.put(
            local=docker_compose,
            remote=f"/home/{app_name}/docker-compose.yml",
        )
        c.run("cp .env .env.prod")
        c.run(
            f"docker-compose --project-name {shlex.quote(app_name)} --env-file=.env.prod up --detach --remove-orphans"
        )
