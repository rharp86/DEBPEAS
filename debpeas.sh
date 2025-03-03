#!/bin/bash
# Simple Privilege Escalation Enumeration Script for Debian Systems

# Capture the hostname
HOST=$(hostname)
# Define the log file with hostname and timestamp
LOG_FILE="debpeas_${HOST}_$(date +'%Y%m%d_%H%M%S').txt"

# Redirect all output to both the console and the log file
exec > >(tee -i "$LOG_FILE") 2>&1

# Set the log file permissions
chmod 644 "$LOG_FILE"

# Define colors for output
green='\033[0;32m'
yellow='\033[1;33m'
red='\033[1;31m'
blue='\033[1;34m'
magenta='\033[1;35m'
cyan='\033[1;36m'
reset='\033[0m'
white='\033[1;37m'

echo -e "${blue}========================================================================================"
echo -e "

██████╗ ███████╗██████╗ ██████╗ ███████╗ █████╗ ███████╗
██╔══██╗██╔════╝██╔══██╗██╔══██╗██╔════╝██╔══██╗██╔════╝
██║  ██║█████╗  ██████╔╝██████╔╝█████╗  ███████║███████╗
██║  ██║██╔══╝  ██╔══██╗██╔═══╝ ██╔══╝  ██╔══██║╚════██║
██████╔╝███████╗██████╔╝██║     ███████╗██║  ██║███████║
╚═════╝ ╚══════╝╚═════╝ ╚═╝     ╚══════╝╚═╝  ╚═╝╚══════╝
                                                                                                                       
"
echo -e "${white}Debian Privilege Escalation Enumeration Script${reset}"
echo -e "${white}Created By: Robert Harp${reset}"
echo -e "${white}Version: 1.0.0${reset}"
echo -e "${blue}========================================================================================${reset}"

# Just a fun line carried over
echo -e "\n${red}Justin is PAB!!!${reset}"

# ASCII art for the blue cat
CAT="
${blue}       /\\_/\\  
      ( o.o )  
      > ^_^ <  ${red}●${reset}
"

# Display the cat
echo -e "$CAT"

# Function to check command existence
check_command() {
    if ! command -v "$1" &>/dev/null; then
        echo "[-] $1 is not installed."
        return 1
    fi
    return 0
}

echo -e "\n${cyan}=================================================================="
echo -e "Basic System Information"
echo -e "==================================================================${reset}"

echo -e "\n${green}[+] Basic System Information${reset}"
uname -a
echo -e "Kernel Version: ${yellow}$(uname -r)${reset}"

echo -e "OS Information:"
lsb_release -d 2>/dev/null || cat /etc/os-release 2>/dev/null

echo -e "Current User: ${yellow}$(whoami)${reset}"
echo -e "Hostname: ${yellow}$(hostname)${reset}"

# AppArmor check (Debian can also use AppArmor)
if command -v aa-status &>/dev/null; then
    echo -e "\n${green}[+] Checking AppArmor Status:${reset}"
    sudo aa-status 2>/dev/null || echo "AppArmor is installed but could not retrieve status."
else
    echo -e "\n${red}[-] AppArmor is not installed or not found.${reset}"
fi

echo -e "\n${cyan}=================================================================="
echo -e "Check for Sudo Privileges"
echo -e "==================================================================${reset}"

echo -e "\n${green}[+] Checking Sudo Privileges${reset}"
sudo -n -l 2>/dev/null || echo "User does not have sudo privileges or sudo is not installed."

echo -e "\n${cyan}=================================================================="
echo -e "SUID/SGID Files"
echo -e "==================================================================${reset}"

echo -e "\n${green}[+] Checking for SUID Files${reset}"
find / -perm -4000 -type f -exec ls -la {} \; 2>/dev/null

echo -e "\n${green}[+] Checking for SGID Files${reset}"
find / -perm -2000 -type f -exec ls -la {} \; 2>/dev/null

