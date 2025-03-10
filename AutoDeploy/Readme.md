#  AUTOMATED CI/CD PIPELINE WITH TERRAFORM, ANSIBLE, and JENKINS

This project demonstrates the creation of a *CICD (Continuous Integration and Continuous Deployment) pipeline* using *Terraform, Ansible, Docker, and Jenkins*. The infrastructure is provisioned using Terraform, configured using Ansible, and the pipeline is automated using Jenkins and Docker.

## 1. Terraform Setup

### Terraform Init
*Screenshot:*
<p align="center">
  <img src="https://github.com/22MH1A42G5/Devops-Project/blob/main/AutoDeploy/Snapshots/Screenshot%20(1).png" width="600" height="350">
</p>

****Description:****
The terraform init command initializes the working directory and downloads the necessary provider plugins (e.g., AWS provider) to manage the resources.

****Why it’s important:****
This step ensures Terraform is ready to create and manage the infrastructure defined in the configuration files.

### Terraform Plan
*Screenshot:*
<p align="center">
  <img src="https://github.com/22MH1A42G5/Devops-Project/blob/main/AutoDeploy/Snapshots/Screenshot%20(2).png" width="600" height="350">
</p>

****Description:****
The terraform plan command provides an execution plan, showing what resources will be created, updated, or deleted.

****Why it’s important:****
This step helps verify the configuration before applying any changes, ensuring no unintended modifications are made.

### Terraform Apply
*Screenshot:* 
<p align="center">
  <img src="https://github.com/22MH1A42G5/Devops-Project/blob/main/AutoDeploy/Snapshots/Screenshot%20(4).png" width="600" height="350">
</p>

****Description:****
The terraform apply command creates the actual resources in AWS as defined in the Terraform configuration.

****Why it’s important:****
This step provisions the infrastructure, including EC2 instances, VPC, subnets, and security groups.

## 2. Resources Created by Terraform

### EC2 Instances
*Screenshot:* 
<p align="center">
  <img src="https://github.com/22MH1A42G5/Devops-Project/blob/main/AutoDeploy/Snapshots/Screenshot%20(5).png" width="600" height="350">
</p>

****Description:****
Two EC2 instances were created:
- *Docker_CICD_Ec2*: Hosts Docker for containerized applications.
- *Jenkins_CICD_Ec2*: Hosts Jenkins for the CICD pipeline.
  
The screenshot shows their public IPs, instance types, and statuses.

****Why it’s important:****
These instances form the backbone of the CICD pipeline, hosting Docker and Jenkins.

### VPC & Components
*Screenshot:* 
<p align="center">
  <img src="https://github.com/22MH1A42G5/Devops-Project/blob/main/AutoDeploy/Snapshots/Screenshot%20(6).png" width="600" height="350">
</p>

****Description:****
A *Virtual Private Cloud (VPC)* named my_vpc was created, along with a route table, internet gateway, and subnet.

****Why it’s important:****
The VPC provides an isolated network environment for the EC2 instances, ensuring secure communication.

### Security Group
*Screenshot:* 
<p align="center">
  <img src="https://github.com/22MH1A42G5/Devops-Project/blob/main/AutoDeploy/Snapshots/Screenshot%20(7).png" width="600" height="350">
</p>

****Description:****
A *security group* was created to control inbound and outbound traffic for the EC2 instances.

****Why it’s important:****
Security groups act as virtual firewalls, ensuring only authorized traffic can access the instances.

### Key Pair
*Screenshot:* 
<p align="center">
  <img src="https://github.com/22MH1A42G5/Devops-Project/blob/main/AutoDeploy/Snapshots/Screenshot%20(8).png" width="600" height="350">
</p>

****Description:****
A *key pair* named PemOfCICD.pem was generated and downloaded for SSH access to the EC2 instances.

****Why it’s important:****
The key pair ensures secure SSH access to the instances without using passwords.

## 3. Ansible Setup

### Inventory File
*Screenshot:* 
<p align="center">
  <img src="https://github.com/22MH1A42G5/Devops-Project/blob/main/AutoDeploy/Snapshots/Screenshot%20(9).png" width="600" height="350">
</p>

****Description:****
The inventory.ini file defines the target servers (EC2 instances) for Ansible. The command below was used to ping the servers and verify connectivity:

``` bash
ansible all -m ping -i inventory.ini
```

****Why it’s important:****
The inventory file is essential for Ansible to know which servers to manage.

### Install Docker
*Screenshot:* 
<p align="center">
  <img src="https://github.com/22MH1A42G5/Devops-Project/blob/main/AutoDeploy/Snapshots/Screenshot%20(10).png" width="600" height="350">
</p>

****Description:****
The install_docker.yaml playbook was executed to install Docker on the target servers.

****Why it’s important:****
Docker is required to containerize and deploy applications.

### Install Jenkins
*Screenshot:* 
<p align="center">
  <img src="https://github.com/22MH1A42G5/Devops-Project/blob/main/AutoDeploy/Snapshots/Screenshot%20(11).png" width="600" height="350">
