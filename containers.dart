import 'package:flutter/material.dart';
//This makes the table of containers for our Container Status category
class ContainerStatus extends StatefulWidget {
  const ContainerStatus({super.key});

  @override
  _ContainerStatusState createState() => _ContainerStatusState();
}

class _ContainerStatusState extends State<ContainerStatus> {
  // You can manage the container status in a state variable
  Map<String, String> containerStatus = {
    'Zeek': 'Active/Running',
    'MongoDB': 'Active/Running',
  };

  bool isLoading = false;
  late String lastButtonPressTimestamp;

  @override
  void initState() {
    super.initState();
    lastButtonPressTimestamp = ''; // Initialize the timestamp
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Container Status'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Implement your refresh logic here
              // This function will be called when the refresh icon is pressed
              // You can refresh the data or reload the table contents
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              Table(
                border: TableBorder.all(color: Colors.grey),
                columnWidths: const {
                  0: FlexColumnWidth(3),
                  1: FlexColumnWidth(2),
                },
                children: [
                  const TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Container',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Text(
                                'Status',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Zeek',
                            style:TextStyle(fontSize: 22,)
                            ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Text(
                                containerStatus['Zeek'] ?? '',
                                 style: TextStyle(
                                fontSize: 22, // Adjust the font size here
                               ),
                              ),
                              const SizedBox(width: 5),
                              Icon(
                                Icons.circle,
                                color: containerStatus['Zeek'] == 'Active/Running'
                                    ? Colors.green
                                    : Colors.red,
                                size: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'MongoDB',
                            style:TextStyle(fontSize: 22,)
                            ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Text(containerStatus['MongoDB'] ?? '', 
                              style: TextStyle(
                                fontSize: 22, // Adjust the font size here
                               ),),
                              const SizedBox(width: 5),
                              Icon(
                                Icons.circle,
                                color: containerStatus['MongoDB'] == 'Active/Running'
                                    ? Colors.green
                                    : Colors.red,
                                size: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 15),
              // Add a button to stop the container
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    const SizedBox(height: 15),
    Row(
      children: [
        // Add a button to stop the container
        ElevatedButton(
          onPressed: () async {
            setState(() {
              isLoading = true;
              lastButtonPressTimestamp = DateTime.now().toString();
            });

            // Simulate an asynchronous operation (you can replace it with your logic)
            await Future.delayed(const Duration(seconds: 6));

            setState(() {
              // Update the container status to "Stopped" when the button is pressed
              containerStatus.updateAll((key, value) => 'Restarting');
              isLoading = false;
            });
          },
          child: const Text(
            'Restart Containers',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Color.fromARGB(108, 11, 142, 154)),
            fixedSize: MaterialStateProperty.all(Size(200, 50)),
          ),
        ),
        const SizedBox(width: 10), // Add some space between buttons
        Text('Last Time Containers Restarted: $lastButtonPressTimestamp'),
      ],
    ),
    const SizedBox(height: 10),
    // Add a button to refresh the container status back to "Active/Running"
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: () async {
            setState(() {
              isLoading = true;
            });

            // Simulate an asynchronous operation (you can replace it with your logic)
            await Future.delayed(const Duration(seconds: 5));

            setState(() {
              // Update the container status to "Active/Running" when the button is pressed
              containerStatus.updateAll((key, value) => 'Active/Running');
              isLoading = false;
            });
          },
          child: const Text(
            'Refresh',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Color.fromARGB(108, 11, 142, 154)),
            fixedSize: MaterialStateProperty.all(Size(200, 50)),
          ),
        ),
        // Show loading indicator if isLoading is true
        if (isLoading)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
      ],
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