echo -e "\n${green}[+] Checking LD_PRELOAD vulnerabilities${reset}"
strings /usr/bin/sudo 2>/dev/null | grep -i "preload"

echo -e "\n${cyan}=================================================================="
echo -e "Writable Directories"
echo -e "==================================================================${reset}"
echo -e "\n${green}[+] Finding World-Writable Directories (excluding /proc and /sys)...${reset}"
find / -type d -perm -0002 -exec ls -ld {} \; 2>/dev/null | grep -Ev "^/proc|^/sys"

echo -e "\n${cyan}=================================================================="
echo -e "Cron Jobs"
echo -e "==================================================================${reset}"

echo -e "\n${green}[+] Checking Cron Jobs${reset}"
echo "System-wide Cron Jobs:"
cat /etc/crontab 2>/dev/null

echo -e "\nUser-specific Cron Jobs (commonly /var/spool/cron/crontabs):"
ls -la /var/spool/cron 2>/dev/null
ls -la /var/spool/cron/crontabs 2>/dev/null

echo -e "\nCron jobs in /etc/cron.* directories:"
ls -la /etc/cron.* 2>/dev/null

echo -e "\n${cyan}=================================================================="
echo -e "Environment Variables"
echo -e "==================================================================${reset}"

echo -e "\n${green}[+] Checking for Sensitive Data in Environment Variables...${reset}"
env

echo -e "\n${cyan}=================================================================="
echo -e "Installed Packages and Vulnerabilities"
echo -e "==================================================================${reset}"

echo -e "\n${green}[+] Checking for Installed Packages (dpkg-based)${reset}"
dpkg -l | sort

echo -e "\n${cyan}=================================================================="
echo -e "Network Configuration and Connections"
echo -e "==================================================================${reset}"

echo -e "\n${green}[+] Checking Network Configurations...${reset}"
ip addr

echo -e "\nOpen Ports (using netstat if installed):"
if command -v netstat &>/dev/null; then
    netstat -tulnp | grep LISTEN
else
    echo "netstat not installed. Trying ss instead:"
    ss -tulnp
fi

echo -e "\n${cyan}=================================================================="
echo -e "Sensitive Files"
echo -e "==================================================================${reset}"

echo -e "\n${green}[+] Checking for SSH Keys, PEMs, etc...${reset}"
find / -name "id_rsa*" -o -name "*.pem" -o -name "*.key" 2>/dev/null

echo -e "\nFiles containing 'password':"
grep -ril "password" /etc /home /root 2>/dev/null

echo -e "\n${cyan}=================================================================="
echo -e "User and Group Enumeration"
echo -e "==================================================================${reset}"

echo -e "\n${green}[+] Enumerating Users (from /etc/passwd)${reset}"
cat /etc/passwd

echo -e "\nGroups:"
cat /etc/group

echo -e "\n${cyan}=================================================================="
echo -e "Processes Running"
echo -e "==================================================================${reset}"

echo -e "\n${green}[+] Checking Processes Running...${reset}"
ps aux

echo -e "\n${cyan}=================================================================="
echo -e "Kernel Exploit Checks"
echo -e "==================================================================${reset}"

echo -e "\n${green}[+] Checking for Kernel Vulnerabilities...${reset}"
echo -e "Kernel Version: ${yellow}$(uname -r)${reset}"

echo -e "\n${cyan}=================================================================="
echo -e "Enumerating File Sharing (NFS, SMB)"
echo -e "==================================================================${reset}"

echo -e "\n${green}[+] Enumerating File Shares...${reset}"
echo -e "\n${green}[+] NFS Shares...${reset}"

# Check if a target IP address is provided as an argument
if [ -z "$1" ]; then
    # If no argument is provided, use the local machine's primary IP address
    TARGET_IP=$(hostname -I | awk '{print $1}')
else
    TARGET_IP="$1"
fi

