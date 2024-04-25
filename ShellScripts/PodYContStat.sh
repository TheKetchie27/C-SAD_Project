#!/bin/bash
# This shell script is created to return the status of both the pod and container status. 
# Running the shell script in the terminal returns the the status in the terminal.

# Check the status of pods
echo "Checking pod status..."
minikube kubectl -- get pods -o custom-columns="POD:metadata.name,STATUS:status.phase" --no-headers

# Check the status of each container within each pod
echo -e "\nChecking container status..."
pods=$(minikube kubectl -- get pods -o custom-columns=:metadata.name)
declare -A container_status

for pod in $pods; do
    containers=$(minikube kubectl -- get pod $pod -o custom-columns=:spec.containers[*].name --no-headers | tr -s '[:space:]' ',' | sed 's/,$//')
    for container in $(echo $containers | tr ',' ' '); do
        status=$(minikube kubectl -- get pod $pod -o jsonpath="{.status.containerStatuses[?(@.name == \"$container\")].state.running}")
        if [ -n "$status" ]; then
            container_status["$pod,$container"]="Running"
        else
            container_status["$pod,$container"]="Not Running"
        fi
    done
done

# Print container status
for key in "${!container_status[@]}"; do
    echo "Key: $key, Status: ${container_status[$key]}"
done

#Status variable = ${container_status[$key]}