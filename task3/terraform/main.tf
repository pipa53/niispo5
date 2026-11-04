# Terraform: локальный kind-кластер для Task 3 (вариант 2, DinD).
# Провайдер tehcyx/kind создаёт кластер как обычный ресурс,
# поэтому удаление кластера сводится к terraform destroy.

terraform {
  required_providers {
    # Провайдер, управляющий kind-кластерами из Terraform.
    kind = {
      source  = "tehcyx/kind"
      version = "0.11.0"
    }
  }
}

# Настройки провайдера не нужны: работаем с локальным Docker.
provider "kind" {}

# Кластер k8s-lab: один control-plane и два worker
# (каждая нода — контейнер Docker).
# Имена нод заданы явно: k8s-lab-control-plane, k8s-lab-worker,
# k8s-lab-worker2.
resource "kind_cluster" "k8s_lab" {
  name           = "k8s-lab"
  wait_for_ready = true
  # Отдельный файл kubeconfig: не затрагивает кластеры других лабораторных
  # работ. Путь не зависит от учётной записи Windows.
  kubeconfig_path = "C:/k8s-lab/kubeconfig"

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"
    }

    node {
      role = "worker"
    }

    node {
      role = "worker"
    }
  }
}

# Имя контекста kubectl, по которому работают Ansible и kubectl.
output "cluster_context" {
  description = "Kubectl context name of the kind cluster"
  value       = "kind-k8s-lab"
}
