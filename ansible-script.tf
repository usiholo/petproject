locals {
  ansible_user_data = <<-EOF
#!/bin/bash
sudo yum update -y
sudo dnf install -y ansible-core
sudo yum install -y yum utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user
sudo chown -R ec2-user:ec2-user /etc/ansible
echo "${file(var.private_keypair_path)}" >> /home/ec2-user/pacpujpeu2
sudo chown ec2-user:ec2-user /home/ec2-user/pacpujpeu2
chmod 400 pacpujpeu2 /home/ec2-user/pacpujpeu2
cd /etc/ansible
touch hosts
sudo chown ec2-user:ec2-user hosts
cat <<EOT> /etc/ansible/hosts
[all:vars]
ansible_ssh_common_args='-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'

localhost ansible_connection=local

[docker_host]
${aws_instance.Docker-server.private_ip} ansible_user=ec2-user ansible_ssh_private_key_file=/home/ec2-user/pacpujpeu2

EOT
sudo mkdir /opt/docker
echo "${file(var.newrelicfile)}" >> /opt/docker/newrelic.yml
touch /opt/docker/Dockerfile
cat <<EOT>> /opt/docker/Dockerfile
FROM openjdk:8-jre-slim
FROM ubuntu
FROM tomcat
COPY *.war /usr/local/tomcat/webapps
WORKDIR  /usr/local/tomcat/webapps
RUN apt update -y && apt install curl -y
RUN curl -O https://download.newrelic.com/newrelic/java-agent/newrelic-agent/current/newrelic-java.zip && \
    apt-get install unzip -y  && \
    unzip newrelic-java.zip -d  /usr/local/tomcat/webapps
ENV JAVA_OPTS="$JAVA_OPTS -javaagent:/usr/local/tomcat/webapps/newrelic/newrelic.jar"
ENV NEW_RELIC_APP_NAME="myapp"
ENV NEW_RELIC_LOG_FILE_NAME=STDOUT
ENV NEW_RELIC_LICENCE_KEY="eu01xx31c21b57a02a5da0d33d8706beb182NRAL"
WORKDIR /usr/local/tomcat/webapps
ADD ./newrelic.yml /usr/local/tomcat/webapps/newrelic/newrelic.yml
ENTRYPOINT [ "java", "-javaagent:/usr/local/tomcat/webapps/newrelic/newrelic.jar", "-jar", "spring-petclinic-1.0.war", "--server.port=8080"]
EOT

touch /opt/docker/docker-image.yml
cat <<EOT>> /opt/docker/docker-image.yml

---
 - hosts: localhost
   become: true

   tasks:

   - name: Download WAR file from Nexus repository
     get_url:
       url: http://admin:admin123@${aws_instance.Nexus-server.public_ip}:8081/repository/nexus-repo/Petclinic/spring-petclinic/1.0/spring-petclinic-1.0.war
       dest: /opt/docker

   - name: create docker image from pet Adoption war file
     command: docker build -t testapp .
     args:
       chdir: /opt/docker

   - name: Add tag to image
     command: docker tag testapp cloudhight/testapp

   - name: login to dockerhub
     command: docker login -u cloudhight -p CloudHight_Admin123@

   - name: push imageto docker hub
     command: docker push cloudhight/testapp
     ignore_errors: yes
EOT

touch /opt/docker/docker-container.yml
cat <<EOT>> /opt/docker/docker-container.yml
---
 - hosts: docker_host
   become: true

   tasks:
   - name: login to dockerhub
     command: docker login -u cloudhight -p CloudHight_Admin123@

   - name: Stop any container running 
     command: docker stop testAppContainer
     ignore_errors: yes

   - name: Remove stopped container
     command: docker rm testAppContainer
     ignore_errors: yes
   
   - name: Remove docker image
     command: docker rmi cloudhight/testapp
     ignore_errors: yes

   - name: Pull docker image from dockerhub
     command: docker pull cloudhight/testapp
   - name: Create container from pet adoption image
     command: docker run -it -d --name testAppContainer -p 8080:8080 cloudhight/testapp
EOT

touch /opt/docker/newrelic-container.yml
# Create yaml file to create a newrelic container
cat << EOT > /opt/docker/newrelic-container.yml
---
 - hosts: docker_host
   become: true
   tasks:
   - name: install newrelic agent
     command: docker run \\
                     -d \\
                     --name newrelic-infra \\
                     --network=host \\
                     --cap-add=SYS_PTRACE \\
                     --privileged \\
                     --pid=host \\
                     -v "/:/host:ro" \\
                     -v "/var/run/docker.sock:/var/run/docker.sock" \\
                     -e NRIA_LICENSE_KEY=eu01xx31c21b57a02a5da0d33d8706beb182NRAL \\
                     newrelic/infrastructure:latest
     ignore_errors: yes
EOT
sudo chown -R ec2-user:ec2-user /opt/docker
sudo chmod -R 700 /opt/docker
echo "license_key: eu01xx31c21b57a02a5da0d33d8706beb182NRAL" | sudo tee -a /etc/newrelic-infra.yml
sudo curl -o /etc/yum.repos.d/newrelic-infra.repo https://download.newrelic.com/infrastructure_agent/linux/yum/el/7/x86_64/newrelic-infra.repo
sudo yum -q makecache -y --disablerepo='*' --enablerepo='newrelic-infra'
sudo yum install newrelic-infra -y --nobest
sudo hostnamectl set-hostname Ansible
EOF
}
