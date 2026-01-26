import 'package:flutter/material.dart';

class PartyScreen extends StatelessWidget {
  const PartyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('파티')),
      body: const Center(child: Text('파티 화면 준비 중입니다.')),
    );
  }
}
