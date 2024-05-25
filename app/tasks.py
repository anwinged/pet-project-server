from invoke import task

SERVER_HOST_FILE = "../ansible/hosts_prod"
DOKER_REGISTRY = "cr.yandex/crplfk0168i4o8kd7ade"


@task(name="deploy:gitea")
def deploy_gitea(context):
    from gitea.deploy import deploy

    deploy(context, "gitea", ssh_host("gitea"))


@task(name="deploy:wiki")
def deploy_wiki(context):
    from wiki.deploy import deploy

    deploy(context, "wiki", ssh_host("wiki"))


def read_host():
    with open("../ansible/hosts_prod") as f:
        return f.read().strip()


def ssh_host(app_name):
    return f"{app_name}@{read_host()}"
