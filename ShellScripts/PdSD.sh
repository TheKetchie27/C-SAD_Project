 #!/bin/bash
 # This shell script is created to shutdown/restart pods within a cluster. 

# Display a prompt for the user
# echo "Enter the index of the pod you want to terminate:"

# Prompt the user for the pod index
# read POD_INDEX

# Get the name of the pod based on the user input                    $POD_INDEX vvv Insert here if needed
POD_NAME=$(minikube kubectl -- get pods -l app=zeek-mongodb -o jsonpath="{.items[0].metadata.name}")

# Check if the pod name is not empty
if [ -n "$POD_NAME" ]; then
    echo "Terminating pod: $POD_NAME"
    minikube kubectl -- delete pod "$POD_NAME"
else
    echo "No pods found with label app=zeek-mongodb or invalid index provided."
fi

# Wait for first pod to restart before deleting second pod.
#sleep 5

POD_NAME=$(minikube kubectl -- get pods -l app=zeek-mongodb -o jsonpath="{.items[1].metadata.name}")

# Check if the pod name is not empty
if [ -n "$POD_NAME" ]; then
    echo "Terminating pod: $POD_NAME"
    minikube kubectl -- delete pod "$POD_NAME"
else
    echo "No pods found with label app=zeek-mongodb or invalid index provided."
fi