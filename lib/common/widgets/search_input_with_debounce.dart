import 'dart:async';

import 'package:flutter/material.dart';

class SearchInputWithDebounce extends StatefulWidget {
  const SearchInputWithDebounce({
    required this.onChanged,
    required this.hintText,
    super.key,
  });

  final void Function(String) onChanged;
  final String hintText;

  @override
  State<SearchInputWithDebounce> createState() =>
      _SearchInputWithDebounceState();
}

class _SearchInputWithDebounceState extends State<SearchInputWithDebounce> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  String _query = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() => _query = value);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onChanged(_query);
    });
  }

  void _clear() {
    setState(() {
      _query = '';
      _controller.clear();
    });
    _debounce?.cancel();
    widget.onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: _onChanged,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: widget.hintText,
        suffixIcon: _query.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.clear),
                onPressed: _clear,
              ),
      ),
    );
  }
}
