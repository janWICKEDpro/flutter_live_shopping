import 'dart:async';
import 'package:flutter_live_shopping/models/chat_message.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_live_shopping/providers/live_event_provider.dart';
import 'package:flutter_live_shopping/services/api_service.dart';
import 'package:flutter_live_shopping/services/socket_service.dart';

// Mock SocketService
class MockSocketService extends SocketService {
  final _chatController = StreamController<ChatMessage>.broadcast();
  final _viewerCountController = StreamController<int>.broadcast();
  final _productFeaturedController = StreamController<String>.broadcast();

  final List<String> sentMessages = [];

  @override
  Stream<ChatMessage> get chatMessages => _chatController.stream;
  @override
  Stream<int> get viewerCount => _viewerCountController.stream;
  @override
  Stream<String> get productFeatured => _productFeaturedController.stream;

  @override
  void joinLiveEvent(String eventId) {
    // No-op for test
  }

  @override
  void sendChatMessage(String message) {
    sentMessages.add(message);
  }

  void emitMessage(ChatMessage msg) {
    _chatController.add(msg);
  }

  void emitViewerCount(int count) {
    _viewerCountController.add(count);
  }
}

void main() {
  group('LiveEventProvider Tests', () {
    late LiveEventProvider provider;
    late MockApiService apiService;
    late MockSocketService socketService;

    setUp(() {
      apiService = MockApiService();
      socketService = MockSocketService();
      provider = LiveEventProvider(apiService, socketService);
    });

    test('joinEvent subscribes to streams and clears previous state', () async {
      provider.joinEvent('evt_1');

      expect(provider.messages, isEmpty);
      expect(provider.currentViewerCount, 0);

      // Simulate incoming viewer count
      socketService.emitViewerCount(100);
      await Future.delayed(Duration.zero);
      expect(provider.currentViewerCount, 100);
    });

    test('Incoming chat message updates messages list', () async {
      provider.joinEvent('evt_1');

      final msg = ChatMessage(
        id: '1',
        senderId: 'u1',
        senderName: 'User',
        message: 'Hello',
        timestamp: DateTime.now(),
      );

      socketService.emitMessage(msg);
      await Future.delayed(Duration.zero);

      expect(provider.messages.length, 1);
      expect(provider.messages.first.message, 'Hello');
    });

    test('sendMessage calls socket service', () {
      provider.sendMessage('Test Message');
      expect(socketService.sentMessages, contains('Test Message'));
    });
  });
}
