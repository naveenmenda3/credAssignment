import 'package:flutter/scheduler.dart';

/// Tracks frame drops and performance metrics
class FrameDropTracker {
  final List<Duration> _frameTimes = [];
  final Duration _targetFrameTime = const Duration(milliseconds: 16);
  int _droppedFrames = 0;
  bool _isTracking = false;

  /// Start tracking frame performance
  void startTracking() {
    if (_isTracking) return;
    _isTracking = true;
    _frameTimes.clear();
    _droppedFrames = 0;

    SchedulerBinding.instance.addTimingsCallback(_onFrameTimings);
  }

  /// Stop tracking frame performance
  void stopTracking() {
    if (!_isTracking) return;
    _isTracking = false;
    SchedulerBinding.instance.removeTimingsCallback(_onFrameTimings);
  }

  /// Callback for frame timings
  void _onFrameTimings(List<FrameTiming> timings) {
    for (final timing in timings) {
      final frameDuration = timing.totalSpan;
      _frameTimes.add(frameDuration);

      // Check if frame exceeded 16ms (60fps threshold)
      if (frameDuration > _targetFrameTime) {
        _droppedFrames++;
      }
    }
  }

  /// Get total number of dropped frames
  int get droppedFrames => _droppedFrames;

  /// Get total number of tracked frames
  int get totalFrames => _frameTimes.length;

  /// Get percentage of dropped frames
  double get dropRate {
    if (_frameTimes.isEmpty) return 0.0;
    return (_droppedFrames / _frameTimes.length) * 100;
  }

  /// Get average frame time
  Duration get averageFrameTime {
    if (_frameTimes.isEmpty) return Duration.zero;
    final total = _frameTimes.fold<int>(
      0,
      (sum, duration) => sum + duration.inMicroseconds,
    );
    return Duration(microseconds: total ~/ _frameTimes.length);
  }

  /// Get frames that exceeded the target time
  List<Duration> get slowFrames {
    return _frameTimes.where((d) => d > _targetFrameTime).toList();
  }

  /// Reset all metrics
  void reset() {
    _frameTimes.clear();
    _droppedFrames = 0;
  }

  /// Get performance report
  Map<String, dynamic> getReport() {
    return {
      'totalFrames': totalFrames,
      'droppedFrames': droppedFrames,
      'dropRate': '${dropRate.toStringAsFixed(2)}%',
      'averageFrameTime': '${averageFrameTime.inMilliseconds}ms',
      'slowFramesCount': slowFrames.length,
    };
  }
}
