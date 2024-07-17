# Assigment 1:

## Objetive:
Automate the deployment of a scalable web application in Azure using Terraform.

### Infrastructure Requirements:
- A Virtual Network (VNet) with subnets for web, application, and database tiers.
- Two Virtual Machines (VMs) in the web tier with a Load Balancer.
- A VM in the application tier.
- An Azure SQL Database in the database tier.
- A Network Security Group (NSG) with appropriate rules for each tier.

### Automation:
- Write Terraform scripts to deploy the above infrastructure.
- Ensure the infrastructure is highly available and scalable.

### Documentation:
- Provide a README file explaining the Terraform scripts.
- Include a cost estimate for the deployed infrastructure.

## Structure of the project:
```
./
├── provider.tf
├── rg.tf
├── vpc.tf
├── backend.tf
├── bastion.tf
├── database.tf
├── frontend.tf
├── load_balancer_backend.tf
├── load_balancer_frontend.tf
├── nsg.tf
├── output.tf
└── vars.tf
```

## How to use it:
- `terraform init`
- `terraform plan`
- `terraform apply --auto-aprove`

## Cost estimation:
| Resource | Cost hour |
|----------|-----------|
| `velo-frontendvm1` | $0.017 |
| `velo-frontendvm2` | $0.017 |
| `velo-backendvm1` | $0.017 |
| `velo-bastion` | $0.29 |
| `velo-database` | $0.136 |
| `velo-frontend-lb` | $0.0225 |
| `velo-backend-lb` | $0.0225 |

### Grand total: $0,522/hour

## Images:
![bastion](https://github.com/AlessandroFazenda/velozient/blob/main/assignment1/images/bastion.png?raw=true)
![database](https://github.com/AlessandroFazenda/velozient/blob/main/assignment1/images/database.png?raw=true)
![load_balancers](https://github.com/AlessandroFazenda/velozient/blob/main/assignment1/images/load_balancers.png?raw=true)
![network](https://github.com/AlessandroFazenda/velozient/blob/main/assignment1/images/network.png?raw=true)
![computes](https://github.com/AlessandroFazenda/velozient/blob/main/assignment1/images/computes.png?raw=true)
