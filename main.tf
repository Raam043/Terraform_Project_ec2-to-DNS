# Creating Linux ec2 server ----------------------------------------------------------------------------
resource "aws_instance" "webserver" {
    count = 1
    ami = "ami-0beaa649c482330f7"
    instance_type = "t2.micro"
    key_name = "RAMESH"
    security_groups    = ["All Traffic","default"]
    user_data = "${file("./modules/webserver/linux-httpd.sh")}"
    tags = {
    Name = "Ramesh-Linux"

  }
}

# Output for Servers Public Ip addresses
output "servers_publc_ip" {
  value = "${aws_instance.webserver.*.public_ip}"
}



# Route53 Creation---------------------------------------------------------------------------------------
#Creating Hosted Zone
resource "aws_route53_zone" "saikrishna" {
    name = "saikrishna.ga"

    tags = {
      Environment = "dev"
    }
  
}

# Generate Name servers (4 servers) ---------------------------------------------------------------------
output "name_server" {
    value = aws_route53_zone.saikrishna.name_servers
}

# Creating "A" record (final) ---------------------------------------------------------------------------
resource "aws_route53_record" "www" {
    zone_id = aws_route53_zone.saikrishna.zone_id
    name = "www.saikrishna.ga"
    type = "A"
    ttl = "60"
    records = "${aws_instance.webserver.*.public_ip}"
  
}

