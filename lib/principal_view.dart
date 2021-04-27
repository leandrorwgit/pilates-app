import 'package:app_pilates/components/app_drawer.dart';
import 'package:flutter/material.dart';

class PrincipalView extends StatefulWidget {
  @override
  _PrincipalView createState() => _PrincipalView();
}

class _PrincipalView extends State<PrincipalView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BALANCE Pilates'),
      ),
      drawer: AppDrawer(),
      body: Center(child: Image.asset('assets/images/logo-balance.png')),
    );
  }
}
