import 'package:flutter/material.dart';

class LiveEventScreen extends StatelessWidget {
  final String id;
  const LiveEventScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Event')),
      body: Center(child: Text('Live Event: $id')),
    );
  }
}
