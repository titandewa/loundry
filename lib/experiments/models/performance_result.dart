class PerformanceResult {
  final int testNumber;
  final Duration responseTime;
  final bool isSuccess;
  final String? errorMessage;
  final int dataSize;

  PerformanceResult({
    required this.testNumber,
    required this.responseTime,
    required this.isSuccess,
    this.errorMessage,
    required this.dataSize,
  });

  int get responseTimeMs => responseTime.inMilliseconds;
}

class PerformanceStats {
  final String libraryName;
  final List<PerformanceResult> results;
  final Duration totalTime;
  final int successCount;
  final int failureCount;

  PerformanceStats({
    required this.libraryName,
    required this.results,
    required this.totalTime,
    required this.successCount,
    required this.failureCount,
  });

  double get averageTimeMs {
    if (results.isEmpty) return 0;
    final total = results.fold<int>(
      0,
      (sum, result) => sum + result.responseTimeMs,
    );
    return total / results.length;
  }

  int get minTimeMs {
    if (results.isEmpty) return 0;
    return results
        .map((r) => r.responseTimeMs)
        .reduce((a, b) => a < b ? a : b);
  }

  int get maxTimeMs {
    if (results.isEmpty) return 0;
    return results
        .map((r) => r.responseTimeMs)
        .reduce((a, b) => a > b ? a : b);
  }

  double get successRate {
    if (results.isEmpty) return 0;
    return (successCount / results.length) * 100;
  }
}