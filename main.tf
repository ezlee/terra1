
provider "docker" {
    host = "tcp://192.168.56.11:4000/"
}

resource "docker_container" "elasticsearch" {
    image        = "${docker_image.elasticsearch.latest}"
    name         = "elasticsearch"
    entrypoint   = ["/usr/sbin/init"]
    must_run     = false
    network_mode = "bridge"
    ports {
        internal = 9200
        external = 9200
    }
    volumes {
        host_path      = "/sys/fs/cgroup"
        container_path = "/sys/fs/cgroup"
        read_only      = true
    }
    volumes {
        host_path      = "${var.mktemp}-elasticsearch"
        container_path = "/run"
        read_only      = false
    }
}

resource "docker_image" "elasticsearch" {
    name = "192.168.56.11:5000/digital/immutable-elasticsearch:latest"
}

resource "terraform_remote_state" "consul" {
    backend = "consul"
    config{
        path = "terraform/digital/elasticsearch"
        address = "192.168.56.11"
    }
}

