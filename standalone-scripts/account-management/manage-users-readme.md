In professional DevOps, we move away from "managing users on a per-server basis" and toward "managing identity as a service". DevOps team generally does not log into individual servers to `useradd` or `userdel`.

## How DevOps Team Handles User Lifecycles at Scale

### 1. The Industry Standard: Centralized Identity (The "Source of Truth")

In a company with hundreds or thousands of servers, WE use a **Centralized Identity Provider (IdP)**. The servers do not hold local user databases; they "ask" the IdP if a user is valid.

- **Tools:** **LDAP**, **Active Directory (AD)**, **FreeIPA**, or **Okta/Auth0** (via integration).

- **The Workflow:**
    - When new employees join, DevOps team creates their accounts in the IdP. They instantly get access to all authorized servers.

    - When employees leave, DevOps team disables them in the IdP. **Access is revoked everywhere instantly**.

    - **DevOps Benefit:** DevOps team barely has to `userdel` on a server again. The server simply stops accepting the user's credentials because the IdP says the account is disabled.

### 2. The Configuration Management Way (Ansible)

If you *must* manage local users (e.g., specific service accounts or unique developer access), you use **Configuration Management** instead of shell scripts.

- **The Tool:** **Ansible** is the industry leader for this.

- **The Workflow:** write a "Playbook" that declares the *state* of the user.
    - **Idempotency:** You don't tell the server "create this user." You tell it "Ensure user `dak` exists with these SSH keys."

    - If the user exists, Ansible does nothing. If the user is missing, it creates them. If you change the user's shell in your code, Ansible updates it.

- **Example:**

```yaml
- name: Manage developer account
  ansible.builtin.user:
    name: jdoe
    state: present  # Set to 'absent' to delete the user
    shell: /bin/bash
```

### 3. The Modern Cloud-Native Way (Zero-Trust/SSM)

In modern cloud environments (AWS, GCP, Azure), many DevOps teams are moving to **Zero-Trust** models, which eliminate the need for persistent OS-level user accounts for humans entirely.

- **The Tool:** **AWS Systems Manager (SSM) Session Manager** or **GCP OS Login**.

- **The Workflow:**
    - Instead of SSHing into a server, you use a CLI tool or web console to "jump" into the server via a secure, logged tunnel.

    - Authentication is handled by your Cloud IAM (Identity and Access Management).

    - The server doesn't even have a `/home/dak` folder. Access is transient and fully audited.

### Summary: The "DevOps Maturity" Ladder

| Maturity Level | Method | Best For... |
| --- | --- | --- |
| **Level 1** | Shell Scripts (`useradd`) | Learning basics, hobby projects. |
| **Level 2** | Ansible/Puppet | Managing local users on small-to-mid fleets. |
| **Level 3** | LDAP / FreeIPA | Scaling access across large, static server fleets. |
| **Level 4** | Cloud IAM / SSM | High-security, modern cloud-native environments. |

