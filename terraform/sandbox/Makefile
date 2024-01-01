#!make

SUBSCRIPTION_ID=8d01f77a-4a6f-4548-b5f3-743769a1b178
export

connect:
	az login
	az account set --subscription="${SUBSCRIPTION_ID}"
	az aks get-credentials --resource-group "${AKS_RESOURCE_GROUP}" --name "${AKS_CLUSTER}" --overwrite-existing
	kubectl config get-contexts
	kubectl config use-context ${AKS_CLUSTER}
	kubectl get namespaces
	kubectl config set-context --current --namespace=${AKS_NAMESPACE}

import: connect
	#terraform import azurerm_role_assignment.spn-acr-role\[\"AcrDelete\"\] /subscriptions/8d01f77a-4a6f-4548-b5f3-743769a1b178/providers/Microsoft.Authorization/roleAssignments/627dac5b-21bb-4568-aa52-f88d478f63b6
	terraform import azurerm_role_assignment.spn-acr-role\[\"AcrDelete\"\] /subscriptions/8d01f77a-4a6f-4548-b5f3-743769a1b178/providers/Microsoft.Authorization/roleAssignments/97c3e5d2-f2bb-4e91-a9b9-f3dbf8e4e94f
