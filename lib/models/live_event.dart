import 'package:json_annotation/json_annotation.dart';
import 'product.dart';

part 'live_event.g.dart';

enum LiveEventStatus { scheduled, live, ended }

@JsonSerializable()
class Seller {
  final String id;
  final String name;
  final String storeName;
  final String avatar;

  Seller({
    required this.id,
    required this.name,
    required this.storeName,
    required this.avatar,
  });

  factory Seller.fromJson(Map<String, dynamic> json) => _$SellerFromJson(json);
  Map<String, dynamic> toJson() => _$SellerToJson(this);
}

@JsonSerializable()
class LiveEvent {
  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime? endTime;
  final LiveEventStatus status;
  final Seller seller;
  final List<Product>? products; // Can be null if loaded separately or IDs
  final Product? featuredProduct;
  final int viewerCount;
  final String? streamUrl;
  final String? replayUrl;
  final String thumbnailUrl;

  LiveEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    this.endTime,
    required this.status,
    required this.seller,
    this.products,
    this.featuredProduct,
    this.viewerCount = 0,
    this.streamUrl,
    this.replayUrl,
    required this.thumbnailUrl,
  }) : assert(
         endTime == null || endTime.isAfter(startTime),
         'End time must be after start time',
       );

  factory LiveEvent.fromJson(Map<String, dynamic> json) =>
      _$LiveEventFromJson(json);
  Map<String, dynamic> toJson() => _$LiveEventToJson(this);

  factory LiveEvent.mock() {
    return LiveEvent(
      id: 'evt_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Mock Event',
      description: 'This is a mock event description.',
      startTime: DateTime.now(),
      endTime: DateTime.now().add(const Duration(hours: 2)),
      status: LiveEventStatus.live,
      seller: Seller(
        id: 'seller_1',
        name: 'Mock Seller',
        storeName: 'Mock Store',
        avatar: 'https://i.pravatar.cc/150?img=1',
      ),
      thumbnailUrl: 'https://picsum.photos/200/300',
      viewerCount: 100,
    );
  }

  LiveEvent copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    LiveEventStatus? status,
    Seller? seller,
    List<Product>? products,
    Product? featuredProduct,
    int? viewerCount,
    String? streamUrl,
    String? replayUrl,
    String? thumbnailUrl,
  }) {
    return LiveEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      seller: seller ?? this.seller,
      products: products ?? this.products,
      featuredProduct: featuredProduct ?? this.featuredProduct,
      viewerCount: viewerCount ?? this.viewerCount,
      streamUrl: streamUrl ?? this.streamUrl,
      replayUrl: replayUrl ?? this.replayUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    );
  }
}