echo -e "\n${green}[+] Target IP Address: $TARGET_IP${reset}"
check_command showmount && showmount -e "$TARGET_IP" 2>/dev/null || echo -e "\n${red}[-] NFS not installed or no share available.${reset}"

echo -e "\n${green}[+] SMB Shares...${reset}"
check_command smbclient && smbclient -L "$TARGET_IP" -N 2>/dev/null || echo -e "\n${red}[-] SMB not installed or no share available.${reset}"

echo -e "\n${cyan}=================================================================="
echo -e "Active Sessions and Logged-In Users"
echo -e "==================================================================${reset}"

echo -e "\n${green}[+] Active Sessions and Logged-In Users:${reset}"
who -a || echo -e "\n${red}[-] Unable to enumerate logged-in users.${reset}"
echo -e "\nLast Logins:"
last | head

echo -e "\n${cyan}=================================================================="
echo -e "Search for Passwords/Keys in Config Files"
echo -e "==================================================================${reset}"

echo -e "\n${green}[+] Searching for Passwords/Keys/Secrets in Config Files:${reset}"
grep -rli "password" /etc /home /root 2>/dev/null
grep -rli "key" /etc /home /root 2>/dev/null
grep -rli "secret" /etc /home /root 2>/dev/null

echo -e "\n${cyan}=================================================================="
echo -e "Enumerating Services"
echo -e "==================================================================${reset}"

echo -e "\n${green}[+] Enumerating Services:${reset}"
echo "System Services (running):"
if services=$(timeout 10s systemctl list-units --type=service --state=running 2>/dev/null); then
    if [ -n "$services" ]; then
        echo "$services"
    else
        echo -e "\n${red}[-] No running services found.${reset}"
    fi
else
    echo -e "\n${red}[-] Unable to enumerate system services or command timed out.${reset}"
fi

echo -e "\nServices with incorrect file permissions:"
if incorrect_permissions=$(find /etc/systemd/system /lib/systemd/system /usr/lib/systemd/system -type f -perm /o+w 2>/dev/null); then
    if [ -n "$incorrect_permissions" ]; then
        echo "$incorrect_permissions"
    else
        echo -e "\n${red}[-] No services with incorrect file permissions found.${reset}"
    fi
else
    echo -e "\n${red}[-] Unable to search for services with incorrect file permissions.${reset}"
fi

echo -e "\n${cyan}=================================================================="
echo -e "Search for Backup Files"
echo -e "==================================================================${reset}"

echo -e "\n${green}[+] Searching for Backup Files:${reset}"
find / -name "*.bak" -o -name "*.old" -o -name "*.backup" -o -name "*.save" 2>/dev/null

echo -e "\n${cyan}=================================================================="
echo -e "Search for Writable Configuration Files"
echo -e "==================================================================${reset}"

echo -e "\n${green}[+] Searching for Writable Configuration Files:${reset}"
find /etc -type f -writable 2>/dev/null

echo -e "\n${cyan}=================================================================="
echo -e "Databases"
echo -e "==================================================================${reset}"

# PostgreSQL
echo -e "\n${green}[+] Checking for PostgreSQL:${reset}"
if command -v psql &>/dev/null; then
    echo -e "\n${green}[+] PostgreSQL detected.${reset}"
    echo -e "\n${yellow}Checking PostgreSQL version:${reset}"
    psql -V

    echo -e "\n${yellow}Listing PostgreSQL databases (if accessible):${reset}"
    sudo -u postgres psql -c "\l" 2>/dev/null

    echo -e "\n${yellow}Checking PostgreSQL roles and privileges:${reset}"
    sudo -u postgres psql -c "\du" 2>/dev/null

    echo -e "\n${yellow}Checking for sensitive information in PostgreSQL configurations:${reset}"
    find / \( -name "postgresql.conf" -o -name "pg_hba.conf" \) -exec grep -iE 'password|secret|key' {} \; 2>/dev/null
else
    echo -e "\n${red}[-] PostgreSQL is not installed.${reset}"
fi

