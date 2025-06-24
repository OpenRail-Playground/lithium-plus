import 'package:rxdart/rxdart.dart';

final Map<String, List<String>> fleetData = {
  'infrastructure': ['XTas', 'Aem 940'],
  'cargo': ['XTas', 'Aem 940'],
};

class LayoutViewModel {
  final BehaviorSubject<Set<String>> _expandedSubject = BehaviorSubject.seeded({});

  Stream<Set<String>> get expandedStream => _expandedSubject.stream;
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

  void dispose() {
    _expandedSubject.close();
  }
}
