// ignore_for_file: use_build_context_synchronously

//import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:process_run/shell.dart';
//import 'package:web_socket_channel/io.dart';
//import 'package:web_socket_channel/web_socket_channel.dart';
//import 'log_parser.dart';

class logHelper {
 static List<List<String>> parseLogFile(String filePath) {
  try {
    // Read the contents of the file
    String logData = File(filePath).readAsStringSync();

    // Split the log data into lines
    List<String> lines = logData.split('\n');

    // Create a list to store lines
    List<List<String>> logLines = [];

    // Iterate over the lines in the log data
    for (String line in lines) {
      // Skip lines that start with '#'
      if (line.startsWith('#')) {
        continue;
      }

      // Split the line into fields
      List<String> fields = line.split('\n'); // assuming '\t' is the field separator

      // Add the fields to the list
      logLines.add(fields);
    }

    return logLines;
  } catch (error) {
    // Handle the error gracefully
    print('Error reading or parsing the log file: $error');
    return []; // Return an empty list or another appropriate value
  }
}
}

class CustomAlertDialog {

  //final WebSocketChannel channel;
     // IOWebSocketChannel.connect('ws://localhost:8080');
  final BuildContext context;

  CustomAlertDialog(this.context); //this.channel

  void showAlert(List<Map<String, String>>? alerts, int index) {
    if (alerts != null && index >= 0 && index < alerts.length) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('${alerts[index]['type']} Alert'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                    Text(
                      alerts[index]['message'] ?? 'No message available',
                      style: const TextStyle(fontSize: 22), // Adjust the fontSize as needed
                    ),
                    const SizedBox(height: 6),
                  ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Ignore'),
              ),
              TextButton(
                onPressed: () => showBottomModalSheet(context),
                child: const Text('More Info'),
              ),
              TextButton(
                onPressed: () => ResetPodShellScript(context),
                child: const Text('Reset Pod'),
              ),
              TextButton(
                onPressed: () => stepperMitigate(context, "This will show steps to help fix problem"),
                child: const Text('Help'),
              ),
            ],
          );
        },
      );
    } else {
      print('Invalid index or alerts is null');
    }
  }


void ResetPodShellScript(BuildContext context) async {//WebSocketChannel webSocket
  // Show a loading indicator
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const AlertDialog(
        title: Text('Loading...'),
        content: CircularProgressIndicator(),
      );
    },
  );

  try {
    await Future.delayed(const Duration(seconds: 15));

    // Send a message to the WebSocket server to reset the pod
   // channel.sink.add(jsonEncode({'command': 'reset_pod'}));
    var shellContext = Shell();
       //Create a Shell instance with ShellContext
    var shell = Shell(workingDirectory: shellContext.path);

      // Run the shell script using the Shell instance
     await shell.run('sh /home/cis/ShellScripts/PdSD.sh');
    // Close the loading indicator
    Navigator.pop(context);

    // Show success message
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Pod reset successfully!'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  } catch (error) {
    // Close the loading indicator
    Navigator.pop(context);

    // Show error message
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text('Error resetting pod: $error'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}


//shows corresponding log error
void showBottomModalSheet(BuildContext context) {
/*  List<List<String>> logLines = logHelper.parseLogFile('zat/data/files.log');
  if (logLines.isNotEmpty && logLines[0].isNotEmpty) {
      List<String> info = logLines[0];*/
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             const Text('1379288668.148196	CnKO90rg6a1qQ9Fc	192.168.33.10	1033	54.230.86.87	443	TLSv10	TLS_RSA_WITH_RC4_128_MD5	-	-	CN=*.cloudfront.net,O=Amazon.com\, Inc.,L=Seattle,ST=Washington,C=US	CN=DigiCert High Assurance CA-3,OU=www.digicert.com,O=DigiCert Inc,C=US	1289368800.000000	1384408799.000000	-	-	-	5976df54f826f8a1bb018f26ed251980	ok'),
            const SizedBox(height: 16.0),
            // Add your content/widgets here
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the modal sheet
              },
              child: const Text('Close'),
            ),
          ],
        ),
      );
    },
  );
 } /*else {
    print('Log file is empty or does not contain expected data.');
  }*/
}

//creates step
  void stepperMitigate(BuildContext context, String alertType) { //this creates the step when u press "help"
  int _currentStep = 0;

  List<Step> _steps = [
     Step(
      title: const Text('Disconnect'),
      content: Text(stepsToMitigate[0]['message'] ?? 'No message available'),
      isActive: true,
    ),
     Step(
      title: const Text('Review'),
      content: Text(stepsToMitigate[1]['message'] ?? 'No message available'),
      isActive: false,
    ),
     Step(
      title: const Text('Change'),
      content: Text(stepsToMitigate[2]['message'] ?? 'No message available'),
      isActive: false,
    ),
  ];

//shows steps to mitigate alert
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: const Text('Steps to Mitigate Alert'),
            content: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SizedBox(
                width: 300,
                child: Stepper(
                  currentStep: _currentStep,
                  onStepContinue: () {
                    if (_currentStep < _steps.length - 1) {
                      setState(() {
                        _currentStep++;
                      });
                    }
                  },
                  onStepCancel: () {
                    if (_currentStep > 0) {
                      setState(() {
                        _currentStep--;
                      });
                    }
                  },
                  steps: _steps,
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the AlertDialog
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    },
  );
}




