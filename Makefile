AMI_NAME_PREFIX=flugel-microk8s-aws

install_packer:
	./bin/installdep.sh packer https://releases.hashicorp.com/packer/1.4.0/packer_1.4.0_linux_amd64.zip ./bin

ami: install_packer
	AMI_NAME_PREFIX=${AMI_NAME_PREFIX} packer build packer/microk8s-aws.json


