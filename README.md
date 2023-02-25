# Servers

Настройки виртуального сервера для домашних проектов.

## Требования

- Ansible

## Установка

    $ ansible-galaxy install --role-file ansible/requirements.yml

## Структура

- Приложению создается свой пользователь.
- Для доступа используется ssh-ключ.
- Докер можно использовать для запуска.
- Выход во внешнюю сеть через proxy-server Caddy.
- Чувствительные данные в `ansible/vars/vars.yaml` зашифрованы с помощью Ansible Vault.

## Частые команды

Конфигурация приложений:

    $ make configure STAGE=prod TAGS=apps

Конфигурация мониторинга:

    $ make configure STAGE=prod TAGS=monitoring
