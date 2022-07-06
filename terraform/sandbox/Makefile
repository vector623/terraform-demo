#!make

include ../../config/sandbox/aks.env
include ../../config/sandbox/aks-sensitive.env
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