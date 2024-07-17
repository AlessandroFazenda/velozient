from azure.identity import AzureCliCredential
from azure.mgmt.resource.subscriptions import SubscriptionClient
from azure.mgmt.resource import ResourceManagementClient
from azure.mgmt.compute import ComputeManagementClient
from azure.mgmt.sql import SqlManagementClient
from azure.mgmt.storage import StorageManagementClient
from azure.mgmt.storage.models import Sku, Kind
from azure.mgmt.network import NetworkManagementClient
import os
import logging

credential = AzureCliCredential()
subscription_client = SubscriptionClient(credential)
sub_list = subscription_client.subscriptions.list()

for group in list(sub_list):
    subscription_id = group.subscription_id

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Resource Group details
resource_group_name = "velo-python"
location = "brazilsouth"

# VM details
vm_name = "velo-python"
vm_size = "Standard_B1ms"
admin_username = "azureuser"
admin_password = "1Verycomplexpassword!"
vm_image = {
    'publisher': 'Canonical',
    'offer': 'UbuntuServer',
    'sku': '18.04-LTS',
    'version': 'latest'
}

# SQL Database details
sql_server_name = "velo-py-mssql"
sql_db_name = "velo-py-db"
sql_admin_username = "sqladmin"
sql_admin_password = "1Verycomplexpassword!"

# Storage Account details
storage_account_name = "velomystorageaccount"

def create_resource_group(resource_client):
    logger.info("Creating Resource Group...")
    resource_client.resource_groups.create_or_update(
        resource_group_name,
        {"location": location}
    )

def create_vm(compute_client):
    logger.info("Creating Virtual Machine...")

    # Network client setup
    network_client = NetworkManagementClient(credential, subscription_id)
    
    # Virtual Network and Subnet creation
    vnet_name = "velo-py-network"
    subnet_name = "velo-py-subnet"
    ip_name = "myPublicIP"
    nic_name = "myNIC"
    
    logger.info("Creating Virtual Network...")
    vnet = network_client.virtual_networks.begin_create_or_update(
        resource_group_name,
        vnet_name,
        {
            "location": location,
            "address_space": {"address_prefixes": ["192.168.0.0/16"]}
        }
    ).result()

    logger.info(f"Virtual Network '{vnet.name}' created successfully.")

    logger.info("Creating Subnet...")
    subnet = network_client.subnets.begin_create_or_update(
        resource_group_name,
        vnet_name,
        subnet_name,
        {"address_prefix": "192.168.1.0/24"}
    ).result()

    logger.info(f"Subnet '{subnet.name}' created successfully.")

    # Public IP Address creation
    logger.info("Creating Public IP Address...")
    public_ip = network_client.public_ip_addresses.begin_create_or_update(
        resource_group_name,
        ip_name,
        {
            "location": location,
            "public_ip_allocation_method": "Dynamic"
        }
    ).result()

    logger.info(f"Public IP Address '{public_ip.name}' created successfully.")

    # Network Interface creation
    logger.info("Creating Network Interface...")
    nic = network_client.network_interfaces.begin_create_or_update(
        resource_group_name,
        nic_name,
        {
            "location": location,
            "ip_configurations": [{
                "name": "myIPConfig",
                "subnet": {"id": subnet.id},
                "public_ip_address": {"id": public_ip.id}
            }]
        }
    ).result()

    logger.info(f"Network Interface '{nic.name}' created successfully.")

    # Virtual Machine creation
    logger.info("Creating Virtual Machine...")
    vm_parameters = {
        "location": location,
        "hardware_profile": {"vm_size": vm_size},
        "storage_profile": {
            "image_reference": {
                "publisher": vm_image['publisher'],
                "offer": vm_image['offer'],
                "sku": vm_image['sku'],
                "version": vm_image['version']
            }
        },
        "os_profile": {
            "computer_name": vm_name,
            "admin_username": admin_username,
            "admin_password": admin_password
        },
        "network_profile": {
            "network_interfaces": [{"id": nic.id}]
        }
    }

    vm = compute_client.virtual_machines.begin_create_or_update(
        resource_group_name,
        vm_name,
        vm_parameters
    ).result()

    logger.info(f"Virtual Machine '{vm.name}' created successfully.")

def setup_sql_database(sql_client):
    logger.info("Setting up SQL Database...")

    # Create SQL Server
    logger.info("Creating SQL Server...")
    sql_server = sql_client.servers.begin_create_or_update(
        resource_group_name,
        sql_server_name,
        {
            "location": location,
            "version": "12.0",
            "administrator_login": sql_admin_username,
            "administrator_login_password": sql_admin_password
        }
    ).result()

    logger.info(f"SQL Server '{sql_server.name}' created successfully.")

    # Create SQL Database
    logger.info("Creating SQL Database...")
    sql_database = sql_client.databases.begin_create_or_update(
        resource_group_name,
        sql_server_name,
        sql_db_name,
        {
            "location": location,
            "sku": {
                "name": "S1",
                "tier": "Standard"
            }
        }
    ).result()

    logger.info(f"SQL Database '{sql_database.name}' created successfully.")

def configure_storage_account(storage_client):
    logger.info("Configuring Storage Account...")
    storage_client.storage_accounts.begin_create(
        resource_group_name,
        storage_account_name,
        {
            'location': location,
            'sku': Sku(name='Standard_LRS'),
            'kind': Kind.STORAGE_V2
        }
    ).result()

def start_vm(compute_client):
    logger.info("Starting Virtual Machine...")
    compute_client.virtual_machines.begin_start(resource_group_name, vm_name).result()

def stop_vm(compute_client):
    logger.info("Stopping Virtual Machine...")
    compute_client.virtual_machines.begin_power_off(resource_group_name, vm_name).result()

def delete_vm(compute_client):
    logger.info("Deleting Virtual Machine...")
    compute_client.virtual_machines.begin_delete(resource_group_name, vm_name).result()

def main():
    try:
        resource_client = ResourceManagementClient(credential, subscription_id)
        compute_client = ComputeManagementClient(credential, subscription_id)
        sql_client = SqlManagementClient(credential, subscription_id)
        storage_client = StorageManagementClient(credential, subscription_id)
        
        create_resource_group(resource_client)
        create_vm(compute_client)
        setup_sql_database(sql_client)
        configure_storage_account(storage_client)
        start_vm(compute_client)
        stop_vm(compute_client)
        #delete_vm(compute_client)

    except Exception as e:
        logger.error(f"An error occurred: {e}")

if __name__ == "__main__":
    main()
