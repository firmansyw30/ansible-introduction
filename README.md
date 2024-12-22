# Ansible Introduction
A basic self project that demonstrated how ansible work as configuration management tool work in order to install apache2 & copy html file to server with combination of terraform as infrastructure as code to provision infrastructure (2 EC2 Instance)
## Screenshot
![Screenshot 2024-12-20 235646 (berhasil deployment melalui ansible)](https://github.com/user-attachments/assets/6083a9b2-597a-47d3-a294-27fcf3fd2cda)




## Environment Variables

Before instalation to AWS, you will need to add the following environment variables to your .env file or setup directly in terminal

`AWS_ACCESS_KEY_ID = `

`AWS_SECRET_ACCESS_KEY = `

`AWS_REGION = `

If stuck, refer to this documentation section for setup





# Instalation

For run this project make sure `Ansible` & `Terraform` are installed. 

This case is using AWS (maybe some cloud provider has different procedure) and using the same `key-pair` (.pem) in order for easier access every instance through SSH. 



1. Clone the repository

```
git clone https://github.com/firmansyw30/ansible-introduction.git
```

2. Run project

```
cd ansible-introduction\aws-resources
```

3. Execute the infrastructure provisioning (Make sure to set environment variables before start & have downloaded the `key-pair`)
```
terraform init
terraform plan
terraform apply --auto-approve
```

---
# Setup for `Instance-1-Control-Node (SSH process)`
In order to accessing the `Instance-2-Web-Server` through SSH, you need to configure the following step. 

1. Change the `key-pair` file that downloaded permission to 400 (read only) or 600 (read & write)
```
chmod 600 .ssh/sample-key-pair-firman.pem
```
2. Extract the public key from `key-pair` file & store it to file with `.pub` format (public key format)
```
ssh-keygen -y -f ~/.ssh/sample-key-pair-firman.pem > ~/.ssh/sample-key-pair-firman.pub
```

3. Copy the public key that extracted using `ssh-copy-id`
```
ssh-copy-id -i ~/.ssh/sample-key-pair-firman.pub ssh-user@instance-ip
```

Replace the `ssh-user` & `instance-ip` with actual information from the instance

4. Test accessing the instance through SSH

```
ssh -i path/to/sample-key-pair-firman.pem ssh-user@instance-ip

```

or using the sample command that provided by `connect` instance menu
```
ssh -i "sample-key-pair-firman.pem" ssh-user@ec2-instance-ip.ap-southeast-3.compute.amazonaws.com
```

5. Make sure the SSH access are work, then change the folder & file permission inside the instance
```
chmod 700 /home/ssh-user/.ssh
chmod 600 /home/ssh-user/.ssh/authorized_keys
```
Replace the `ssh-user` with actual information from the instance

6. Copy the private key file to the instance (example `sample-key-pair-firman.pem`) through SCP
```
scp -i /home/firmansyw30/.ssh/sample-key-pair-firman.pem /home/firmansyw30/.ssh/sample-key-pair-firman.pem ssh-user@ec2-instance-ip:/home/ssh-user/.ssh/
```
note that `-i /home/firmansyw30/.ssh/sample-key-pair-firman.pem` is using the same `key-pair` to authenticate SSH in order to use SCP


# Setup for `Instance-1-Control-Node (Ansible)`
In order to using Ansible in `Instance-1-Control-Node` to configuring the `Instance-2-Web-Server`, you need to configure the following step. 

1. Access the `Instance-1-Control-Node` through SSH
```
ssh -i path/to/sample-key-pair-firman.pem ssh-user@instance-ip

```

or using the sample command that provided by `connect` instance menu
```
ssh -i "sample-key-pair-firman.pem" ssh-user@ec2-instance-ip.ap-southeast-3.compute.amazonaws.com
```

2. Check the ansible is installed
```
ansible --version
````

3. Run SCP to copy `inventory.yml`, `playbook.yml`, and `index.html` to the home directory for next configuration process
```
scp -i ~/.ssh/sample-key-pair-firman.pem playbook.yml ssh-user@instance-ip:~/
scp -i ~/.ssh/sample-key-pair-firman.pem inventory.yml ssh-user@instance-ip:~/
scp -i ~/.ssh/sample-key-pair-firman.pem index.html ssh-user@instance-ip:~/
```

Replace the `ssh-user` & `instance-ip` with actual information from the instance


4. Test ping to the `Instance-2-Web-Server`
```
ansible -i inventory.yml all -m ping
```

5. Execute the ansible files (`playbook.yml` & `inventory.yml`)
```
ansible-playbook -i inventory.yml playbook.yml
```
## Tech Stack

**Server:** Apache2

**Tool:** Ansible, Terraform

**Services:** Amazon EC2


## Authors

[@firmansyw30](https://www.github.com/firmansyw30) and still learning


## Reference

[Terraform on AWS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

[Reference to Create EC2 Keypair](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/create-key-pairs.html)

[Credential Access Key](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html)

[Video Reference](https://youtu.be/2iC7R32C-EQ?si=iWYEG9nktjKuYK3K)

[Ansible](https://docs.ansible.com/)
