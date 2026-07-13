import 'package:flutter/material.dart';
import '../services/hash_link_service.dart';

/// Wraps a section of content with a hash-linkable ID.
///
/// Registers itself with [HashLinkService] so the section can be
/// scrolled to via URL hash (e.g., `/#skills`).
class HashSection extends StatefulWidget {
  final String id;
  final Widget child;

  const HashSection({
    super.key,
    required this.id,
    required this.child,
  });

  @override
  State<HashSection> createState() => _HashSectionState();
}

class _HashSectionState extends State<HashSection> {
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    HashLinkService.register(widget.id, _key);
  }

  @override
  void dispose() {
    HashLinkService.unregister(widget.id);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(key: _key, child: widget.child);
  }
}