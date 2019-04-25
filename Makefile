build_deps: install_packer install_awscli

install_packer:
	./installdep.sh packer https://releases.hashicorp.com/packer/1.4.0/packer_1.4.0_linux_amd64.zip ./bin

install_awscli:
	pip install awscli

ami:
	packer build -var 'ami_name_prefix=flugel-microk8s-aws' packer/microk8s-aws.json

