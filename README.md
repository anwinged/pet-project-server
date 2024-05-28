# Pet Project Server

Настройки виртуального сервера для домашних проектов.

> В этом проекте не самые оптимальные решения.
> Но они помогают мне поддерживать сервер для моих личных проектов уже семь лет. 

## Требования

- [ansible](https://docs.ansible.com/ansible/latest/getting_started/index.html)
- [invoke](https://www.pyinvoke.org/)
- [task](https://taskfile.dev/)

## Установка

```bash
$ cp ansible-vault-password-file.dist ansible-vault-password-file
$ ansible-galaxy install --role-file ansible/requirements.yml
```

## Структура

- Для каждого приложения создается свой пользователь.
- Для доступа используется ssh-ключ.
- Докер используется для запуска и изоляции приложений. Для загрузки образов настраивается Yandex Docker Registry.
- Выход во внешнюю сеть через proxy server [Caddy](https://caddyserver.com/).
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

Доступные для деплоя приложения:

```bash
invoke --list
```

Выполнить команду деплоя, например:

```bash
invoke deploy:gitea
```
