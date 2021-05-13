import 'package:flutter/material.dart';

class Componentes {
  static erroRest(snapshot) {
    return Center(
      child: Column(
        children: <Widget>[
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          Text('Error: ${snapshot.error}'),
        ],
      ),
    );
  }
}
