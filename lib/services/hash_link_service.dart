import 'package:flutter/material.dart';

/// Reads the current URL hash. On web platforms, this returns the actual hash
/// from the browser URL. On other platforms, it returns an empty string.
String get locationHash {
  try {
    // ignore: prefer_initializing_formals
    return Uri.base.fragment;
  } catch (_) {
    return '';
  }
}

/// Service for hash-based section navigation (e.g. /#skills, /#kontakt).
class HashLinkService {
  static final Map<String, GlobalKey> _sectionKeys = {};

  /// Register a section with a GlobalKey for scroll targeting
  static void register(String id, GlobalKey key) {
    _sectionKeys[id] = key;
  }

  /// Unregister a section
  static void unregister(String id) {
    _sectionKeys.remove(id);
  }

  /// Smooth-scroll to the section with the given hash ID
  static void scrollTo(String id) {
    final key = _sectionKeys[id];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.1,
      );
    }
  }

  /// Read current hash from the URL fragment
  static String get currentHash => locationHash;

  /// On initial page load, scroll to the section specified in the hash
  static void handleInitialHash() {
    final hash = currentHash;
    if (hash.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 500), () {
        scrollTo(hash);
      });
    }
  }
}