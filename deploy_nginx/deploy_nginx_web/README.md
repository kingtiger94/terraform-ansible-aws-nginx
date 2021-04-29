# Role to deploy nginx to ec2 instance
#

To start run:

`ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu -i 'aws_instance.public_ip', --private-key ssh_key_private var.playbook_path`

you must set:
* aws_instance.public_ip
* ssh_key_private
* var.playbook_path
