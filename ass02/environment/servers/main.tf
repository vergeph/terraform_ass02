#  Define the provider
provider "aws" {
  region = "us-east-1"
}



# Use remote state to retrieve the data
data "terraform_remote_state" "network" { // This is to use Outputs from Remote State
  backend = "s3"
  config = {
    bucket = "acs730-ass02-vpaguibitan"      // Bucket from where to GET Terraform State
    key    = "network/terraform.tfstate" // Object name in the bucket to GET Terraform State
    region = "us-east-1"                            // Region where bucket created
  }
}

#ssh-keygen -t rsa -f ~/environment/ass02/environment/servers/vergekey1
resource "aws_key_pair" "vergekey1" {
  key_name   = "vergekey1"
  public_key = file("vergekey1.pub")
}

#Define Security Group for Bastion SSH
resource "aws_security_group" "sg_ssh"{
	description = "Allow limited inbound external traffic"
	vpc_id = data.terraform_remote_state.network.outputs.vpc_id
	name = "nonprod_sg_ssh"
	
	ingress {
	    protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
		from_port = 22
		to_port = 22
	}
		
	egress {
		protocol = -1
		cidr_blocks = ["0.0.0.0/0"]
		from_port = 0
		to_port = 0
	}

	tags = {
		Name = "nonprod_sg_bastion_ssh"
	}	
}


#Define Security Group for Prod VM SSH
resource "aws_security_group" "sg_ssh_prod"{
	description = "Allow limited inbound external traffic"
	vpc_id = data.terraform_remote_state.network.outputs.vpc_id1
	name = "prod_sg_ssh"
	
	ingress {
	    protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
		from_port = 22
		to_port = 22
	}
		
	egress {
		protocol = -1
		cidr_blocks = ["0.0.0.0/0"]
		from_port = 0
		to_port = 0
	}

	tags = {
		Name = "prod_vm_ssh"
	}	
}


#Define Security Group for VM SSH and TCP
resource "aws_security_group" "sg_vm"{
	description = "Allow limited inbound external traffic"
	vpc_id = data.terraform_remote_state.network.outputs.vpc_id
	name = "nonprod_sg_vm"
	
	ingress {
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
		from_port = 22
		to_port = 22
	}
	
	ingress {
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
		from_port = 80
		to_port = 80
	}
	
	egress {
		protocol = -1
		cidr_blocks = ["0.0.0.0/0"]
		from_port = 0
		to_port = 0
	}

	tags = {
		Name = "nonprod_sg_VM"
	}	
}


#Define Creation of EC2 Bastion in Public Subnet

resource "aws_instance" "bastion"{
	ami = var.ami
	instance_type = var.instance_type
	vpc_security_group_ids = ["${aws_security_group.sg_ssh.id}"]
	subnet_id = data.terraform_remote_state.network.outputs.public_subnet_id1[1]
	count = 1
	key_name = aws_key_pair.vergekey1.key_name
	associate_public_ip_address = true
	tags = { 
	Name = "Bastion_Host" 
	}
}

#Define Creation of EC2 VM in Private Subnet Non Prod
resource "aws_instance" "VM"{
	ami = var.ami
	instance_type = var.instance_type
	vpc_security_group_ids = ["${aws_security_group.sg_vm.id}"]
	subnet_id = data.terraform_remote_state.network.outputs.private_subnet_ids[count.index]
	count = 2
	key_name = aws_key_pair.vergekey1.key_name
	associate_public_ip_address = false
	user_data = file("install_httpd.sh")
	tags = { 
	Name = "VM Web Server Non Prod" 
	}
}

#Define Creation of EC2 VM in Private Subnet Prod
resource "aws_instance" "VM1"{
	ami = var.ami
	instance_type = var.instance_type
	vpc_security_group_ids = ["${aws_security_group.sg_ssh_prod.id}"]
	subnet_id = data.terraform_remote_state.network.outputs.private_subnet_ids1[count.index]
	key_name = aws_key_pair.vergekey1.key_name
	count = 2
	associate_public_ip_address = false
	tags = { 
	Name = "SSH Access Only VM Prod"
	}
}