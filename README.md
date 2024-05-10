# devops-full
![image](https://github.com/glauberss2007/devops-java-node-redis-mysql/assets/22028539/e3cb9b54-45c7-4fc9-bd36-ec25becc3dfd)

## Vagrant
![image](https://github.com/glauberss2007/devops-java-node-redis-mysql/assets/22028539/e8bb634d-e095-4d1a-8b16-8394caac71d6)

Vagrant is an open-source tool for building and managing virtualized development environments. It simplifies the process of creating reproducible, portable, and shareable development environments.

### Key Features:

- **Environment Management:** Define development environments using a simple text file called a "Vagrantfile."
- **Provisioning:** Automate the setup and configuration of environments, including operating systems, software packages, and networking settings.
- **Portability:** Share Vagrantfiles to ensure consistent environments across different machines and team members.
- **Integration:** Works with various virtualization providers such as VirtualBox, VMware, Hyper-V, and others.
- **Productivity:** Streamline development workflows by removing the complexities of manual environment setup.

### Getting Started:

1. Install Vagrant on your machine.
2. Create a Vagrantfile to define your development environment.
3. Use Vagrant commands to manage and interact with your virtualized environment.

For detailed documentation and examples, visit the [Vagrant website](https://www.vagrantup.com/).

## Git 
![image](https://github.com/glauberss2007/devops-java-node-redis-mysql/assets/22028539/6f8fcf53-0260-4cf5-ab07-c50ea800caf7)

### Git: Summary of Key Commands

1. **Create a Repository (GitHub):**
   - Create a new repository on GitHub to store your project.

2. **Install Git on Your Local Machine:**
   - Install Git on your local machine to start using the version control system.

3. **Initialize a Local Repository:**
   - Use the `git init` command to initialize a new repository locally or `git clone` to clone an existing repository.

4. **Add Remote Origin:**
   - Execute the `git remote add origin` command followed by the URL of the remote repository on GitHub to add a remote origin.

5. **Retrieve Remote Data:**
   - Use `git pull` to retrieve remote data and incorporate it into your local repository.

6. **Add Files to the Repository:**
   - Use `git add` to stage files for commit and add them to the repository.

7. **Commit Changes:**
   - Commit changes using `git commit` to save staged changes to the repository.

8. **Upload Local Changes:**
   - Upload local changes to the remote repository using `git push`.

9. **Check Repository Status:**
   - Verify the status of the repository using `git status` to see what is in the staging area or already committed.

![image](https://github.com/glauberss2007/devops-java-node-redis-mysql/assets/22028539/f5f9ed2d-4f8c-4a3e-a03b-e2aa6e340975)

## Ansible

![image](https://github.com/glauberss2007/devops-java-node-redis-mysql/assets/22028539/da195ca4-e683-40f9-86b0-9aef4e01ee94)

Ansible is an open-source automation platform designed for simplifying IT orchestration, configuration management, and application deployment tasks.

### Key Features:

- **Agentless:** No need to install agents on managed nodes, operates over SSH.
- **Declarative Syntax:** Uses human-readable YAML-based playbooks for defining tasks and configurations.
- **Idempotent Execution:** Ensures consistent results regardless of initial system state.
- **Inventory Management:** Dynamically manages hosts and groups for scalability.
- **Modules:** Offers a wide range of built-in modules and supports custom module development.
- **Roles:** Organizes and reuses sets of tasks, promoting code modularity and maintainability.
- **Integration:** Seamlessly integrates with version control systems, CI tools, and cloud platforms.

### Use Cases:

- **Configuration Management:** Automate setup and configuration of servers and network devices.
- **Application Deployment:** Automate deployment and scaling of applications across environments.
- **Orchestration:** Coordinate complex workflows involving multiple systems and services.
- **Compliance Automation:** Ensure adherence to security and compliance standards.

Ansible's simplicity, flexibility, and strong community support make it a popular choice for organizations seeking to streamline IT operations and adopt infrastructure as code practices.

## Architecture - Ansible Setup and Communication Overview

### Machine Types:
- **Control Node:** This is where Ansible is installed and operated from.
- **Managed Hosts:** These are the machines or devices that Ansible manages.

### Control Node Setup:
- **Control Machine:** Install Ansible on this machine.

### Managed Host Configuration:
- **Host Inventory:** Create a text file on the control node containing the list of managed hosts' IPs or hostnames.
  - This file specifies the machines or devices to be managed by Ansible.
  
### Communication Method:
- **Communication Protocol:** Ansible communicates with managed hosts via SSH.
  - No additional software needs to be installed on the managed hosts.

## Architecture - Ansible Components and Communication Overview

![image](https://github.com/glauberss2007/devops-java-node-redis-mysql/assets/22028539/4150de89-d275-4451-a95a-95773fe3d11b)


### Core Modules:
- **Description:** These modules perform the majority of the system administration tasks on the operating system.
  
### Custom Modules:
- **Description:** Extend Ansible's functionality by creating custom components using Python.
  
### Playbooks:
- **Description:** YAML-formatted text files with a predefined syntax for configuring Ansible modules.
  
### Plugins:
- **Description:** Extensions that add extra functionality such as sending messages or emails.
  
### Host Inventory:
- **Description:** A text file on the control node containing the list of managed hosts' IPs or hostnames.
  - This file specifies the machines or devices to be managed by Ansible.
  
### Ansible Galaxy:
- **Description:** A website that provides a collection of roles (tasks) developed by the community.

### Communication Method:
- **Communication Protocol:** Ansible communicates with managed hosts via SSH.
  - No additional software needs to be installed on the managed hosts.
 
## Architecture - Ansible Control Node and Managed Host Requirements

### Control Node:
- **Description:** DevOps (sysadmins) access and initiate operations through the Control Node.
- **Requirements:**
  - Python (2.7 or 3.5 or higher)
  - Supported Operating Systems: Red Hat, CentOS, Debian, macOS (BSD-like), etc.
    - Windows is not supported.

### Managed Host:
- **Description:** Users log in, install modules, and execute commands remotely on managed hosts.
- **Requirements:**
  - SSH enabled
  - Python 2.4 or higher
 
## Architecture - Ansible Playbooks
  
### APP01:
- **Components:**
  - Java (OpenJDK)
  - Notes App (REST)
  - Maven

### DB01:
- **Components:**
  - MySQL

### Configuration Tasks for All Hosts:
- Setup of a private network
- Configuration of hostnames

### Additional Configuration for app01:
- Port forwarding for application on port 8080
- Port forwarding for database on port 3306

The folder and file structure can be founded into this repository. Based on the following structure:

![image](https://github.com/glauberss2007/devops-java-node-redis-mysql/assets/22028539/eb874f90-2fad-4848-9f8d-5bffdf0010e2)

### Steps:
1. Navigate to each directory corresponding to the server.
2. Execute `vagrant init` in each directory.





