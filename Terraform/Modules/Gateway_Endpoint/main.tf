resource "aws_vpc_endpoint" "gateway" {
  vpc_id       = var.vpc_id
  service_name = var.service_name[0]

  route_table_ids = var.route_table_ids
}