# MySQL
echo -e "\n${green}[+] Checking for MySQL:${reset}"
if command -v mysql &>/dev/null; then
    echo -e "\n${green}[+] MySQL detected.${reset}"
    echo -e "\n${yellow}Checking MySQL version:${reset}"
    mysql --version

    echo -e "\n${yellow}Listing MySQL databases (if accessible):${reset}"
    mysql -e "SHOW DATABASES;" 2>/dev/null

    echo -e "\n${yellow}Checking MySQL users and privileges:${reset}"
    mysql -e "SELECT user, host FROM mysql.user;" 2>/dev/null

    echo -e "\n${yellow}Checking for sensitive information in MySQL configurations:${reset}"
    find / -name "my.cnf" -exec grep -iE 'password|secret|key' {} \; 2>/dev/null
else
    echo -e "\n${red}[-] MySQL is not installed.${reset}"
fi

# MongoDB
echo -e "\n${green}[+] Checking for MongoDB:${reset}"
if command -v mongo &>/dev/null; then
    echo -e "\n${green}[+] MongoDB detected.${reset}"
    echo -e "\n${yellow}Checking MongoDB version:${reset}"
    mongo --version

    echo -e "\n${yellow}Listing MongoDB databases (if accessible):${reset}"
    mongo --eval "db.adminCommand('listDatabases')" 2>/dev/null

    echo -e "\n${yellow}Checking MongoDB users and roles (if accessible):${reset}"
    mongo --eval "db.getSiblingDB('admin').system.users.find().pretty()" 2>/dev/null

    echo -e "\n${yellow}Checking for sensitive information in MongoDB configurations:${reset}"
    find / -name "mongod.conf" -exec grep -iE 'password|secret|key' {} \; 2>/dev/null
else
    echo -e "\n${red}[-] MongoDB is not installed.${reset}"
fi

# Neo4j
echo -e "\n${green}[+] Checking for Neo4j:${reset}"
if command -v neo4j &>/dev/null; then
    echo -e "\n${green}[+] Neo4j detected.${reset}"
    echo -e "\n${yellow}Checking for running Neo4j processes:${reset}"
    pgrep -fl neo4j

    echo -e "\n${yellow}Checking Neo4j version:${reset}"
    neo4j --version

    echo -e "\n${yellow}Checking for Neo4j services (systemd):${reset}"
    systemctl list-units --type=service --state=running | grep -i neo4j

    echo -e "\n${yellow}Checking for default Neo4j ports (7474, 7687, etc.):${reset}"
    ports=(7474 7687 7473 7472 7471 7470)
    for port in "${ports[@]}"; do
        if netstat -tulnp 2>/dev/null | grep ":$port" &>/dev/null; then
            echo -e "${green}[+] Neo4j is listening on port $port.${reset}"
        else
            echo -e "${red}[-] Port $port is not in use by Neo4j.${reset}"
        fi
    done
    echo -e "\n${yellow}Checking Neo4j configuration file(s):${reset}"
    find / -name "neo4j.conf" -o -name "neo4j-server.properties" 2>/dev/null | while read -r cfg; do
        echo -e "\nFile: $cfg"
        grep -iE 'password|secret|key' "$cfg" 2>/dev/null
    done
else
    echo -e "\n${red}[-] Neo4j is not installed.${reset}"
fi

echo -e "\n${cyan}=================================================================="
echo -e "Cloud Environments"
echo -e "==================================================================${reset}"

# AWS
echo -e "\n${green}[+] Checking for AWS:${reset}"
if [[ -f ~/.aws/credentials ]]; then
    echo -e "\n${green}[+] AWS credentials found.${reset}"
    echo -e "\n${yellow}Enumerating AWS IAM roles and permissions:${reset}"
    aws sts get-caller-identity 2>/dev/null
    aws iam list-roles --output yaml 2>/dev/null
    aws iam list-users --output yaml 2>/dev/null
    aws iam list-policies --output yaml 2>/dev/null
