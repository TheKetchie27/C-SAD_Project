import 'dart:io';
import 'package:flutter/material.dart';
//import 'package:web_socket_channel/io.dart';
//import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'alerts.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'containers.dart';
import 'dart:math';
import 'package:flutter/services.dart';
//import 'dart:convert';
//import 'log_parser.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
   // Function to set up shell context
  void setupShellContext() {
    if (Platform.isWindows) {
      // For Windows, set up shell context to cmd.exe
      SystemChannels.platform.setMethodCallHandler((MethodCall call) async {
        if (call.method == 'SystemShell') {
          return 'cmd.exe';
        }
        return null;
      });
    }
  }
  setupShellContext();
}




class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
 
  String severity = 'HIGH';


  // List to hold all alerts
  List<Map<String, dynamic>> allAlerts = [];


  bool showbanditAlert = false; //for alert panel
  bool showNetworkAlert = false;
  bool showBugAlert = false;
  bool showPotentialAlert = false;
 
  //string so they hold correct time when printed
  String banditAlertMessage = '';
  String networkAlertMessage = '';
  String bugAlertMessage = '';
  String potentialAlertMessage = '';




  Color _yellowBandit = const Color.fromARGB(108, 11, 142, 154);
  Color _yellowNetwork = const Color.fromARGB(108, 11, 142, 154);
  Color _yellowBug = const Color.fromARGB(108, 11, 142, 154);
  Color _yellowPotential = const Color.fromARGB(108, 11, 142, 154);
  Color container_status = const Color.fromARGB(108, 11, 142, 154);


  //picks a random number in each of the alert arrays to display an alert
  int randomIndex1 = Random().nextInt(banditAlerts.length);
  int randomIndex2 = Random().nextInt(networkAlerts.length);
  int randomIndex3 = Random().nextInt(bugAlerts.length);
  int randomIndex4 = Random().nextInt(potentialAlerts.length);




