# Set input vars

variable "ssh_key_private" {
  description = "Path to the private key used to access instances via ssh"
  type        = string
  default     = "/Users/avgust/.ssh/avgustKey.pem"
}
variable "playbook_path" {
  description = "Path to ansible playbook to be executed with the created host as inventory"
  type        = string
  default     = "deploy_nginx/playbook.yml"
}
variable "name_tag" {
  description = "name tag of project"
  type        = string
  default     = "AVG_ubuntu_nginx"
}
variable "instance_type" {
  description = "Type of the AWS instance"
  type        = string
  default     = "t2.micro"
}
variable "instance_OS" {
  description = "OS for the ec2 instance"
  type        = string
  default     = "ami-08962a4068733a2b6" # Ubuntu 20.04
}
variable "instance_key_name" {
  description = "Name of the ssh key used to log in to the instances"
  type        = string
  default     = "avgustKey"
}
