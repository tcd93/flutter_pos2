import 'package:flutter/material.dart';

@immutable
class ConnectionData {
  final String ip;
  final String pass;

  const ConnectionData(this.ip, this.pass);
}
