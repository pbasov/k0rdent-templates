## k0rdent deployment on top of openstack

### Prerequisites
- Set up clouds.yaml in ~/.config/openstack/clouds.yaml
- `export OS_CLOUD=<cloud_name>`
- Check connectivity with `openstack token issue`

### Features
- Creates a new OpenStack project/tenant with a user
- Sets up networking (network, subnet, router, security groups)
- Deploys multiple VMs with configurable parameters
- Boot-from-volume configuration with 64GB Cinder volumes
- Configurable volume type (default: netapp-nvme)
- Assigns floating IPs to all VMs for external access
- Outputs VM IPs and floating IPs for easy access

### Split Configuration
The deployment is split into two separate directories:

1. **tenant/** - Creates the OpenStack project/tenant and user
2. **infra/** - Creates the infrastructure (VMs, networking, etc.) in the project created by the tenant configuration

This split is necessary because Terraform cannot create resources in a project that it also creates within the same configuration.

### Usage

#### Step 1: Create the Project/Tenant
1. Navigate to the tenant directory: `cd tenant`
2. Review and modify variables in `variables.tf` as needed:
   - Project name and description
   - User name and password settings
3. Initialize Terraform: `terraform init`
4. Apply the tenant configuration: `terraform apply`
5. Note the project_id from the output: `terraform output project_id`

#### Step 2: Create the Infrastructure
1. Navigate to the infra directory: `cd ../infra`
2. Set the project ID as an environment variable or pass it as a variable:
   - `export TF_VAR_project_id=<project_id_from_step_1>`
   - Or use: `terraform apply -var="project_id=<project_id_from_step_1>"`
3. Review and modify variables in `variables.tf` as needed:
   - VM count, name prefix, image, and flavor
   - Network settings (external network name, subnet CIDR)
   - Volume settings (size, type)
   - SSH public key (optional)
4. Initialize Terraform: `terraform init`
5. Apply the infrastructure configuration: `terraform apply`

After deployment, you can access your VMs using the floating IPs provided in the output.

### Automatic k0sctl.yaml Generation

The infrastructure deployment automatically generates a k0sctl.yaml file based on the created VMs. This file is used to deploy a k0s Kubernetes cluster on the VMs.

The k0sctl.yaml file is generated using a template (k0sctl.yaml.tftpl) and the Terraform outputs. The template includes:
- Cluster name and k0s version
- Network provider configuration
- Host configuration with private and floating IPs

After running `terraform apply` in the infra directory, the k0sctl.yaml file will be created or updated in the project root directory. You can then use it to deploy a k0s cluster with:

```bash
k0sctl apply -c k0sctl.yaml
```
