configure:
	ansible-playbook --inventory "ansible/hosts_prod" --user=av --ask-become-pass ansible/configuration.yml
