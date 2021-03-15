# Scratch

```bash

az group create \
-n cdw-azgitops-20210311 \
-l westus2


az ad sp create-for-rbac \
-n "cdw-azgitops-20210311-sp" \
--role Contributor \
--scopes /subscriptions/b9c770d1-cde9-4da3-ae40-95ce1a4fac0c/resourceGroups/cdw-azgitops-20210311

```
