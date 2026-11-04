# Выходные значения Task 1 (раздел Query data with outputs).
# Показывают оператору сведения, взятые из state после apply,
# и пригодятся для связи с остальными частями инфраструктуры.

output "web_container_id" {
  # Пояснение к выводу.
  description = "Identifier of the running nginx container"
  # Берём идентификатор контейнера из состояния.
  value = docker_container.web.id
}

output "web_image_id" {
  description = "Identifier of the nginx image"
  value       = docker_image.web.id
}
