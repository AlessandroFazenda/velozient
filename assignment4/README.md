# Assigment 4:

## Objetive:
Automate the backup and restore process for an Azure SQL Database using Azure CLI and scripting.

### Backup Process:
- Write a script using Python that performs the following tasks:
  - Schedules regular backups for an Azure SQL Database.
  - Stores the backups in a specified Azure Storage Account.

### Restore Process:
- Extend the script to include a restore function that can restore the database from a specified backup.
- Implement error handling and logging for both backup and restore operations.

### Automation:
- Ensure the script can be scheduled to run at specified intervals using a cron job.
- Include functionality to list available backups and their details.

### Documentation:
- Provide a README file with instructions on how to set up, run, and schedule the script.
- Include details on customizing backup schedules and restore operations.

## Requirements:
- `pip install azure.identity azure-identity logging argparse`

## How to backup:
- `python backup.py --action BACKUP --resource_group RESOURCE_GROUP --server_name SERVER_NAME --database_name DATABASE_NAME --storage_account_name STORAGE_ACCOUNT_NAME --container_name CONTAINER_NAME --storage_account_key STORAGE_ACCOUNT_KEY --admin_user ADMIN_USER --admin_password ADMIN_PASSWORD`

## How to restore:
- `python backup.py --action RESTORE --resource_group RESOURCE_GROUP --server_name SERVER_NAME --database_name DATABASE_NAME --storage_account_name STORAGE_ACCOUNT_NAME --container_name CONTAINER_NAME --storage_account_key STORAGE_ACCOUNT_KEY --backup_file_name BACKUP_FILE_NAME --admin_user ADMIN_USER --admin_password ADMIN_PASSWORD`

## How to list files:
- `python backup.py --action LIST --storage_account_name STORAGE_ACCOUNT_NAME --container_name CONTAINER_NAME`

## How to schedule:
- Create a new line in file `/etc/crontab` in the following format:
<pre># Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name command to be executed</pre>
- Example to run a backup every day at 10PM:
- `00 10 * * * azuser python backup.py --action RESTORE --resource_group RESOURCE_GROUP --server_name SERVER_NAME --database_name DATABASE_NAME --storage_account_name STORAGE_ACCOUNT_NAME --container_name CONTAINER_NAME --storage_account_key STORAGE_ACCOUNT_KEY --backup_file_name BACKUP_FILE_NAME --admin_user ADMIN_USER --admin_password ADMIN_PASSWORD`

## Backup log:
<pre></pre>

## Restore log:
<pre></pre>