</p>

****Description:****
The install-jenkins.yaml playbook was executed to install Jenkins on the Jenkins_CICD_Ec2 instance.

#### Steps in the playbook:
1. Install Java (required for Jenkins).
2. Add Jenkins repository and install Jenkins.
3. Start and enable the Jenkins service.

****Why it’s important:****
Jenkins automates the CICD pipeline, enabling continuous integration and deployment.

## 4. Jenkins Setup

### Jenkins Access
*Screenshot:* 
<p align="center">
  <img src="https://github.com/22MH1A42G5/Devops-Project/blob/main/AutoDeploy/Snapshots/Screenshot%20(12).png" width="600" height="350">
</p>

****Description:****
Jenkins was accessed via the browser using the public IP of the Jenkins_CICD_Ec2 instance on port 8080. The admin password was retrieved and entered to unlock Jenkins.

****Why it’s important:****
This step ensures Jenkins is properly installed and accessible.

### Plugin Installation
*Screenshot:* 
<p align="center">
  <img src="https://github.com/22MH1A42G5/Devops-Project/blob/main/AutoDeploy/Snapshots/Screenshot%20(14).png" width="600" height="350">
</p>

****Description:****
Required plugins (*Docker, Pipeline, Git*) were installed on Jenkins.

****Why it’s important:****
Plugins extend Jenkins functionality, enabling integration with Docker, Git, and other tools.


### Navigating to Jenkins Credentials
*Screenshot 1:*
<p align="center">
  <img src="https://github.com/22MH1A42G5/Devops-Project/blob/main/AutoDeploy/Snapshots/Screenshot%20(15).png" width="600" height="350">
</p>

***Description:***  
Navigate to *Manage Jenkins → Credentials → Global Credentials* to add required credentials.

*Screenshot 2: Docker & SSH Credentials in Jenkins*  
<p align="center">
  <img src="https://github.com/22MH1A42G5/Devops-Project/blob/main/AutoDeploy/Snapshots/Screenshot%20(16).png" width="600" height="350">
</p>

****Description:****
*Docker Hub credentials* were added to enable Jenkins to push/pull images securely.  
*PEM key file (PemOfCICD.pem)* was added as a *SSH USERNAME AND PRIVATE KEY* to allow SSH access to AWS EC2 instances.  

****Why it’s important:****
Jenkins needs *Docker Hub authentication* to interact securely with container registries.  
The *PEM key file* ensures secure SSH access for deployment tasks on AWS.

### Pipeline Creation
*Screenshot:* 
<p align="center">
  <img src="https://github.com/22MH1A42G5/Devops-Project/blob/main/AutoDeploy/Snapshots/Screenshot%20(18).png" width="600" height="350">
</p>

****Description:****
A pipeline named *AutoDeploy Pipeline* was created. The Groovy script for the pipeline was written, applied, and saved.

****Why it’s important:****
The pipeline automates the build, test, and deployment process.

### Build Pipeline
*Screenshot:* 
<p align="center">
  <img src="https://github.com/22MH1A42G5/Devops-Project/blob/main/AutoDeploy/Snapshots/Screenshot%20(19).png" width="600" height="350">
</p>

****Description:****
The pipeline was executed by clicking *Build Now*, and it ran successfully.

****Why it’s important:****
This step verifies that the pipeline is working as expected.

## 5. Docker Setup

### Docker Access
*Screenshot:* 
<p align="center">
  <img src="https://github.com/22MH1A42G5/Devops-Project/blob/main/AutoDeploy/Snapshots/Screenshot%20(22).png" width="600" height="350">
</p>

****Description:****
Verified that Docker is accessible on port 80 using the public IP of the Docker_CICD_Ec2 instance.

****Why it’s important:****
Ensures Docker is running and accessible for deploying applications.

### Docker Image Build
*Screenshot:* 
<p align="center">
  <img src="https://github.com/22MH1A42G5/Devops-Project/blob/main/AutoDeploy/Snapshots/Screenshot%20(23).png" width="600" height="350">
</p>

****Description:****
Checked the Docker account to confirm that the image was built successfully.

****Why it’s important:****
Ensures the application is containerized and ready for deployment.

### Docker Swarm Replicas
*Screenshot:* 
<p align="center">
  <img src="https://github.com/22MH1A42G5/Devops-Project/blob/main/AutoDeploy/Snapshots/Screenshot%20(24).png" width="600" height="350">
</p>

****Description:****
Verified the replicas created using Docker Swarm with the command:

``` bash
ansible -i inventory.ini docker_host -m command -a "sudo docker ps"
```

****Why it’s important:****
Ensures the application is running in a highly available and scalable manner.

## Conclusion
This project successfully demonstrates the automation of infrastructure provisioning using Terraform, **configuration management using Ansible, and **CICD pipeline setup using Jenkins and Docker. The pipeline ensures seamless integration and deployment of applications.
