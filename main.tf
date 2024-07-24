
# create vpc for IBM

resource "aws_vpc" "ibm_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "ibm-vpc"
  }
}

#create subnet 

resource "aws_subnet" "ibm_public_sn" {
  vpc_id     = aws_vpc.ibm_vpc.id
  cidr_block = "10.0.0.0/20"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch= "true"

  tags = {
    Name = "ibm-web-sn"
  }
}

resource "aws_subnet" "ibm_app_sn" {
  vpc_id     = aws_vpc.ibm_vpc.id
  cidr_block = "10.0.16.0/20"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch= "true"

  tags = {
    Name = "ibm-app-sn"
  }
}
#create private subnet
resource "aws_subnet" "ibm_private_sn" {
  vpc_id     = aws_vpc.ibm_vpc.id
  cidr_block = "10.0.32.0/20"
  availability_zone = "us-east-1c"
  map_public_ip_on_launch="false"

  tags = {
    Name = "ibm-db-sn"
  }
}
# create internet gateways
resource "aws_internet_gateway" "ibm_gw" {
  vpc_id = aws_vpc.ibm_vpc.id

  tags = {
    Name = "ibm-gw"
  }
}
#create route tables public
resource "aws_route_table" "ibm_web_rt" {
  vpc_id = aws_vpc.ibm_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ibm_gw.id
  }

  tags = {
    Name = "ibm-web-rt"
  }
}

resource "aws_route_table" "ibm_app_rt" {
  vpc_id = aws_vpc.ibm_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ibm_gw.id
  }

  tags = {
    Name = "ibm-app-rt"
  }
}

#create route table for private
resource "aws_route_table" "ibm_db_rt" {
  vpc_id = aws_vpc.ibm_vpc.id

  tags = {
    Name = "ibm-db-rt"
  }
}
#subnet association public
resource "aws_route_table_association" "ibm_web_asso" {
  subnet_id      = aws_subnet.ibm_public_sn.id
  route_table_id = aws_route_table.ibm_web_rt.id
}
resource "aws_route_table_association" "ibm_app_asso" {
  subnet_id      = aws_subnet.ibm_app_sn.id
  route_table_id = aws_route_table.ibm_app_rt.id
}
# subnet association pvt
resource "aws_route_table_association" "ibm_db_asso" {
  subnet_id      = aws_subnet.ibm_private_sn.id
  route_table_id = aws_route_table.ibm_db_rt.id
}
#create nacl for public
resource "aws_network_acl" "ibm_web_nacl" {
  vpc_id = aws_vpc.ibm_vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "ibm-web-nacl"
  }
}
#subnet association nacl for web
resource "aws_network_acl_association" "ibm_nacl_association" {
  network_acl_id = aws_network_acl.ibm_web_nacl.id
  subnet_id      = aws_subnet.ibm_public_sn.id
}
resource "aws_network_acl" "ibm_app_nacl" {
  vpc_id = aws_vpc.ibm_vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "ibm-app-nacl"
  }
}
#subnet association nacl for web
resource "aws_network_acl_association" "ibm_app_nacl_association" {
  network_acl_id = aws_network_acl.ibm_app_nacl.id
  subnet_id      = aws_subnet.ibm_app_sn.id
}
#create nacl for pvt
resource "aws_network_acl" "ibm_db_nacl" {
  vpc_id = aws_vpc.ibm_vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "ibm-db-nacl"
  }
}
#subnet association nacl for web
resource "aws_network_acl_association" "ibm_db_nacl_association" {
  network_acl_id = aws_network_acl.ibm_db_nacl.id
  subnet_id      = aws_subnet.ibm_private_sn.id
}
#security groups for public
resource "aws_security_group" "ibm_web_sg" {
  name        = "ibm_web_sg"
  description = "Allow ssh inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.ibm_vpc.id

  tags = {
    Name = "ibm-web-sg"
  }
}
#security group rule -ssh

resource "aws_vpc_security_group_ingress_rule" "allow_web_sg_ssh" {
  security_group_id = aws_security_group.ibm_web_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
#security group rule -http
resource "aws_vpc_security_group_ingress_rule" "allow_web_sg_http" {
  security_group_id = aws_security_group.ibm_web_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}
#App security group
#security groups for public
resource "aws_security_group" "ibm_app_sg" {
  name        = "ibm_app_sg"
  description = "Allow ssh inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.ibm_vpc.id

  tags = {
    Name = "ibm-app-sg"
  }
}
#security group rule -ssh

resource "aws_vpc_security_group_ingress_rule" "allow_app_sg_ssh" {
  security_group_id = aws_security_group.ibm_app_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
#security group rule -http
resource "aws_vpc_security_group_ingress_rule" "allow_app_sg_http" {
  security_group_id = aws_security_group.ibm_app_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
}
#pvt security group
#security groups for public
resource "aws_security_group" "ibm_db_sg" {
  name        = "ibm_db_sg"
  description = "Allow ssh inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.ibm_vpc.id

  tags = {
    Name = "ibm-db-sg"
  }
}
#security group rule -ssh

resource "aws_vpc_security_group_ingress_rule" "allow_db_sg_ssh" {
  security_group_id = aws_security_group.ibm_db_sg.id
  cidr_ipv4         = "10.0.0.0/16"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
#security group rule -postgres
resource "aws_vpc_security_group_ingress_rule" "allow_db_sg_postgres" {
  security_group_id = aws_security_group.ibm_db_sg.id
  cidr_ipv4         = "10.0.0.0/16"
  from_port         = 5432
  ip_protocol       = "tcp"
  to_port           = 5432
}

