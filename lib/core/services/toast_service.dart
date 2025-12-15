import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:bible_app/core/router/navigation.dart';
import 'package:toastification/toastification.dart';

/// Lightweight, in-app, ephemeral toast/snackbar service with queuing.
///
/// Usage:
///   ToastService.instance.success('Download complete');
///   ToastService.instance.error('Something went wrong');
///   ToastService.instance.enqueueAll([
///     Toast('One'),
///     Toast('Two'),
///   ]);
class ToastService {
  ToastService._();
  static final ToastService instance = ToastService._();

  final Queue<Toast> _queue = Queue<Toast>();
  bool _isShowing = false;

  /// Enqueue a single toast.
  void show(Toast toast) {
    _queue.add(toast);
    _processQueue();
  }

  /// Convenience: show info toast.
  void info(String message, {String? title}) =>
      show(Toast(message, title: title));

  /// Convenience: show success toast.
  void success(String message, {String? title}) =>
      show(Toast(message, title: title, type: ToastType.success));

  /// Convenience: show warning toast.
  void warning(String message, {String? title}) =>
      show(Toast(message, title: title, type: ToastType.warning));

  /// Convenience: show error toast.
  void error(String message, {String? title}) =>
      show(Toast(message, title: title, type: ToastType.error));

  /// Enqueue many toasts at once.
  void enqueueAll(Iterable<Toast> toasts) {
    _queue.addAll(toasts);
    _processQueue();
  }

  /// Add a toast to the queue without needing to call [show].
  /// Set [autoStart] to false if you don't want processing to start immediately
  void addToQueue(Toast toast, {bool autoStart = true}) {
    _queue.add(toast);
    if (autoStart) _processQueue();
  }

  /// Add multiple toasts to the queue.
  void addAllToQueue(Iterable<Toast> toasts, {bool autoStart = true}) {
    _queue.addAll(toasts);
    if (autoStart) _processQueue();
  }

  /// Prioritize a toast by adding it to the front of the queue.
  void addToFront(Toast toast, {bool autoStart = true}) {
    _queue.addFirst(toast);
    if (autoStart) _processQueue();
  }

  /// Add multiple prioritized toasts to the front of the queue (in given order)
  void addAllToFront(Iterable<Toast> toasts, {bool autoStart = true}) {
    for (final t in toasts.toList().reversed) {
      _queue.addFirst(t);
    }
    if (autoStart) _processQueue();
  }

  /// Clear all pending toasts (does not dismiss the currently visible one).
  void clearQueue() => _queue.clear();

  /// Read-only view of pending toasts.
  List<Toast> get pending => List.unmodifiable(_queue);

  /// Count of pending toasts.
  int get pendingCount => _queue.length;

  Future<void> _processQueue() async {
    if (_isShowing) return;
    _isShowing = true;

    while (_queue.isNotEmpty) {
      final toast = _queue.removeFirst();
      await _showSnackBar(toast);
      // Small spacing between toasts
      await Future<void>.delayed(const Duration(seconds: 1));
    }

    _isShowing = false;
  }

  Future<void> _showSnackBar(Toast toast) async {
    final context = AppNavigation.instance.routerKey.currentContext;
    if (context == null) return;

    final type = _mapType(toast.type);

    toastification.show(
      context: context,
      type: type,
      showProgressBar: true,
      autoCloseDuration: toast.duration,
      alignment: Alignment.topRight,
      style: ToastificationStyle.fillColored,
      title: toast.title != null && toast.title!.isNotEmpty
          ? Text(toast.title!)
          : null,
      description: Text(toast.message),
      // Ensure newer toasts stack beneath older ones
      animationDuration: const Duration(milliseconds: 250),
      applyBlurEffect: false,
    );

    // Wait approximately until the toast auto-closes before proceeding.
    // toastification.show returns a ToastificationItem without a Future getter.
    // We simulate awaiting close by delaying for the autoCloseDuration
    // plus a small buffer for animation.
    await Future<void>.delayed(
      toast.duration + const Duration(milliseconds: 150),
    );
  }

  ToastificationType _mapType(ToastType type) {
    switch (type) {
      case ToastType.success:
        return ToastificationType.success;
      case ToastType.warning:
        return ToastificationType.warning;
      case ToastType.error:
        return ToastificationType.error;
      case ToastType.info:
        return ToastificationType.info;
    }
  }
}

enum ToastType { info, success, warning, error }

class Toast {
  Toast(
    this.message, {
    this.title,
    this.type = ToastType.info,
    this.duration = const Duration(milliseconds: 2200),
  });

  final String message;
  final String? title;
  final ToastType type;
  final Duration duration;
}
