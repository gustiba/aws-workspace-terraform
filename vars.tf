variable "region" {
  default = "ap-southeast-3"
}

variable "password_ds" {
  default =""
  description = "password for directory service"
}

variable "aws_access_key" {
  default = ""
}

variable "aws_secret_key" {
 default = "" 
}

variable "user-ad" {
  description = "user in active directory"
  type = set(string)
  default = [ "dicky","rully", "sandi", "pambudi", "goeij", "ivan", "alvian", "sahat", "aditya", "wahyu" ]
}

variable "ingress_rules" {
    type = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_block  = string
      description = string
    }))
    default     = [
        {
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_block  = "0.0.0.0/0" #Variables not allowed in this func, we can use whitelisted IP Addrs
          ipv6_cidr_block = "::/0"
          description = "Allow SSH"
        },
        {
          from_port   = 3389
          to_port     = 3389
          protocol    = "tcp"
          cidr_block  = "0.0.0.0/0" #Variables not allowed in this func, we can use whitelisted IP Addrs
          ipv6_cidr_block = "::/0"
          description = "Allow RDP"  
        },
        {
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_block  = "0.0.0.0/0"
          ipv6_cidr_block = "::/0"
          description = "Allow HTTP"
        },
        {
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_block  = "0.0.0.0/0"
          ipv6_cidr_block = "::/0"
          description = "Allow HTTPS"
        },
        {
          from_port   = 2375
          to_port     = 2375
          protocol    = "tcp"
          cidr_block  = "0.0.0.0/0"
          ipv6_cidr_block = "::/0"
          description = "Connection port to docker EC2 Instance"
        },
        {
          from_port   = 2376
          to_port     = 2376
          protocol    = "tcp"
          cidr_block  = "0.0.0.0/0"
          ipv6_cidr_block = "::/0"
          description = "Connection port to docker EC2 Instance"
        }
    ]
}