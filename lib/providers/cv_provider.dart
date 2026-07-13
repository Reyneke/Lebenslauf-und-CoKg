import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../models/cv_data.dart';

class CvProvider extends ChangeNotifier {
  CvData? _cvData;
  bool _isLoading = false;
  String? _error;

  CvData? get cvData => _cvData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCvData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final jsonString = await rootBundle.loadString('data/cv.json');
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      _cvData = CvData.fromJson(jsonMap);
    } catch (e) {
      _error = 'Fehler beim Laden der CV-Daten: $e';
      debugPrint(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}