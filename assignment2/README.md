# Assigment 1:

## Objetive:
Automate the management of Azure resources using Python and Azure SDK.

### Requirements:
- Write a Python script that performs the following tasks:
  - Creates a resource group.
  - Deploys a Virtual Machine (VM) with specified configurations (e.g., size, image).
  - Sets up an Azure SQL Database.
  - Configures a Storage Account.
- The script should include error handling and logging.

### Automation:
- Ensure the script can be run multiple times without causing conflicts or resource duplication.
- Implement functions to start, stop, and delete the VM.

### Documentation:
- Provide a README file with instructions on how to set up and run the script
- Include a section on how the script handles errors and logs activities.

## How to use it:
- `pip install azure-mgmt-resource azure-mgmt-compute azure-mgmt-sql azure-mgmt-storage azure-mgmt-network azure-identity logging`
- `python az.py`

## Error handling:
- Error handling is managed by python using `try` ... `except` block on main. Any error will interrupt all execution of script.
- TODO: use `try` ... `except` blocks on each `def` to avoid script interruption.

## Logging:
- Logging is managed by `logging` package.
- All messages are send to `stdout` except the errors are send to `stderr`.
