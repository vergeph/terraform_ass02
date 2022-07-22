output "aws_security_gr_id" {
	value = "${aws_security_group.sg_ssh.id}"
}

output "aws_security_gr_pssh_id" {
	value = "${aws_security_group.sg_ssh_prod.id}"
}

output "aws_security_gr_vm_id" {
	value = "${aws_security_group.sg_vm.id}"
}
