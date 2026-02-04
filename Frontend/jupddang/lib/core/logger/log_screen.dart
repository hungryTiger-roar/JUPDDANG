import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'log_service.dart';

class LogScreen extends StatelessWidget {
  const LogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('In-App Logs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              final allLogs = LogService().logsNotifier.value.join('\n');
              Clipboard.setData(ClipboardData(text: allLogs));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All logs copied to clipboard')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              LogService().clear();
            },
          ),
        ],
      ),
      body: ValueListenableBuilder<List<String>>(
        valueListenable: LogService().logsNotifier,
        builder: (context, logs, child) {
          if (logs.isEmpty) {
            return const Center(child: Text('No logs yet.'));
          }
          return ListView.builder(
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];
              Color textColor = Colors.black;
              if (log.contains('Error') || log.contains('❌') || log.contains('Exception')) {
                textColor = Colors.red;
              } else if (log.contains('Warning') || log.contains('⚠️')) {
                textColor = Colors.orange;
              } else if (log.contains('Success') || log.contains('✅')) {
                textColor = Colors.green;
              }

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
                ),
                child: SelectableText(
                  log,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Courier',
                    color: textColor,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
