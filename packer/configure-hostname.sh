sudo hostnamectl set-hostname k8s.localdomain
echo 127.0.0.1 k8s.localdomain k8s localhost4 localhost4.localdomain4 | sudo tee -a /etc/hosts
echo preserve_hostname: true | sudo tee -a /etc/cloud/cloud.cfg