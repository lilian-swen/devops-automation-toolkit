
## Goal 
My objective is to develop a robust, automated shell script to efficiently create new Linux user accounts. By delegating this task, I aim to eliminate manual, repetitive account creation and reduce human error in our provisioning process.

## The Scenario
As a Lead Backend Software Engineer between 2019 and 2021 at a fast-growing company, I occasionally support our Linux System Administration tasks. At one point, our DevOps team launched a major initiative to deploy dozens of new servers, but progress was stalling.

The team was being hampered by constant, fragmented requests from the help desk to manually create new Linux accounts for recruits testing our latest application. These interruptions were not only time-consuming but were directly preventing the team from focusing on the high-priority infrastructure deployments that define their core responsibilities.

To regain the team's focus and ensure we hit our project deadlines, I decided to automate this workflow. By building a secure, non-interactive shell script that standardizes user creation, I can empower the help desk to handle these requests independently. This transition ensures that account provisioning is consistent, scalable, and error-free, ultimately allowing the DevOps team to work uninterrupted and complete our infrastructure deployments on time.


---
`create-user-interactive.sh` is a great educational exercise for learning the fundamentals of Bash, but in a real DevOps environment, we would rarely use a manual, interactive script for user creation.

In a professional setting, we prioritize Automation, Idempotency, and Source Control.

## Why this isn't used in professional DevOps
1. **Manual Intervention:** DevOps is about "Infrastructure as Code" (IaC). Asking an engineer or a user to sit at a terminal and type prompts is slow, error-prone, and doesn't scale.

2. **Centralization:** In a real team, we aren't creating users on individual local machines. We are managing identity across hundreds or thousands of servers.

3. **Security:** Hardcoding passwords or piping them through echo (even with passwd --stdin) is generally discouraged. Passwords should be managed by specialized tools.

## The "Better" Practical Ways (Industry Standards)

If you are working in a real DevOps team, you would use one of the following methods to manage user accounts:

### Method 1. Configuration Management (Ansible, Puppet, Chef)
Instead of a shell script, we define the state of the user in a configuration file. Ansible is the industry favorite for this.

- **Why it's better:** It is idempotent. If we run the task and the user already exists, it does nothing. If we run it and the user is missing, it creates them. It handles hundreds of servers simultaneously.

- **Example (Ansible Task):**

```yaml
- name: Ensure user account exists
  ansible.builtin.user:
    name: jdoe
    comment: "John Doe"
    shell: /bin/bash
    password: "{{ 'secure_password' | password_hash('sha512') }}"
```

### Method 2. Centralized Identity Providers (LDAP, Active Directory, FreeIPA)
In an enterprise, we don't create "local" users at all. We connect the servers to a central directory service.

**Why it's better:** When an employee leaves, you disable their account in one place (e.g., Active Directory), and they lose access to every single server instantly. We don't have to go around "disabling local users" one by one.

### Method 3. Cloud Native IAM (AWS IAM, GCP IAM)
If the servers are in the cloud, we don't even create OS-level users for human access. We use:

- **SSM Session Manager (AWS):** Connects to servers without SSH keys or local user accounts.

- **Cloud-Init / User Data:** When a server boots, a script automatically pulls the public SSH keys for authorized users from a secure source (like GitHub or HashiCorp Vault) and sets them up.

## If we MUST use a script (The "DevOps" way to improve it)
If the specific task requires a shell script, make it non-interactive so it can be automated by a CI/CD pipeline. Instead of read, use command-line arguments or environment variables.

Example of an automated approach:

```bash
# Instead of read, we use positional arguments
USER_NAME="${1}"
COMMENT="${2}"
PASSWORD="${3}"

if [[ -z "${USER_NAME}" || -z "${PASSWORD}" ]]; then
    echo "Usage: $0 <username> <comment> <password>"
    exit 1
fi

# Now you can run it like: 
# ./add-user.sh jdoe "John Doe" P@ssword123
```
