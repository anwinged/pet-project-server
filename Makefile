install-roles:
	ansible-galaxy install -r "ansible/requirements.yml"

test-rebuild:
	vagrant destroy -f && vagrant up

configure:
	ansible-playbook \
		--inventory "ansible/hosts_prod" \
		--extra-vars='ansible_python_interpreter=/usr/bin/python3' \
		--user=av \
		--ask-become-pass \
		ansible/configuration.yml

configure-web-server:
	ansible-playbook \
		--inventory "ansible/hosts_prod" \
		--extra-vars='ansible_python_interpreter=/usr/bin/python3' \
		--user=av \
		--ask-become-pass \
		--tags webserver \
		ansible/configuration.yml

dry-run:
	ansible-playbook \
		--inventory "ansible/hosts_prod" \
		--extra-vars='ansible_python_interpreter=/usr/bin/python3' \
		--user=av \
		--ask-become-pass \
		--check \
		--diff \
		ansible/configuration.yml

configure-test:
	ansible-playbook \
		--inventory "ansible/hosts_vagrant" \
		--extra-vars 'ansible_python_interpreter=/usr/bin/python3' \
		--user root \
		ansible/amber.yml

lint:
	ansible-lint "./ansible/configuration.yml" --exclude="./ansible/galaxy.roles/" -v || true
	ansible-lint "./ansible/roles/ssl-certificate/tasks/main.yml" -v || true