else
    echo -e "\n${red}[-] AWS credentials not found.${reset}"
fi

# Azure
echo -e "\n${green}[+] Checking for Azure:${reset}"
if [[ -f ~/.azure/azureProfile.json ]]; then
    echo -e "\n${green}[+] Azure profile found.${reset}"
    echo -e "\n${yellow}Enumerating Azure roles and privileges:${reset}"
    az account show 2>/dev/null
    az role assignment list --all 2>/dev/null
    az ad user list 2>/dev/null
    az ad group list 2>/dev/null
else
    echo -e "\n${red}[-] Azure profile not found.${reset}"
fi

# GCP
echo -e "\n${green}[+] Checking for GCP:${reset}"
if [[ -f ~/.config/gcloud/credentials ]]; then
    echo -e "\n${green}[+] GCP credentials found.${reset}"
    echo -e "\n${yellow}Enumerating GCP IAM roles and permissions:${reset}"
    gcloud auth list 2>/dev/null
    gcloud iam service-accounts list 2>/dev/null
    gcloud iam service-accounts keys list 2>/dev/null
else
    echo -e "\n${red}[-] GCP credentials not found.${reset}"
fi

echo -e "\n${cyan}=================================================================="
echo -e "Kubernetes Environments"
echo -e "==================================================================${reset}"

echo -e "\n${green}[+] Checking for Kubernetes:${reset}"
if command -v kubectl &>/dev/null; then
    echo -e "\n${green}[+] Kubernetes detected.${reset}"
    
    echo -e "\n${yellow}Checking Kubernetes version:${reset}"
    if ! kubectl version --short; then
        echo -e "${red}[-] Failed to get Kubernetes version.${reset}"
    fi

    echo -e "\n${yellow}Cluster Information Dump (if allowed):${reset}"
    if ! kubectl cluster-info dump; then
        echo -e "${red}[-] Failed to dump cluster information.${reset}"
    fi

    echo -e "\n${yellow}Listing Kubernetes namespaces:${reset}"
    if ! kubectl get namespaces; then
        echo -e "${red}[-] Failed to list namespaces.${reset}"
    fi

    echo -e "\n${yellow}Fetching secrets across all namespaces:${reset}"
    if ! kubectl get secrets --all-namespaces -o yaml; then
        echo -e "${red}[-] Failed to fetch secrets.${reset}"
    fi

    echo -e "\n${yellow}Checking Kubernetes nodes:${reset}"
    if ! kubectl get nodes -o wide; then
        echo -e "${red}[-] Failed to get nodes.${reset}"
    fi

    echo -e "\n${yellow}Checking Kubernetes pods:${reset}"
    if ! kubectl get pods --all-namespaces -o wide; then
        echo -e "${red}[-] Failed to get pods.${reset}"
    fi

    echo -e "\n${yellow}Checking control plane components:${reset}"
    if ! kubectl get componentstatuses; then
        echo -e "${red}[-] Failed to get control plane components.${reset}"
    fi

    echo -e "\n${yellow}Inspecting cluster roles and role bindings:${reset}"
    if ! kubectl get clusterroles -o yaml; then
        echo -e "${red}[-] Failed to get cluster roles.${reset}"
    fi
    if ! kubectl get clusterrolebindings -o yaml; then
        echo -e "${red}[-] Failed to get cluster role bindings.${reset}"
    fi

    echo -e "\n${yellow}Checking Kubernetes services:${reset}"
    if ! kubectl get services --all-namespaces -o wide; then
        echo -e "${red}[-] Failed to get services.${reset}"
    fi

    echo -e "\n${yellow}Checking for insecure pod configurations:${reset}"
    if ! kubectl describe pods --all-namespaces | grep -i 'hostpath\|hostnetwork'; then
        echo -e "${red}[-] Failed to check for insecure pod configurations.${reset}"
    fi

    echo -e "\n${yellow}Checking for exposed Kubernetes Dashboard:${reset}"
    if ! kubectl get svc --all-namespaces | grep -i dashboard; then
        echo -e "${red}[-] Failed to check for exposed Kubernetes Dashboard.${reset}"
    fi
