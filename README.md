# Sample Usage

```bash

# Create a resource group for storing the managed identity and running the ACI
az group create -n cdw-azgitops-master-20210324 -l westus2

# Create a managed identity that we can use to run the ACI
az identity create -n cdw-gitops-20210324-msi -g cdw-azgitops-master-20210324 -l westus2

{
  "clientId": "cccccccc-cccc-cccc-cccc-cccccccccccc",
  "clientSecretUrl": "...",
  "id": "...",
  "location": "westus2",
  "name": "cdw-gitops-20210324-msi",
  "principalId": "pppppppp-pppp-pppp-pppp-pppppppppppp",       # <== USE THIS
  "resourceGroup": "cdw-azgitops-master-20210324",
  "tags": {},
  "tenantId": "...",
  "type": "Microsoft.ManagedIdentity/userAssignedIdentities"
}

# Make sure the identity has rights to contribute to the Subscription
az role assignment create --assignee 'pppppppp-pppp-pppp-pppp-pppppppppppp' --role 'Contributor'

# Create the ACI which will execute the bicep from the Git repo
az container create \
-g cdw-azgitops-master-20210324 \
-n cdw-azgitops-20210324 \
--image cwiederspan/azgitops:latest \
--cpu 0.5 \
--memory 0.5 \
--restart-policy Never \
--assign-identity '/subscriptions/ssssssss-ssss-ssss-ssss-ssssssssssss/resourcegroups/cdw-azgitops-master-20210324/providers/Microsoft.ManagedIdentity/userAssignedIdentities/cdw-gitops-20210324-msi' \
--environment-variables \
  'GIT_REPO_URI'='github.com/cwiederspan/az-gitops-src-poc' \
  'GIT_BOOTSTRAP_PATH'='main.bicep'

```