void _handleButtonPress(String light) {
  setState(() {
    switch (light) {
      case 'bandit':
        _yellowBandit = const Color.fromARGB(108, 11, 142, 154);
        break;
      case 'network':
        _yellowNetwork = const Color.fromARGB(108, 11, 142, 154);
        break;
      case 'bug':
        _yellowBug = const Color.fromARGB(108, 11, 142, 154);
        break;
      case 'potential':
        _yellowPotential = const Color.fromARGB(108, 11, 142, 154);
        break;
      default:
        // Handle default case if needed
        break;
    }
  });
}




  @override
  void initState() { //causes icons to light up when an alert has fired
    super.initState();
   
    //populate all alerts so we can sort based on severity
    allAlerts.addAll(banditAlerts);
    allAlerts.addAll(networkAlerts);
    allAlerts.addAll(bugAlerts);
    allAlerts.addAll(potentialAlerts);


    // Generate random delays for alerts
    Random random = Random();
    int banditDelay = random.nextInt(20) + 10; // Between 10 and 30 seconds
    int networkDelay = random.nextInt(30) + 25; // Between 15 and 45 seconds
    int bugDelay = random.nextInt(30) + 35; // Between 25 and 50 seconds
    int potentialDelay = random.nextInt(35) + 55; // Between 35 and 65 seconds


   
    // Show alerts after random delays
    Future.delayed(Duration(seconds: banditDelay), () {
     setState(() {
       _yellowBandit = Colors.yellow;


        String severity = banditAlerts[randomIndex1]['severity'] ?? ''; // Get severity
        String message = banditAlerts[randomIndex1]['message'] ?? '';   // Get message


       String alertInfo = '$severity $message'; // Concatenate severity and message


       banditAlertMessage =
            '${DateFormat('HH:mm:ss').format(DateTime.now())} $alertInfo';
       showbanditAlert = true;
     });
    });
    Future.delayed(Duration(seconds: networkDelay), () {
      setState(() {
        _yellowNetwork = Colors.yellow;
       
        String severity = networkAlerts[randomIndex2]['severity'] ?? ''; // Get severity
        String message = networkAlerts[randomIndex2]['message'] ?? '';   // Get message


        String alertInfo = '$severity $message'; // Concatenate severity and message


        networkAlertMessage =
          ' ${DateFormat('HH:mm:ss').format(DateTime.now())} $alertInfo';
       showNetworkAlert = true;
      });
    });
    Future.delayed(Duration(seconds: bugDelay), () {
       setState(() {
        _yellowBug = Colors.yellow;
     
        String severity = bugAlerts[randomIndex3]['severity'] ?? ''; // Get severity
        String message = bugAlerts[randomIndex3]['message'] ?? '';   // Get message


        String alertInfo = '$severity $message'; // Concatenate severity and message


        bugAlertMessage =
            '${DateFormat('HH:mm:ss').format(DateTime.now())} $alertInfo';
        showBugAlert = true;
      });
    });
    Future.delayed(Duration(seconds: potentialDelay), () {
      setState(() {
        _yellowPotential = Colors.yellow;


        String severity = potentialAlerts[randomIndex4]['severity'] ?? ''; // Get severity
        String message = potentialAlerts[randomIndex4]['message'] ?? '';   // Get message


        String alertInfo = '$severity $message'; // Concatenate severity and message


        potentialAlertMessage =
           '${DateFormat('HH:mm:ss').format(DateTime.now())} $alertInfo';
        showPotentialAlert = true;
      });
    });
  }




  @override
  Widget build(BuildContext context) {
    DateTime time = DateTime.now();
    String formattedTime = DateFormat('HH:mm:ss').format(time); // Change the format as needed


     //WebSocketChannel webSocketChannel = IOWebSocketChannel.connect('ws://localhost:8080');
    CustomAlertDialog customAlertDialog = CustomAlertDialog(context);//webSocketChannel
    //establish websocket connection
   
    // Filtering alerts and creating lists based on severity
final List<Map<String, String>> highAlerts = [];
final List<Map<String, String>> mediumAlerts = [];
final List<Map<String, String>> lowAlerts = [];
for (final alert in banditAlerts) {
    if (alert['severity'] == 'HIGH') {
        highAlerts.add(alert);
    } else if (alert['severity'] == 'MEDIUM') {
        mediumAlerts.add(alert);
    } else {
        lowAlerts.add(alert);
    }
}
for (final alert in networkAlerts) {
    if (alert['severity'] == 'HIGH') {
        highAlerts.add(alert);
    } else if (alert['severity'] == 'MEDIUM') {
        mediumAlerts.add(alert);
    } else {
        lowAlerts.add(alert);
    }
}
for (final alert in bugAlerts) {
    if (alert['severity'] == 'HIGH') {
        highAlerts.add(alert);
    } else if (alert['severity'] == 'MEDIUM') {
        mediumAlerts.add(alert);
    } else {
        lowAlerts.add(alert);
    }
}
for (final alert in potentialAlerts) {
    if (alert['severity'] == 'HIGH') {
        highAlerts.add(alert);
    } else if (alert['severity'] == 'MEDIUM') {
        mediumAlerts.add(alert);
    } else {
        lowAlerts.add(alert);
    }
}
// This builds the titles for the dashboard and the different buttons in the first row
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Situational Awareness Dashboard'),
        ),
        body: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (var title in [
                    'Unauthorized User Warnings',
                    'HTTP Warnings',
                    'Potential Bugs',
                    'Potential Issues',
                    'Container Status',
                  ])
                Expanded(
                 child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                          textAlign: TextAlign.center, // Center the text within the column
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // This creates our row of five buttons on the top of the screen 
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildRoundedContainerWithButton(
                    _yellowBandit,
                    'assets/Robber.png',
                    () {
                      _handleButtonPress('bandit');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Bandit()),
                      );
                      customAlertDialog.showAlert(banditAlerts, randomIndex1); // displays alerts
                    },
                  ),
                  _buildRoundedContainerWithButton(
                    _yellowNetwork,
                    'assets/Network.png',
                    () {
                      _handleButtonPress('network');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NetworkIssue()),
                      );
                      customAlertDialog.showAlert(networkAlerts, randomIndex2); // displays alerts
                    },
                  ),
                  _buildRoundedContainerWithButton(
                    _yellowBug,
                    'assets/Bug.png',
                    () {
                      _handleButtonPress('bug');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Bug()),
                      );
                      customAlertDialog.showAlert(bugAlerts, randomIndex3); // displays alerts
                    },
                  ),
                  _buildRoundedContainerWithButton(
                    _yellowPotential,
                    'assets/Warning2.png',
                    () {
                      _handleButtonPress('potential');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PotentialWarnings()),
                      );
                      customAlertDialog.showAlert(potentialAlerts, randomIndex4); // displays alerts
                    },
                  ),
                  _buildRoundedContainerWithButton( container_status,
                    'assets/Container.png', //Container icon
                    () {
                      //_handleButtonPress();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ContainerStatus()),
                      );
                    },
                  ),




            ],
          ),



            // This stack creates alerts box at the bottom of the screen
              Stack(
                children: [
              const SizedBox(height: 20),
              SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300], // alerts box
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(
                          'Alerts (Past hour)\n',
                          style: GoogleFonts.lora(
                            textStyle: const TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                  Padding (
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
                        value: severity,
                        onChanged: (String? newValue) {
                        setState(() {
                            severity = newValue!;
                        });
                      },
                      items: <String>['HIGH', 'MEDIUM', 'LOW']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
 
 //THE FOLLOWING WILL BE USED TO SEPARATE THE ALERTS BASED ON SEVERITY AND THEIR CATEGORY                  
                     // Bandit Alerts
                     //only show high severity bandit alerts
                      if(highAlerts.contains(banditAlerts[randomIndex1])&&severity == 'HIGH')
                      Positioned(
                        top: 40.0,
                        left: 12.0,
                        child: Text(
                          banditAlertMessage,
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Color.fromARGB(255, 187, 34, 34),
                          ),
                        ),
                      ),
                     
                    //only show medium severity bandit alerts
                      if(mediumAlerts.contains(banditAlerts[randomIndex1])&&severity == 'MEDIUM')
                      Positioned(
                        top: 40.0,
                        left: 12.0,
                        child: Text(
                          banditAlertMessage,
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Color.fromARGB(255, 198, 116, 28),
                          ),
                        ),
                      ),


                   //only show low severity bandit alerts
                      if(lowAlerts.contains(banditAlerts[randomIndex1])&&severity == 'LOW')
                      Positioned(
                        top: 40.0,
                        left: 12.0,
                        child: Text(
                          banditAlertMessage,
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Color.fromARGB(245, 245, 196, 6),
                          ),
                        ),
                      ),


                    // Network Alerts  
                    //only show high severity network alerts
                      if(highAlerts.contains(networkAlerts[randomIndex2])&&severity == 'HIGH')
                      Positioned(
                        top: 40.0,
                        left: 12.0,
                        child: Text(
                          networkAlertMessage,
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Color.fromARGB(255, 187, 34, 34),
                          ),
                        ),
                      ),


                    //only show medium severity network alerts
                      if(mediumAlerts.contains(networkAlerts[randomIndex2])&&severity == 'MEDIUM')
                      Positioned(
                        top: 40.0,
                        left: 12.0,
                        child: Text(
                          networkAlertMessage,
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Color.fromARGB(255, 198, 116, 28),
                          ),
                        ),
                      ),


                   //only show low severity network alerts
                      if(lowAlerts.contains(networkAlerts[randomIndex2])&&severity == 'LOW')
                      Positioned(
                        top: 40.0,
                        left: 12.0,
                        child: Text(
                          networkAlertMessage,
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Color.fromARGB(245, 245, 196, 6),
                          ),
                        ),
                      ),


                    // Bug Alerts
                    //only show high severity bug alerts
                      if(highAlerts.contains(bugAlerts[randomIndex3])&&severity == 'HIGH')
                      Positioned(
                        top: 40.0,
                        left: 12.0,
                        child: Text(
                          bugAlertMessage,
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Color.fromARGB(255, 187, 34, 34),
                          ),
                        ),
                      ),


                    //only show medium severity bug alerts
                      if(mediumAlerts.contains(bugAlerts[randomIndex3])&&severity == 'MEDIUM')
                      Positioned(
                        top: 40.0,
                        left: 12.0,
                        child: Text(
                          bugAlertMessage,
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Color.fromARGB(255, 198, 116, 28),
                          ),
                        ),
                      ),


                   //only show low severity bug alerts
                      if(lowAlerts.contains(bugAlerts[randomIndex3])&&severity == 'LOW')
                      Positioned(
                        top: 40.0,
                        left: 12.0,
                        child: Text(
                          bugAlertMessage,
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Color.fromARGB(245, 245, 196, 6),
                          ),
                        ),
                      ),
                     
                    // Potential Alert
                    //only show high severity potential alerts
                      if(highAlerts.contains(potentialAlerts[randomIndex4])&&severity == 'HIGH')
                      Positioned(
                        top: 40.0,
                        left: 12.0,
                        child: Text(
                          potentialAlertMessage,
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Color.fromARGB(255, 187, 34, 34),
                          ),
                        ),
                      ),


                    //only show medium severity potential alerts
                      if(mediumAlerts.contains(potentialAlerts[randomIndex4])&&severity == 'MEDIUM')
                      Positioned(
                        top: 40.0,
                        left: 12.0,
                        child: Text(
                          potentialAlertMessage,
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Color.fromARGB(255, 198, 116, 28),
                          ),
                        ),
                      ),


                   //only show low severity potential alerts
                      if(lowAlerts.contains(potentialAlerts[randomIndex4])&&severity == 'LOW')
                      Positioned(
                        top: 40.0,
                        left: 12.0,
                        child: Text(
                          potentialAlertMessage,
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Color.fromARGB(245, 245, 196, 6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
               
              ),
                           
            ],
           
          ),
            ],
          ),
        ),
      ),
    );
  }
}




Widget _buildRoundedContainerWithButton( //builds icons on top of panels
  Color color, String imagePath, Function() onPressed) {
  return Expanded(
    child: Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.all(20.0), // Adjust margin as needed
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(20.0), // Adjust padding as needed
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    ),
  );
}



//Create the screen for the bandit alerts Pannel to show alerts will display on honepage
class Bandit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alert'),
      ),
      body: const Center(
        child: Text(
          'Alert will display on home page for next hour',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}



//Create the screen for the network alerts Pannel to show alerts will display on honepage
class NetworkIssue extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alert'),
      ),
      body: const Center(
        child: Text(
          'Alert will display on home page for next hour',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}



//Create the screen for the bug alerts Pannel to show alerts will display on honepage
class Bug extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alert'),
      ),
      body: const Center(
        child: Text(
          'Alert will display on home page for next hour',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}



//Create the screen for the potential alerts Pannel to show alerts will display on honepage
class PotentialWarnings extends StatelessWidget {
  const PotentialWarnings({super.key});




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alert'),
      ),
      body: const Center(
        child: Text(
          'Alert will display on home page for next hour',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}





