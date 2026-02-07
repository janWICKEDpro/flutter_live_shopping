import 'dart:async';
import 'dart:math';
import 'package:flutter_live_shopping/models/chat_message.dart';

class SocketService {
  final _chatController = StreamController<ChatMessage>.broadcast();
  final _viewerCountController = StreamController<int>.broadcast();
  final _productFeaturedController = StreamController<String>.broadcast();

  Timer? _viewerCountTimer;

  Stream<ChatMessage> get chatMessages => _chatController.stream;
  Stream<int> get viewerCount => _viewerCountController.stream;
  Stream<String> get productFeatured => _productFeaturedController.stream;

  void joinLiveEvent(String eventId) {
    // Simulate connection lag
    Future.delayed(const Duration(milliseconds: 500), () {
      // Start emitting viewer counts
      _viewerCountTimer?.cancel();
      _viewerCountTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
        // Random viewer count between 200 and 250
        (timer.isActive)
            ? _viewerCountController.add(200 + Random().nextInt(50))
            : null;
      });
    });
  }

  void leaveLiveEvent(String eventId) {
    _viewerCountTimer?.cancel();
  }

  void sendChatMessage(String message) {
    // Simulate network delay
    Future.delayed(const Duration(milliseconds: 300), () {
      final chatMessage = ChatMessage(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        senderId: 'current_user',
        senderName: 'You',
        message: message,
        timestamp: DateTime.now(),
      );
      _chatController.add(chatMessage);
    });
  }

  // Helper for testing or simulation
  void simulateIncomingMessage(ChatMessage message) {
    _chatController.add(message);
  }

  void simulateProductFeature(String productId) {
    _productFeaturedController.add(productId);
  }

  void dispose() {
    _chatController.close();
    _viewerCountController.close();
    _productFeaturedController.close();
    _viewerCountTimer?.cancel();
  }
}
