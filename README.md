# Pet Project Server

Настройки виртуального сервера для домашних проектов.

## Требования

- [ansible](https://docs.ansible.com/ansible/latest/getting_started/index.html)

## Установка

```bash
$ cp ansible-vault-password-file.dist ansible-vault-password-file
$ ansible-galaxy install --role-file ansible/requirements.yml
```

## Структура

- Для каждого приложения создается свой пользователь.
- Для доступа используется ssh-ключ.
- Докер используется для запуска и изоляции приложений. Для загрузки образов настраивается Yandex Docker Registry.
- Выход во внешнюю сеть через proxy-server Caddy.
- Чувствительные данные в `ansible/vars/vars.yaml` зашифрованы с помощью Ansible Vault.
- Для мониторинга за сервером устанавливается [netdata](https://github.com/netdata/netdata).

## Частые команды

Конфигурация приложений (если нужно добавить новое приложение):

```bash
$ task configure-apps
```

Конфигурация мониторинга (если нужно обновить netdata):

```bash
$ task configure-monitoring
```

## Деплой приложений

- Нужно зайти в директорию приложения. Например, `app/gitea`.
- Выполнить из директории приложения `invoke deploy`. 
