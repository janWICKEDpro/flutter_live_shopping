import 'package:flutter/material.dart';
import 'package:flutter_live_shopping/models/live_event.dart';
import 'package:flutter_live_shopping/services/api_service.dart';
import 'package:flutter_live_shopping/services/socket_service.dart';

class LiveEventProvider extends ChangeNotifier {
  final MockApiService _apiService;
  final SocketService _socketService;

  bool _isLoading = false;
  String? _error;
  List<LiveEvent> _events = [];
  List<LiveEvent> _filteredEvents = [];

  // Filters
  String _searchQuery = '';
  LiveEventStatus? _statusFilter;
  String? _categoryFilter;

  LiveEventProvider(this._apiService, this._socketService) {
    _socketService.viewerCount.listen((count) {
      // In a real app, match event ID. For mock, just update current live events
      // heavily simplified for this exercise
      if (_filteredEvents.isNotEmpty) {
        // notifyListeners(); // trigger update
      }
    });
  }

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<LiveEvent> get events => _filteredEvents;

  // Getters for specific sections
  List<LiveEvent> get liveEvents =>
      _filteredEvents.where((e) => e.status == LiveEventStatus.live).toList();

  List<LiveEvent> get upcomingEvents => _filteredEvents
      .where((e) => e.status == LiveEventStatus.scheduled)
      .toList();

  List<LiveEvent> get pastEvents =>
      _filteredEvents.where((e) => e.status == LiveEventStatus.ended).toList();

  Future<void> loadEvents() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _events = await _apiService.getLiveEvents();
      _applyFilters();
    } catch (e) {
      _error = 'Failed to load events: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void setStatusFilter(LiveEventStatus? status) {
    _statusFilter = status;
    _applyFilters();
    notifyListeners();
  }

  void setCategoryFilter(String? category) {
    _categoryFilter = category;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredEvents = _events.where((event) {
      final matchesSearch =
          event.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          event.description.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          event.seller.storeName.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );

      final matchesStatus =
          _statusFilter == null || event.status == _statusFilter;

      bool matchesCategory = true;
      if (_categoryFilter != null && _categoryFilter != 'All') {
        // Safe check for products being null or empty
        final hasMatchingProduct =
            event.products?.any((p) => p.category == _categoryFilter) ?? false;
        matchesCategory = hasMatchingProduct;
      }

      return matchesSearch && matchesStatus && matchesCategory;
    }).toList();
  }
}
