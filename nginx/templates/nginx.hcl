job "nginx" {
  region      = "${region}"
  datacenters = ["${datacenters}"]
  type        = "service"

  group "server" {
    count = 1

    task "ngin" {
      driver = "rkt"

      config {
        insecure_options = ["image"]
        image            = "docker://nginx"
        port_map {
          http = "80-tcp"
        }
      }

      service {
        port = "http"

        check {
          type     = "http"
          path     = "/"
          interval = "10s"
          timeout  = "2s"
        }
      }

      constraint {
        attribute = "$${node.class}"
        operator  = "="
        value     = "${node_class}"
      }

      resources {
        cpu    = ${cpu_limit}
        memory = ${mem_limit}

        network {
          mbits = ${net_limit}

          port "http" {
            static = 80
          }
        }
      }
    }
  }
}
