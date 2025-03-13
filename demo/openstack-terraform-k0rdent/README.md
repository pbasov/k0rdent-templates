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

### Application Credentials

The infrastructure deployment also creates OpenStack application credentials that can be used for programmatic access to the OpenStack API. These credentials are generated as part of the infrastructure deployment and are output as clear text.

#### Configuration

You can configure the application credentials by modifying the following variables in `infra/variables.tf`:

- `app_cred_name`: Name of the application credential (default: "k0rdent-app-cred")
- `app_cred_description`: Description of the application credential
- `app_cred_roles`: List of roles to assign to the application credential (default: ["member"])
- `app_cred_expiration`: Expiration time for the application credential (RFC3339 format, e.g., 2025-12-31T23:59:59Z)
- `app_cred_unrestricted`: Whether the application credential has unrestricted access (default: false)

#### Outputs

After running `terraform apply` in the infra directory, the following application credential information will be available in the Terraform outputs:

- `application_credential_id`: The ID of the application credential
- `application_credential_name`: The name of the application credential
- `application_credential_secret`: The secret of the application credential (as clear text)
- `openrc_content`: OpenRC file content for the application credential
- `clouds_yaml_content`: clouds.yaml content for the application credential

You can view these outputs with:

```bash
terraform output application_credential_id
terraform output application_credential_secret
terraform output openrc_content
terraform output clouds_yaml_content
```

#### Usage

To use the application credentials, you can either:

1. Create an OpenRC file using the `openrc_content` output:
   ```bash
   terraform output -raw openrc_content > openrc.sh
   # Edit the file to replace <your_auth_url> and <your_region> with actual values
   source openrc.sh
   ```

2. Create a clouds.yaml file using the `clouds_yaml_content` output:
   ```bash
   terraform output -raw clouds_yaml_content > clouds.yaml
   # Edit the file to replace <your_auth_url> and <your_region> with actual values
   export OS_CLOUD=k0rdent
   ```

**Note:** For production environments, consider setting `sensitive = true` for these outputs in `main.tf` and using more secure methods to retrieve the credentials.
