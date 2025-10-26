import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/laundry_services.dart';
import '../models/performance_result.dart';

class HttpService {
  static const String baseUrl =
      'https://68fda02f7c700772bb1189af.mockapi.io/api/v1/laundryServices/services';

  Future<PerformanceResult> fetchServicesWithTiming(int testNumber) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      print('📤 [HTTP] Test #$testNumber - Sending request...');
      
      final response = await http.get(Uri.parse(baseUrl));
      
      stopwatch.stop();
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final services = jsonData.map((json) => LaundryService.fromJson(json)).toList();
        
        print('✅ [HTTP] Test #$testNumber - Success in ${stopwatch.elapsedMilliseconds}ms');
        print('📦 [HTTP] Data received: ${services.length} services');
        print('📊 [HTTP] Data size: ${response.bodyBytes.length} bytes');
        
        return PerformanceResult(
          testNumber: testNumber,
          responseTime: stopwatch.elapsed,
          isSuccess: true,
          dataSize: response.bodyBytes.length,
        );
      } else {
        print('❌ [HTTP] Test #$testNumber - Failed with status ${response.statusCode}');
        
        return PerformanceResult(
          testNumber: testNumber,
          responseTime: stopwatch.elapsed,
          isSuccess: false,
          errorMessage: 'HTTP ${response.statusCode}',
          dataSize: 0,
        );
      }
    } catch (e) {
      stopwatch.stop();
      print('❌ [HTTP] Test #$testNumber - Error: $e');
      
      return PerformanceResult(
        testNumber: testNumber,
        responseTime: stopwatch.elapsed,
        isSuccess: false,
        errorMessage: e.toString(),
        dataSize: 0,
      );
    }
  }

  Future<PerformanceStats> runMultipleTests(int numberOfTests) async {
    print('\n🚀 Starting HTTP Performance Test ($numberOfTests tests)\n');
    
    final List<PerformanceResult> results = [];
    final overallStopwatch = Stopwatch()..start();
    
    for (int i = 1; i <= numberOfTests; i++) {
      final result = await fetchServicesWithTiming(i);
      results.add(result);
      
      // Small delay between tests
      if (i < numberOfTests) {
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
    
    overallStopwatch.stop();
    
    final successCount = results.where((r) => r.isSuccess).length;
    final failureCount = results.length - successCount;
    
    print('\n📊 [HTTP] Test Summary:');
    print('   Total Tests: ${results.length}');
    print('   Success: $successCount');
    print('   Failures: $failureCount');
    print('   Total Time: ${overallStopwatch.elapsed.inMilliseconds}ms\n');
    
    return PerformanceStats(
      libraryName: 'HTTP Package',
      results: results,
      totalTime: overallStopwatch.elapsed,
      successCount: successCount,
      failureCount: failureCount,
    );
  }
}