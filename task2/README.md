# Task 2 — Управление конфигурацией серверов с помощью Ansible

Отчёт: [docs/report.md](../docs/report.md) (раздел «Задание 2»).

## Что делает

Ansible управляет конфигурацией узлов: опись узлов, разовые ad-hoc
команды и playbook, приводящий узлы к заданному состоянию.

## Состав

```
task2/
├── inventory.ini  — группа nodes (локальный хост, connection=local)
├── setup.yaml     — playbook: установка пакетов + файл motd
└── README.md      — этот файл
```

## Порядок выполнения (в WSL-Ubuntu)

Файлы задания копируются в `/root/ansible-lab/`:

```powershell
cd C:\Lab 5\task2
wsl -d Ubuntu -u root mkdir -p /root/ansible-lab
wsl -d Ubuntu -u root cp /mnt/c/Lab\ 5/task2/* /root/ansible-lab/
```

Далее — внутри WSL:

```bash
cd /root/ansible-lab
ansible --version
ansible-inventory -i inventory.ini --list
ansible nodes -i inventory.ini -m ping
ansible nodes -i inventory.ini -m ansible.builtin.apt -a "name=tree state=present"
ansible-playbook -i inventory.ini setup.yaml
cat /etc/motd.custom
htop --version
```

> Виртуальных машин из ЛР4 нет (там применялся kind в Docker), поэтому
> узлом выступает локальный хост WSL-Ubuntu с `connection=local`.

## Автор

Бельский Тимофей Дмитриевич, группа 11а
