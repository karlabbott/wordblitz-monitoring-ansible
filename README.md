# WordBlitz Monitoring Ansible Playbook

Ansible playbook to set up Azure Monitor, Managed Grafana, and a monitoring dashboard for WordBlitz infrastructure.

## What It Does

1. Creates a Log Analytics Workspace
2. Enables system-assigned managed identities on target VMs
3. Installs Azure Monitor Agent on all VMs
4. Creates a Data Collection Rule (perf counters + syslog)
5. Associates the DCR with all VMs
6. Configures PostgreSQL and Nginx to log to syslog on the VMs
7. Creates an Azure Managed Grafana instance with an Azure Monitor data source
8. Deploys a 16-panel infrastructure dashboard

## Prerequisites

- Python 3.10+
- Ansible 2.15+
- Azure CLI authenticated (`az login`)
- `azure.azcollection` Ansible collection
- SSH access to the target VMs

## Quick Start

```bash
# Install dependencies
pip install ansible
ansible-galaxy collection install azure.azcollection
pip install -r ~/.ansible/collections/ansible_collections/azure/azcollection/requirements.txt

# Copy and edit variables
cp group_vars/all.yml.example group_vars/all.yml
# Edit group_vars/all.yml with your values

# Run the playbook
ansible-playbook site.yml
```

## Variables

All configurable variables are in `group_vars/all.yml`. Key variables:

| Variable | Description |
|---|---|
| `azure_subscription_id` | Azure subscription for monitoring resources |
| `azure_resource_group` | Resource group containing the VMs |
| `azure_location` | Azure region (e.g., `eastus`) |
| `law_name` | Log Analytics Workspace name |
| `grafana_name` | Managed Grafana instance name |
| `db_vm_name` | Database VM resource name in Azure |
| `app_vm_name` | Application VM resource name in Azure |
| `db_vm_host` | SSH host for the DB VM (IP or hostname) |
| `app_vm_host` | SSH host for the App VM (IP or hostname) |
| `ssh_user` | SSH username for VM access |
| `db_vm_computer_name` | Computer name as it appears in syslog/perf (usually the hostname) |
| `app_vm_computer_name` | Computer name for the app VM in syslog |
| `app_vm_perf_computer_name` | Computer name for the app VM in Perf table (may differ from syslog) |

## Roles

| Role | Description |
|---|---|
| `log_analytics` | Creates the Log Analytics Workspace |
| `vm_identity` | Enables system-assigned managed identity on VMs |
| `azure_monitor_agent` | Installs AMA extension on VMs |
| `data_collection_rule` | Creates DCR and associates it with VMs |
| `vm_logging` | Configures PostgreSQL syslog and Nginx syslog on VMs |
| `grafana` | Creates Managed Grafana, configures data source, deploys dashboard |
