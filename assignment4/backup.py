import subprocess
import logging
import argparse
import datetime
from azure.identity import AzureCliCredential
from azure.mgmt.resource.subscriptions import SubscriptionClient

credential = AzureCliCredential()
subscription_client = SubscriptionClient(credential)
sub_list = subscription_client.subscriptions.list()

for group in list(sub_list):
    subscription_id = group.subscription_id

def parse_arguments():
    parser = argparse.ArgumentParser(description='Automate backup and restore for Azure SQL Database.')
    
    parser.add_argument('--action', required=True, help='Action to perform: backup, restore, list')
    parser.add_argument('--resource_group', required=False, help='Azure Resource Group name.')
    parser.add_argument('--server_name', required=False, help='Azure SQL Server name.')
    parser.add_argument('--database_name', required=False, help='Azure SQL Database name.')
    parser.add_argument('--storage_account_name', required=True, help='Azure Storage Account name.')
    parser.add_argument('--container_name', required=True, help='Azure Storage Container name.')
    parser.add_argument('--storage_account_key', required=False, help='Azure Storage Account key.')
    parser.add_argument('--backup_file_name', required=False, help='Backup file name.')
    parser.add_argument('--admin_user', required=False, help='Azure SQL Database Admin user.')
    parser.add_argument('--admin_password', required=False, help='Azure SQL Database Admin password.')

    args = parser.parse_args()
    return args

def execute_command(command):
    try:
        result = subprocess.run(command, shell=True, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        logging.info(result.stdout.decode())
    except subprocess.CalledProcessError as e:
        logging.error(e.stderr.decode())
        raise

def schedule_backup():
    try:
        # Overide filename
        backup_file_name = f'{database_name}_backup_{datetime.datetime.now().strftime("%Y%m%d%H%M%S")}.bacpac'

        # Create a backup using the Azure CLI
        backup_command = (
            f'az sql db export '
            f'--subscription {subscription_id} '
            f'--resource-group {resource_group} '
            f'--server {server_name} '
            f'--name {database_name} '
            f'--storage-key-type StorageAccessKey '
            f'--storage-key "{storage_account_key}" '
            f'--storage-uri "https://{storage_account_name}.blob.core.windows.net/{container_name}/{backup_file_name}" '
            f'--admin-user "{admin_user}" '
            f'--admin-password "{admin_password}"'
        )
        execute_command(backup_command)
        logging.info(f'Successfully created backup: {backup_file_name}')
    except Exception as e:
        logging.error(f'Failed to create backup: {str(e)}')

def restore_backup():
    try:
        # Create a backup using the Azure CLI
        backup_command = (
            f'az sql db import '
            f'--subscription {subscription_id} '
            f'--resource-group {resource_group} '
            f'--server {server_name} '
            f'--name {database_name} '
            f'--storage-key-type StorageAccessKey '
            f'--storage-key "{storage_account_key}" '
            f'--storage-uri "https://{storage_account_name}.blob.core.windows.net/{container_name}/{backup_file_name}" '
            f'--admin-user "{admin_user}" '
            f'--admin-password "{admin_password}"'
        )
        execute_command(backup_command)
        logging.info(f'Successfully restore backup: {backup_file_name}')
    except Exception as e:
        logging.error(f'Failed to restore backup: {str(e)}')

def list_backups():
    try:
        list_command = (
            f'az storage blob list '
            f'--account-name {storage_account_name} '
            f'--container-name {container_name} '
            f'--output table'
        )
        execute_command(list_command)
    except Exception as e:
        logging.error(f'Failed to list backups: {str(e)}')

if __name__ == "__main__":
    args = parse_arguments()
    action = args.action
    resource_group = args.resource_group
    server_name = args.server_name
    database_name = args.database_name
    storage_account_name = args.storage_account_name
    storage_account_key = args.storage_account_key
    container_name = args.container_name
    backup_file_name = args.backup_file_name
    admin_user = args.admin_user
    admin_password = args.admin_password

    if action.lower() == 'backup':
        schedule_backup()
    elif action.lower() == 'restore':
        restore_backup()
    elif action.lower() == 'list':
        list_backup()
    else:
        logging.info(f'Unknown action: {action}')