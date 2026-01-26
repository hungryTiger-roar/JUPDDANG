import 'package:flutter/material.dart';

class TeamScreen extends StatelessWidget {
  const TeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('팀/친구')),
      body: const Center(
        child: Text('팀/친구 화면 준비 중입니다.', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
