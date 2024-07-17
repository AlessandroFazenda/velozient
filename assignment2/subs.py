from azure.identity import AzureCliCredential
from azure.mgmt.resource.subscriptions import SubscriptionClient

credential = AzureCliCredential()
subscription_client = SubscriptionClient(credential)
sub_list = subscription_client.subscriptions.list()
column_width = 40

print("Subscription ID".ljust(column_width) + "Display name")
print("-" * (column_width * 2))
for group in list(sub_list):
    subscription_id = group.subscription_id
    print(f'{group.subscription_id:<{column_width}}{group.display_name}')

