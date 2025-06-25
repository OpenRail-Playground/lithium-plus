import 'package:rxdart/rxdart.dart';

final Map<String, List<String>> fleetData = {
  'infrastructure': ['Tafag XTas', 'Aem 940'],
  'cargo': ['Tafag XTas', 'Aem 940'],
};

class LayoutViewModel {
  final BehaviorSubject<Set<String>> _expandedSubject = BehaviorSubject.seeded({});
  final BehaviorSubject<String?> _selectedFleetSubject = BehaviorSubject.seeded(null);

  Stream<Set<String>> get expandedStream => _expandedSubject.stream;
  Stream<String?> get selectedFleetStream => _selectedFleetSubject.stream;

  Set<String> get _expanded => _expandedSubject.value;

  void toggleCategory(String category) {
    final updated = Set<String>.from(_expanded);
    if (updated.contains(category)) {
      updated.remove(category);
    } else {
      updated.add(category);
    }
    _expandedSubject.add(updated);
  }

  void expandCategory(String category) {
    final updated = Set<String>.from(_expanded)..add(category);
    _expandedSubject.add(updated);
  }

  void expandFromPath(String? category) {
    if (category != null) {
      expandCategory(category);
    }
  }

  void selectFleet(String fleet) {
    _selectedFleetSubject.add(fleet);
  }

  void dispose() {
    _expandedSubject.close();
    _selectedFleetSubject.close();
  }
}
