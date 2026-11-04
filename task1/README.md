# Task 1 — Основы управления конфигурацией инфраструктуры с Terraform

Отчёт: [docs/report.md](../docs/report.md) (раздел «Задание 1»).

## Что делает

Пройдены семь руководств трека Get Started - Docker: описан контейнер
с nginx, он создан, изменён, уничтожен; значение вынесено в переменную,
а идентификаторы выведены через outputs.

## Состав

```
task1/
├── main.tf        — образ и контейнер nginx (провайдер kreuzwerker/docker)
├── variables.tf   — входная переменная web_name
├── outputs.tf     — выходы web_container_id и web_image_id
└── README.md      — этот файл
```

Служебные файлы Terraform (`.terraform/`, `terraform.tfstate*`) в репозиторий
не коммитятся — см. `.gitignore` в корне проекта.

## Порядок выполнения

```powershell
cd task1
terraform --version
terraform init
terraform fmt
terraform validate
terraform apply            # yes
curl.exe http://localhost:8090/
terraform show
terraform state list
# Change: external 8090 -> 8091 в main.tf, затем terraform apply
terraform apply -var "web_name=AnotherWebName"
terraform output
terraform destroy          # yes
```

## Автор

Бельский Тимофей Дмитриевич, группа 11а
