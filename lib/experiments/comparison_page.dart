import 'package:flutter/material.dart';
import 'http_test/http_service.dart';
import 'dio_test/dio_service.dart';
import 'models/performance_result.dart';

class ComparisonPage extends StatefulWidget {
  const ComparisonPage({Key? key}) : super(key: key);

  @override
  State<ComparisonPage> createState() => _ComparisonPageState();
}

class _ComparisonPageState extends State<ComparisonPage> {
  final HttpService _httpService = HttpService();
  final DioService _dioService = DioService();
  
  PerformanceStats? _httpStats;
  PerformanceStats? _dioStats;
  bool _isTestingHttp = false;
  bool _isTestingDio = false;
  int _numberOfTests = 5;

  Future<void> _runHttpTest() async {
    setState(() {
      _isTestingHttp = true;
      _httpStats = null;
    });

    try {
      final stats = await _httpService.runMultipleTests(_numberOfTests);
      setState(() {
        _httpStats = stats;
      });
    } finally {
      setState(() {
        _isTestingHttp = false;
      });
    }
  }

  Future<void> _runDioTest() async {
    setState(() {
      _isTestingDio = true;
      _dioStats = null;
    });

    try {
      final stats = await _dioService.runMultipleTests(_numberOfTests);
      setState(() {
        _dioStats = stats;
      });
    } finally {
      setState(() {
        _isTestingDio = false;
      });
    }
  }

  Future<void> _runBothTests() async {
    await _runHttpTest();
    await Future.delayed(const Duration(seconds: 1));
    await _runDioTest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HTTP vs Dio Performance'),
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTestConfiguration(),
            const SizedBox(height: 20),
            _buildActionButtons(),
            const SizedBox(height: 30),
            if (_httpStats != null || _dioStats != null)
              _buildComparisonTable(),
            const SizedBox(height: 20),
            if (_httpStats != null) _buildDetailedResults('HTTP', _httpStats!),
            const SizedBox(height: 20),
            if (_dioStats != null) _buildDetailedResults('Dio', _dioStats!),
          ],
        ),
      ),
    );
  }

  Widget _buildTestConfiguration() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '⚙️ Test Configuration',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Number of tests: '),
                const Spacer(),
                DropdownButton<int>(
                  value: _numberOfTests,
                  items: [3, 5, 10].map((num) {
                    return DropdownMenuItem(
                      value: num,
                      child: Text('$num tests'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _numberOfTests = value;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Endpoint: /laundryServices/services',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: (_isTestingHttp || _isTestingDio)
              ? null
              : _runBothTests,
          icon: const Icon(Icons.play_arrow),
          label: const Text('Run Both Tests'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 16),
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: (_isTestingHttp || _isTestingDio)
                    ? null
                    : _runHttpTest,
                icon: _isTestingHttp
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.http),
                label: const Text('Test HTTP'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: (_isTestingHttp || _isTestingDio)
                    ? null
                    : _runDioTest,
                icon: _isTestingDio
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.rocket_launch),
                label: const Text('Test Dio'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildComparisonTable() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📊 Performance Comparison',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Table(
              border: TableBorder.all(color: Colors.grey.shade300),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1.5),
                2: FlexColumnWidth(1.5),
              },
              children: [
                _buildTableHeader(),
                _buildTableRow(
                  'Average Time',
                  _httpStats?.averageTimeMs.toStringAsFixed(2) ?? '-',
                  _dioStats?.averageTimeMs.toStringAsFixed(2) ?? '-',
                  'ms',
                ),
                _buildTableRow(
                  'Min Time',
                  _httpStats?.minTimeMs.toString() ?? '-',
                  _dioStats?.minTimeMs.toString() ?? '-',
                  'ms',
                ),
                _buildTableRow(
                  'Max Time',
                  _httpStats?.maxTimeMs.toString() ?? '-',
                  _dioStats?.maxTimeMs.toString() ?? '-',
                  'ms',
                ),
                _buildTableRow(
                  'Success Rate',
                  _httpStats?.successRate.toStringAsFixed(1) ?? '-',
                  _dioStats?.successRate.toStringAsFixed(1) ?? '-',
                  '%',
                ),
                _buildTableRow(
                  'Total Time',
                  _httpStats?.totalTime.inMilliseconds.toString() ?? '-',
                  _dioStats?.totalTime.inMilliseconds.toString() ?? '-',
                  'ms',
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildWinner(),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableHeader() {
    return TableRow(
      decoration: BoxDecoration(color: Colors.grey.shade200),
      children: const [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Metric', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('HTTP', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Dio', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  TableRow _buildTableRow(
      String metric, String httpValue, String dioValue, String unit) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(metric),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('$httpValue $unit'),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('$dioValue $unit'),
        ),
      ],
    );
  }

  Widget _buildWinner() {
    if (_httpStats == null || _dioStats == null) {
      return const SizedBox.shrink();
    }

    final httpAvg = _httpStats!.averageTimeMs;
    final dioAvg = _dioStats!.averageTimeMs;
    final winner = httpAvg < dioAvg ? 'HTTP' : 'Dio';
    final difference = (httpAvg - dioAvg).abs();
    final percentage = (difference / (httpAvg > dioAvg ? httpAvg : dioAvg)) * 100;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.emoji_events, color: Colors.amber, size: 24),
              const SizedBox(width: 8),
              Text(
                'Winner: $winner',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${difference.toStringAsFixed(2)}ms faster (${percentage.toStringAsFixed(1)}%)',
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedResults(String library, PerformanceStats stats) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📝 $library Detailed Results',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...stats.results.map((result) => _buildResultItem(result)),
          ],
        ),
      ),
    );
  }

  Widget _buildResultItem(PerformanceResult result) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            result.isSuccess ? Icons.check_circle : Icons.error,
            color: result.isSuccess ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Test #${result.testNumber}: ${result.responseTimeMs}ms',
              style: const TextStyle(fontSize: 14),
            ),
          ),
          if (!result.isSuccess && result.errorMessage != null)
            Expanded(
              child: Text(
                result.errorMessage!,
                style: const TextStyle(fontSize: 12, color: Colors.red),
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }
}