import 'dart:io';

List<List<String>> parseLogFile(String filePath) {
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
      List<String> fields = line.split('\t'); // assuming '\t' is the field separator

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

void main() {
  // Example usage
  String filePath = 'zat/data/dns.log';
  List<List<String>> logs = parseLogFile(filePath);

  // Check if there is at least one line in the logs
  if (logs.isNotEmpty) {
    // Print all log lines
    for (List<String> logLine in logs) {
      print(logLine);
      print("\n");
    }
  } else {
    print("No lines in the log array");
  }
}
