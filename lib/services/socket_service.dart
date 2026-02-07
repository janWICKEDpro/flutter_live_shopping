import 'dart:async';
import 'package:flutter_live_shopping/models/chat_message.dart';

class SocketService {
  // Placeholder for SocketService implementation
  final _chatController = StreamController<ChatMessage>.broadcast();
  Stream<ChatMessage> get chatMessages => _chatController.stream;

  void joinLiveEvent(String eventId) {}
  void leaveLiveEvent(String eventId) {}
}