//alerts
final List<Map<String, String>> banditAlerts = [
  {
    'type': 'Conn.log',
    'severity': 'HIGH',
    'message': 'Alert: Unusual network connections detected. Potential unauthorized access.',
  },
  {
    'type': 'Ssh.log',
    'severity': 'MEDIUM',
    'message': 'Alert: Suspicious SSH connection attempted. Potential unauthorized login.',
  },
  {
    'type': 'Dns.log',
    'severity': 'MEDIUM',
    'message': 'Alert: Unusual DNS requests detected. Possible malicious activity.',
  },
  {
    'type': 'Ftp.log',
    'severity': 'HIGH',
    'message': 'Alert: Suspicious FTP connection attempted. Potential unauthorized data transfer.',
  },
  {
    'type': 'Ntp.log',
    'severity': 'LOW',
    'message': 'Alert: Unusual NTP traffic detected. Potential attempt to compromise time synchronization (All network devices on same time).',
  },
];

final List<Map<String, String>> networkAlerts = [
  {
    'type': 'Http.log',
    'severity': 'HIGH',
    'message': 'Alert: Potential unauthorized access attempt detected from IP address 192.168.1.100 to server 10.0.0.5 at 14:30:21. Please investigate.',
  },
  {
    'type': 'Ssl.log',
    'severity': 'HIGH',
    'message': 'Alert: Potential unauthorized access attempt detected from IP address 192.168.1.100 to server 10.0.0.5 at 14:30:21. Please investigate.',
  },
  {
    'type': 'Notice.log',
    'severity': 'HIGH',
    'message': 'Alert: Potential unauthorized access attempt detected from IP address 192.168.1.100 to server 10.0.0.5 at 14:30:21. Please investigate.',
  },
];

final List<Map<String, String>> bugAlerts = [
  {
    'type': 'Files.log',
    'severity': 'MEDIUM',
    'message': 'Alert: Suspicious file transfer detected from an internal host to an external IP address.',
  },
  {
    'type': 'Weird.log',
    'severity': 'LOW',
    'message': 'Alert: Unusual traffic pattern detected - possible external user scanning devices to identify open ports and services running on network.',
  },
  {
    'type': 'Notice.log',
    'severity': 'MEDIUM',
    'message': 'Alert: Potential external user trying to hack web server using SQL Injection (harmful code injected into your already working good code).',
  },
  {
    'type': 'Smpt.log',
    'severity': 'LOW',
    'message': 'Alert: Abnormal email behavior observed - large volume of emails sent from an internal IP address within a short time span.',
  },
];


final List<Map<String, String>> potentialAlerts = [
  {
    'type': 'Dhcp.log',
    'severity': 'LOW',
    'message': 'Alert: Unrecognized device attempting to connect to network.',
  },
];

final List<Map<String, String>> logErrors = [
  {
    'type': 'random',
    'message': '{"ts": 1591367999.305988,"uid": "CMdzit1AMNsmfAIiQc","id.orig_h": "192.168.4.76","id.orig_p": 36844,"id.resp_h": "192.168.4.1"}'
,
  },
];

final List<Map<String, String>> stepsToMitigate = [
  {
    'type': 'step 1 ssh',
    'message': 'Disconnect unauthorized device if it is still connected.'
,
  },
  {
    'type': 'step 2 ssh',
    'message': 'Review Access logs to identify source of unauthorized device.'
,
  },
  {
    'type': 'step 3 ssh',
    'message': 'Change SSH credentials and make sure configuration is up to date.'
,
  },
  {
    'type': 'step 1 files',
    'message': '{"ts": 1591367999.305988,"uid": "CMdzit1AMNsmfAIiQc","id.orig_h": "192.168.4.76","id.orig_p": 36844,"id.resp_h": "192.168.4.1"}'
,
  },
   {
    'type': 'step 2 files',
    'message': '{"ts": 1591367999.305988,"uid": "CMdzit1AMNsmfAIiQc","id.orig_h": "192.168.4.76","id.orig_p": 36844,"id.resp_h": "192.168.4.1"}'
,
  },
   {
    'type': 'step 3 files',
    'message': '{"ts": 1591367999.305988,"uid": "CMdzit1AMNsmfAIiQc","id.orig_h": "192.168.4.76","id.orig_p": 36844,"id.resp_h": "192.168.4.1"}'
,
  },
];
