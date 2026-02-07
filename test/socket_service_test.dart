import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_live_shopping/services/socket_service.dart';

void main() {
  late SocketService socketService;

  setUp(() {
    socketService = SocketService();
  });

  tearDown(() {
    socketService.dispose();
  });

  test('joinLiveEvent starts emitting viewer counts', () async {
    socketService.joinLiveEvent('evt_1');

    // Convert stream to future to get the first event
    // We expect an event after a short delay
    final firstCount = await socketService.viewerCount.first;
    expect(firstCount, greaterThanOrEqualTo(200));
  });

  test('sendChatMessage emits message to stream', () async {
    const messageText = 'Hello World';

    // Listen for the message
    final futureMessage = socketService.chatMessages.first;

    socketService.sendChatMessage(messageText);

    final message = await futureMessage;
    expect(message.message, equals(messageText));
    expect(message.senderName, equals('You'));
  });

  test('simulateProductFeature emits product id', () async {
    const productId = 'prod_123';

    final futureId = socketService.productFeatured.first;

    socketService.simulateProductFeature(productId);

    final id = await futureId;
    expect(id, equals(productId));
  });
}
