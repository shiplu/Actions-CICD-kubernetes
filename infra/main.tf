resource "google_container_cluster" "mycluster" {
  name     = "my-cluster"
  location = var.project_region
  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  node_config {
    metadata = {
      # This is deprecated and recommended by google
      disable-legacy-endpoints = "true"
    }
  }
  node_pool {
    # Just add minimum amount of nodes to achieve HA otherwise it becomes expensive
    initial_node_count = 2
  }
}