else
    echo -e "\n${red}[-] Kubernetes is not installed or configured.${reset}"
fi

echo -e "\n${cyan}=================================================================="
echo -e "Docker and Container Information"
echo -e "==================================================================${reset}"

echo -e "\n${green}[+] Checking for Docker:${reset}"
if command -v docker &>/dev/null; then
    echo -e "\n${green}[+] Docker is installed.${reset}"
    
    echo -e "\n${yellow}Listing Docker containers:${reset}"
    if ! docker ps -a; then
        echo -e "${red}[-] Failed to list Docker containers.${reset}"
    fi

    echo -e "\n${yellow}Checking Docker images:${reset}"
    if ! docker images; then
        echo -e "${red}[-] Failed to list Docker images.${reset}"
    fi

    echo -e "\n${yellow}Inspecting Docker network settings:${reset}"
    if ! docker network ls; then
        echo -e "${red}[-] Failed to list Docker networks.${reset}"
    fi

    echo -e "\n${yellow}Searching for sensitive data in Docker volumes:${reset}"
    docker volume ls | while read -r volumeLine; do
        volumeName=$(echo "$volumeLine" | awk '{print $2}')
        if [[ "$volumeName" != "VOLUME" && -n "$volumeName" ]]; then
            find "/var/lib/docker/volumes/$volumeName" -type f -exec grep -iE "password|secret|key" {} \; 2>/dev/null
        fi
    done

    echo -e "\n${yellow}Checking for Docker socket:${reset}"
    if ! ls -la /var/run/docker.sock; then
        echo -e "${red}[-] Failed to check Docker socket.${reset}"
    fi

    echo -e "\n${yellow}Checking for potential container breakout paths (other sockets):${reset}"
    if ! find / -name "*.sock" -type s 2>/dev/null; then
        echo -e "${red}[-] Failed to find other sockets.${reset}"
    fi
else
    echo -e "\n${red}[-] Docker is not installed.${reset}"
fi

echo -e "\n${cyan}=================================================================="
echo -e "Puppet Configuration and Code Analysis"
echo -e "==================================================================${reset}"

echo -e "\n${green}[+] Checking for Puppet:${reset}"
if command -v puppet &>/dev/null; then
    echo -e "\n${green}[+] Puppet is installed.${reset}"
    
    CONFIG_PATH=$(puppet config print config 2>/dev/null)
    if [[ -n "$CONFIG_PATH" ]]; then
        echo -e "\n${yellow}[INFO] Found puppet.conf:${reset}"
        if ! grep -iE "password|secret|key" "$CONFIG_PATH" 2>/dev/null; then
            echo -e "${red}[-] Failed to check puppet.conf for sensitive data.${reset}"
        fi
    fi

    echo -e "\n${yellow}Listing Puppet manifests:${reset}"
    if ! find /etc/puppet/manifests -type f 2>/dev/null; then
        echo -e "${red}[-] Failed to list Puppet manifests.${reset}"
    fi

    echo -e "\n${yellow}Checking Puppet manifests for sensitive data:${reset}"
    if ! find /etc/puppet/manifests -type f -exec grep -iE "password|secret|key" {} \; 2>/dev/null; then
        echo -e "${red}[-] Failed to check Puppet manifests for sensitive data.${reset}"
    fi
else
    echo -e "\n${red}[-] Puppet is not installed.${reset}"
fi

echo -e "\n${cyan}=================================================================="
echo -e "Cleaning Up"
echo -e "==================================================================${reset}"

echo -e "\n${cyan}[+] Cleaning Up:${reset}"
echo -e "\n${magenta}========================================================================================"
echo -e "\nDebian Privilege Escalation Completed!"
echo -e "========================================================================================${reset}"
