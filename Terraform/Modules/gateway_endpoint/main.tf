resource "aws_vpc_endpoint" "gateway" {
  for_each = toset(var.service_names)

  vpc_id       = var.vpc_id
  service_name = each.value

  route_table_ids = var.route_table_ids

  tags = {
    Name = "${var.name_prefix}-${replace(replace(each.value, "com.amazonaws.", ""), ".", "-")}"
  }
}
