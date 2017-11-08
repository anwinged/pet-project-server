configure:
	ansible-playbook --inventory "ansible/hosts_prod" --user=av --ask-become-pass ansible/configuration.yml

install-roles:
	ansible-galaxy install -r "ansible/requirements.yml"

test-rebuild:
	vagrant destroy -f && vagrant up

lint-configuration:
	ansible-lint "./ansible/configuration.yml" --exclude="./ansible/galaxy.roles/" -v || true
	ansible-lint "./ansible/roles/ssl-certificate/tasks/main.yml" -v || true

check-configure:
	ansible-playbook --inventory "ansible/hosts_prod" --user=av --ask-become-pass --check ansible/configuration.yml
