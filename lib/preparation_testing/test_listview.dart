import 'package:delivero/preparation_testing/device_info_service.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ExampleWidget extends StatefulWidget {
  const ExampleWidget({super.key});

  @override
  State<ExampleWidget> createState() => _ExampleWidgetState();
}

class _ExampleWidgetState extends State<ExampleWidget> {
  int? batteryLevel;

  @override
  void initState() {
    super.initState();
    _fetchBatteryLevel();
  }

  Future<void> _fetchBatteryLevel() async {
    final level = await DeviceInfoService.getBatteryLevel();
    setState(() {
      batteryLevel = level;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Parent build called');

    return Scaffold(
      appBar: AppBar(title: const Text('Battery Info Example')),
      body: StreamBuilder<String>(
        stream: DeviceInfoService.batteryStateStream,
        initialData: 'unknown',
        builder: (context, snapshot) {
          final batteryStatus = snapshot.data ?? 'unknown';
          return ListView.builder(
            itemCount: 50,
            itemBuilder: (context, index) {
              return ListItem(
                title: index.toString(),
                subTitle: batteryLevel != null ? '$batteryLevel% ($batteryStatus)' : 'Loading...',
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchBatteryLevel,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class ListItem extends StatefulWidget {
  final String title;
  final String subTitle;

  const ListItem({required this.title, required this.subTitle, super.key});

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  late final Color _color;

  @override
  void initState() {
    super.initState();
    _color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    debugPrint('InitState for item: ${widget.title} with color $_color');
  }

  @override
  void dispose() {
    debugPrint('Item disposed ${widget.title}');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Build for item: ${widget.title} (color $_color)');
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 25, horizontal: 16),
      tileColor: _color,
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25),
        child: Text(widget.title),
      ),
      subtitle: Text(widget.subTitle),
    );
  }
}
