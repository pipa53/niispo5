# Task 3 — Создание кластера с помощью Terraform и Ansible локально

Отчёт: [docs/report.md](../docs/report.md) (раздел «Задание 3»).

## Что делает

Вариант 2 (kind, Docker-in-Docker): Terraform создаёт kind-кластер
`k8s-lab`, Ansible разворачивает в нём приложение «Учёт надзирателей»
из ЛР1 (task5): шлюз и API на `k8s-lab-worker`, база данных —
на `k8s-lab-worker2`.

## Состав

```
task3/
├── terraform/
│   └── main.tf          — kind-кластер (провайдер tehcyx/kind)
├── ansible/
│   ├── inventory.ini    — localhost, connection=local
│   └── deploy.yaml      — плейбук: БД -> миграции -> API -> шлюз
├── k8s/
│   ├── db-statefulset.yaml  — PostgreSQL + том, нода k8s-lab-worker2
│   ├── db-service.yaml      — ClusterIP postgres:5432
│   ├── liquibase-job.yaml   — Job миграций
│   ├── app-deployment.yaml  — API ×2, нода k8s-lab-worker
│   ├── app-service.yaml     — ClusterIP api:8000
│   ├── web-configmap.yaml   — конфигурация nginx
│   ├── web-deployment.yaml  — шлюз (nginx), нода k8s-lab-worker
│   └── web-service.yaml     — NodePort — точка входа
└── README.md                — этот файл
```

## Порядок выполнения

### 1. Кластер через Terraform (PowerShell)

```powershell
cd C:\Lab 5\task3\terraform
terraform init
terraform apply            # yes
kubectl --kubeconfig=C:/k8s-lab/kubeconfig get nodes
```

Провайдер сохраняет kubeconfig в `C:/k8s-lab/kubeconfig` — отдельный
файл, чтобы не затрагивать кластеры других лабораторных работ.

### 2. Сборка образов из ЛР1 и загрузка в kind (PowerShell)

```powershell
cd C:\Lab 1\task5\app
docker build -t warden-api:lab5 .
cd ..\liquibase
docker build -t warden-migrator:lab5 .
cd C:\Lab 5\task3\terraform
kind load docker-image warden-api:lab5 warden-migrator:lab5 --name k8s-lab
```

В `liquibase.properties` адрес базы заменён на имя Service `postgres` —
так сервис разрешается через кластерный DNS.

### 3. Деплой через Ansible (WSL-Ubuntu)

Файлы задания копируются в `/root/k8s-lab/`:

```powershell
wsl -d Ubuntu -u root mkdir -p /root/k8s-lab/k8s
wsl -d Ubuntu -u root cp /mnt/c/Lab\ 5/task3/ansible/* /root/k8s-lab/
wsl -d Ubuntu -u root cp /mnt/c/Lab\ 5/task3/k8s/*.yaml /root/k8s-lab/k8s/
wsl -d Ubuntu -u root cp /mnt/c/k8s-lab/kubeconfig /root/.kube/config
```

Далее — внутри WSL:

```bash
cd /root/k8s-lab
ansible-playbook -i inventory.ini deploy.yaml
```

### 4. Проверка

В WSL-Ubuntu:

```bash
kubectl port-forward svc/gateway 8080:80
```

В PowerShell:

```powershell
curl.exe http://localhost:8080/wardens
```

Ответ — JSON со списком надзирателей из базы, наполненной миграциями.

### 5. Уничтожение (PowerShell)

```powershell
cd C:\Lab 5\task3\terraform
terraform destroy          # yes
```

## Замечание

Образы `warden-api:lab5` и `warden-migrator:lab5` собираются из проекта
задания 5 лабораторной работы №1 — перед началом работы их нужно
подготовить, иначе поды останутся в состоянии `ImagePullBackOff`.

Для доступа к кластеру из WSL в WSL-конфигурации включён зеркальный
режим сети (`networkingMode=mirrored` в `.wslconfig`): адрес API
кластера `127.0.0.1:<порт>` из WSL иначе недоступен. Благодаря этому
же порт, проброшенный из WSL, доступен и в PowerShell.

## Автор

Бельский Тимофей Дмитриевич, группа 11а
