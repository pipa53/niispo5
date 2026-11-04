# Описание инфраструктуры для Task 1: контейнер с nginx через Docker-провайдер.
# Основа — руководство Terraform Get Started - Docker (раздел Build infrastructure).

# Блок terraform: перечень провайдеров и правила выбора их версий.
terraform {
  required_providers {
    docker = {
      # Провайдер из сообщества: registry.terraform.io/kreuzwerker/docker.
      source = "kreuzwerker/docker"
      # Ограничение на мажорную ветку: обновления не ломают конфигурацию.
      version = "~> 4.2.0"
    }
  }
}

# Параметры провайдера Docker. Пустой блок означает использование
# значений по умолчанию — подключение к локальному Docker Engine.
provider "docker" {}

# Ресурс 1: образ веб-сервера. Подтягивается при apply, кешируется локально.
resource "docker_image" "web" {
  name         = "nginx:1.27-alpine"
  keep_locally = false
}

# Ресурс 2: контейнер, создаваемый из образа выше.
# Ссылка на image_id задаёт зависимость — Terraform сам выстроит
# правильный порядок операций.
resource "docker_container" "web" {
  image = docker_image.web.image_id
  # Имя контейнера берётся из переменной (см. variables.tf).
  name = var.web_name
  ports {
    internal = 80
    external = 8091
  }
}
