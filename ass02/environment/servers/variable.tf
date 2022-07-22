# Instance type
variable "instance_type" {
  default = "t2.micro"
  }


variable "ami" {
default = "resolve:ssm:/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}