import 'package:flutter/material.dart';
import 'package:flutter_live_shopping/services/api_service.dart';
import 'package:flutter_live_shopping/services/socket_service.dart';

class LiveEventProvider extends ChangeNotifier {
  final ApiService _apiService;
  final SocketService _socketService;

  LiveEventProvider(this._apiService, this._socketService);
}
