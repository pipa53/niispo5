# Входные переменные Task 1 (раздел Define input variables).
# Позволяют менять значения без правки самого main.tf.

variable "web_name" {
  # Пояснение для человека, читающего конфигурацию.
  description = "Container name assigned to the nginx instance"
  # Тип значения — строка.
  type = string
  # Значение по умолчанию; переопределяется ключом -var.
  default = "BelskiyWebServer"
}
