configure:
	ansible-playbook --inventory "ansible/hosts_prod" --user=av --ask-become-pass ansible/configuration.yml

install-roles:
	ansible-galaxy install -r "ansible/requirements.yml"
