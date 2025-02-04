# DEBPEAS - Privilege Escalation Enumeration Script for Debian

**Created by**: Robert Harp

**debpeas.sh** is a lightweight, yet powerful enumeration script tailored specifically for secured Debian systems when linpeas.sh will not work. This script focuses exclusively on Debian-based distributions and provides an extensive assessment of privilege escalation vectors. 
Additionally, it checks for containerized, cloud, and Kubernetes environments, as well as any installed databases. debpeas.sh was created to run on Debian systems the are secure and when linpeas.sh is restricted from running on those Debian systems. 

## Features

- **Privilege Escalation Vectors**  
  - Identifies misconfigurations, weak file permissions, and setuid binaries.  
  - Detects services running with elevated privileges.

- **Container and Cloud Awareness**  
  - Enumerates Docker containers and related configurations.  
  - Detects the presence of cloud environments (AWS, Azure, GCP).

- **Kubernetes Environment Checks**  
  - Checks for exposed Kubernetes configurations.  
  - Identifies Kubernetes-related credentials and tokens.

- **Database Enumeration**  
  - Discovers installed databases (e.g., MySQL, PostgreSQL, MongoDB, etc.).  
  - Checks for misconfigured database files or credentials.

- **Debian-Specific**  
  - Tailored checks for Debian-based systems, ensuring high accuracy and relevance.

---

## Installation

1. **Clone the repository or download the script**:
   ```bash
   git clone https://github.com/rharp86/DEBPEAS.git
   cd DEBPEAS

Make the script executable:

chmod +x debpeas.sh
Usage
Run the script as a user with limited privileges. For the best results, use it on a system you have legitimate access to as part of a security assessment or penetration test.

Basic Usage:

./debpeas.sh

Run with sudo:

sudo ./debpeas.sh

Default Output

The script writes to a timestamped text file by default (e.g., debpeas_YYYYMMDD_HHMMSS.txt). If you also pipe output to tee, such as:

./debpeas.sh | tee debpeas_output.html
the script will still create its own .txt log file while simultaneously writing to your chosen file.

Save Output to a File

./debpeas.sh | tee debpeas_output.html
./debpeas.sh | tee debpeas_output.json
./debpeas.sh | tee debpeas_output.csv

Output

The script generates a detailed enumeration report, highlighting potential privilege escalation vectors, including but not limited to:

Misconfigured permissions
Vulnerable binaries
Exposed credentials and tokens
Docker, Kubernetes, cloud, and database-related risks
Requirements
Debian-based system
Bash shell
Legal Disclaimer
This script is intended for authorized use only. It is designed to assist security professionals in identifying misconfigurations and potential privilege escalation vulnerabilities in Debian-based systems. Misuse of this script can result in severe legal consequences. The author disclaims any liability for actions taken with this tool.

Contributing
Feel free to open issues or pull requests to improve debpeas.sh. Contributions are always welcome!

License
This project is licensed under the MIT License. See the LICENSE file for details.



