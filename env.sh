#install docker
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
wget https://download.docker.com/linux/centos/7/x86_64/edge/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm
yum -y install containerd.io-1.2.6-3.3.el7.x86_64.rpm
yum install -y docker-ce
rm -rf containerd.io-1.2.6-3.3.el7.x86_64.rpm
#install docker-compose
curl -L https://github.com/docker/compose/releases/download/1.25.0-rc2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
#设置国内镜像
mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://registry.docker-cn.com"]
}
EOF
#start docker
sudo systemctl daemon-reload
sudo systemctl start docker
sudo systemctl enable docker

#开放防火墙
firewall-cmd --zone=public --add-port=6379/tcp --permanent 
firewall-cmd --zone=public --add-port=3000/tcp --permanent 
firewall-cmd --zone=public --add-port=1215/tcp --permanent 
firewall-cmd --zone=public --add-port=2181/tcp --permanent 
firewall-cmd --zone=public --add-port=9092/tcp --permanent 
firewall-cmd --reload