#!/bin/bash
# This shell script is created to get the status of the containers in each pod. 
# To get container status, run shell script. Status will display in the terminal. 

# Function to get current timestamp
get_timestamp() {
    date +"%Y-%m-%d %H:%M:%S"
}

# Check the status of pods
echo "Checking pod status..."
pod_status=($(minikube kubectl -- get pods -o custom-columns="POD:metadata.name,STATUS:status.phase" --no-headers))



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

# Print pod status
for ((i=0; i<${#pod_status[@]}; i+=2)); do
    pod_name=${pod_status[$i]}
    pod_status_val=${pod_status[$((i+1))]}
    
done

# Print container status
echo -e "\nContainer Status:"
for key in "${!container_status[@]}"; do
    echo "Pod: $key, Status: ${container_status[$key]}"
done

# Print last reset container button press time
echo -e "\nLast reset container button press time: $(get_timestamp)"