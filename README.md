Cyber-Situational Awareness Dashboard: Installation and Set-up Guide 

Step 1: 

Install all files from the Cyber-Situational Awareness Dashboard OneDrive Folder 

Step 2: 

Run “sudo apt update” in the terminal 

 - This will update all the packages used in the project 

Step 3: 

Start the minikube node with “minikube start” 

Step 4: 

Use “cd /yaml_files” to path over to the folder containing the .yaml files 
In the Terminal, run “minikube kubectl -- apply  -f PodDeployment.yaml” 
Ensure pods deployed correctly by running “minikube kubectl get deployments” 
This will show the pod and its clone 
Step 5: 

Use “cd /ShellScripts” to path over to the Shell Script folder 
Inside should include ContStatus.sh, PdSH.sh, and PodYContStat.sh  
In terminal, run ./PodYContStat.sh to ensure Pods successfully deployed with active containers, showing the status of everything. 
Step 6: 

Before Deploying Zeek and launching the Dashboard, you need to configure Zeek to monitor your chosen network. This can be done by editing the Dockerfile. There is only one and it exists outside, on the Desktop.  

You will need to add “sed –i" commands, like you see in the file already, to configure node.cfg and networks.cfg to monitor the appropriate network in /usr/local/zeek/etc within the Zeek container. 
This ensures that these configurations are persistent through each restart cycle. 

*Warning* 	If you edit node.cfg or networks.cfg directly in the container, ALL your edits will be reset upon restarting the container. Any permanent changes you want made to the container must be done through Linux commands in the Dockerfile. 

 

 

Continue ---> 

Step 7: 

Once you have configured your Zeek files to monitor your chosen network and the correct location to save your logs, you can deploy Zeek by doing the following:  

In terminal, run: 
“minikube kuebctl -- exec –it <pod name> -c <container name> -- /bin/bash” 

This will bring you inside the Zeek container. 

Once inside the zeek container, we can run:  
	“zeekctl” 	--> brings you into ZeekControl 

"deploy" 	--> Deploys Zeek 

“exit” 		--> Exits out of ZeekControl  

 

Step 8: 

Path to the /senior_capstone directory in Terminal and run the following command:  

“flutter run –d web-server –web-hostname 0.0.0.0 --web-port 5002” 

 

This will start the dashboard and open a webpage in your browser with the dashboard.  

 

Enjoy! 
