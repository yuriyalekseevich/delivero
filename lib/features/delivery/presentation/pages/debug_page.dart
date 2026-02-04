import 'package:delivero/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/storage/debug_storage.dart';

class DebugPage extends StatefulWidget {
  const DebugPage({super.key});

  @override
  State<DebugPage> createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  late DebugStorage _debugStorage;
  List<Map> _logs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _debugStorage = getIt<DebugStorage>();
    _loadLogs();
  }

  void _loadLogs() async {
    setState(() {
      _isLoading = true;
    });

    final logs = _debugStorage.getAllLogs();
    setState(() {
      _logs = logs;
      _isLoading = false;
    });
  }

  void _clearLogs() {
    _debugStorage.clearLogs();
    _loadLogs();
  }

  void _sendTestNotification() {
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Test notification sent')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).debugScreen),
        actions: [
          IconButton(
            onPressed: _loadLogs,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildActionButtons(),
          Expanded(
            child: _isLoading ? const Center(child: CircularProgressIndicator()) : _buildLogsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _clearLogs,
              icon: const Icon(Icons.clear_all),
              label: Text(S.of(context).clearLogs),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _sendTestNotification,
              icon: const Icon(Icons.notifications),
              label: Text(S.of(context).sendNotification),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogsList() {
    if (_logs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bug_report,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No logs available',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _logs.length,
      itemBuilder: (context, index) {
        final log = _logs[index];
        return _buildLogItem(log);
      },
    );
  }

  Widget _buildLogItem(Map log) {
    final type = log['type'] as String;
    final timestamp = log['timestamp'] as String;
    final url = log['url'] as String?;

    IconData icon;

    switch (type) {
      case 'request':
        icon = Icons.arrow_upward;
        break;
      case 'response':
        icon = Icons.arrow_downward;
        break;
      case 'error':
        icon = Icons.error;
        break;
      default:
        icon = Icons.info;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: _getTypeColor(type)),
        title: Text(
          type.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Time: $timestamp'),
            if (url != null) Text('URL: $url'),
            if (log['statusCode'] != null) Text('Status: ${log['statusCode']}'),
          ],
        ),
        trailing: IconButton(
          onPressed: () => _copyLogToClipboard(log),
          icon: const Icon(Icons.copy),
        ),
        onTap: () => _showLogDetails(log),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'request':
        return Colors.blue;
      case 'response':
        return Colors.green;
      case 'error':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _copyLogToClipboard(Map log) {
    final logText = log.toString();
    Clipboard.setData(ClipboardData(text: logText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Log copied to clipboard')),
    );
  }

  void _showLogDetails(Map log) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${log['type']?.toString().toUpperCase()} Details'),
        content: SingleChildScrollView(
          child: Text(
            log.toString(),
            style: const TextStyle(fontFamily: 'monospace'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
