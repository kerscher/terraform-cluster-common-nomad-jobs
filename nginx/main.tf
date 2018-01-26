data "template_file" "nginx" {
  count    = "${var.run}"
  template = "${file("${path.module}/templates/nginx.hcl")}"

  vars {
    job_name    = "${var.job_name}"
    region      = "${var.region}"
    datacenters = "${join(",",var.datacenters)}"
    cpu_limit   = "${var.cpu_limit}"
    mem_limit   = "${var.mem_limit}"
    net_limit   = "${var.net_limit}"
    node_class  = "${var.node_class}"
  }
}

resource "nomad_job" "nginx" {
  jobspec = "${data.template_file.nginx.rendered}"
}
