##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  # access_key = "ACCESS_KEY"
  # secret_key = "SECRET_KEY"
  # region     = "us-east-1"
  profile = "acloud-guru"
}


##################################################################################
# RESOURCES
##################################################################################


########
# DATA
########

# Declare the data source
data "aws_availability_zones" "available" {
  state = "available"
}

# NETWORKING #
resource "aws_vpc" "app" {
  cidr_block           = var.vpc_app_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = local.common_tags

}

resource "aws_internet_gateway" "app" {
  vpc_id = aws_vpc.app.id

  tags = local.common_tags

}

resource "aws_subnet" "public_subnet1" {
  cidr_block              = var.vpc_public_subnets_cidr_block[0]
  vpc_id                  = aws_vpc.app.id
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = local.common_tags

}

resource "aws_subnet" "public_subnet2" {
  cidr_block              = var.vpc_public_subnets_cidr_block[1]
  vpc_id                  = aws_vpc.app.id
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = data.aws_availability_zones.available.names[1]

  tags = local.common_tags
}

# ROUTING #
resource "aws_route_table" "app" {
  vpc_id = aws_vpc.app.id

  route {
    cidr_block = var.route_table_cidr_block
    gateway_id = aws_internet_gateway.app.id
  }

  tags = local.common_tags
}

resource "aws_route_table_association" "app_subnet1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.app.id

}

resource "aws_route_table_association" "app_subnet2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.app.id

}

# SECURITY GROUPS #
# Nginx security group 
resource "aws_security_group" "nginx_sg" {
  name   = "nginx_sg"
  vpc_id = aws_vpc.app.id
  tags   = local.common_tags

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "alb_sg" {
  name   = "nginx_alb_sg"
  vpc_id = aws_vpc.app.id
  tags   = local.common_tags

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


