PLAYBOOK := ansible/configuration.yml
STAGE := vagrant

ifeq ($(STAGE), prod)
	ANSIBLE_HOST_KEY_CHECKING := True
	INVENTORY := ansible/hosts_prod
	USER_ARGS := --user="major" --become
else
	ANSIBLE_HOST_KEY_CHECKING := False
	INVENTORY := ansible/hosts_vagrant
	USER_ARGS := --user="root"
endif

ifneq ($(TAGS),)
	TAGS_ARGS := --tags="$(TAGS)"
else
	TAGS_ARGS :=
endif

# Tasks

install-roles:
	ansible-galaxy install \
		--role-file "ansible/requirements.yml" \
		--force

rebuild-test-machine:
	vagrant destroy -f && vagrant up

edit-vars:
	EDITOR=micro \
	ansible-vault edit ansible/vars/vars.yml

configure:
	ANSIBLE_HOST_KEY_CHECKING=$(ANSIBLE_HOST_KEY_CHECKING) \
	ansible-playbook \
		$(USER_ARGS) \
		$(TAGS_ARGS) \
		--inventory="$(INVENTORY)" \
		--extra-vars='ansible_python_interpreter=/usr/bin/python3' \
		-vvv \
		$(PLAYBOOK)

configure-prod:
	$(MAKE) configure STAGE="prod"

configure-monitoring:
	$(MAKE) configure STAGE="prod" TAGS="monitoring"

configure-apps:
	$(MAKE) configure TAGS="webserver,apps,env"

configure-apps-in-prod:
	$(MAKE) configure STAGE="prod" TAGS="webserver,apps,env"

configure-users:
	$(MAKE) configure TAGS="apps,env"

dry-run:
	ANSIBLE_HOST_KEY_CHECKING=$(ANSIBLE_HOST_KEY_CHECKING) \
	ansible-playbook \
		$(USER_ARGS) \
		$(TAGS_ARGS) \
		--inventory="$(INVENTORY)" \
		--extra-vars='ansible_python_interpreter=/usr/bin/python3' \
		--check \
		--diff -vvv \
		$(PLAYBOOK)

list-tags:
	ansible-playbook \
		--inventory="$(INVENTORY)" \
		--list-tags \
		$(PLAYBOOK)

lint:
	ansible-lint "./ansible/configuration.yml" --exclude="./ansible/galaxy.roles/" -v || true
	ansible-lint "./ansible/roles/ssl-certificate/tasks/main.yml" -v || true

caddy-hash-password:
	docker run -it caddy:2.5.2 caddy hash-password --plaintext="$(PASS)"
