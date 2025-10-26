import 'package:dio/dio.dart';
import '../models/laundry_services.dart';
import '../models/performance_result.dart';

class DioService {
  static const String baseUrl =
      'https://68fda02f7c700772bb1189af.mockapi.io/api/v1/laundryServices/services';
  
  late final Dio _dio;

  DioService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));
    
    // Add interceptor for logging
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print('🔵 [Dio] $obj'),
    ));
  }

  Future<PerformanceResult> fetchServicesWithTiming(int testNumber) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      print('📤 [Dio] Test #$testNumber - Sending request...');
      
      final response = await _dio.get('');
      
      stopwatch.stop();
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = response.data;
        final services = jsonData.map((json) => LaundryService.fromJson(json)).toList();
        
        print('✅ [Dio] Test #$testNumber - Success in ${stopwatch.elapsedMilliseconds}ms');
        print('📦 [Dio] Data received: ${services.length} services');
        
        // Calculate data size from response
        final dataSize = response.toString().length;
        print('📊 [Dio] Data size: $dataSize bytes');
        
        return PerformanceResult(
          testNumber: testNumber,
          responseTime: stopwatch.elapsed,
          isSuccess: true,
          dataSize: dataSize,
        );
      } else {
        print('❌ [Dio] Test #$testNumber - Failed with status ${response.statusCode}');
        
        return PerformanceResult(
          testNumber: testNumber,
          responseTime: stopwatch.elapsed,
          isSuccess: false,
          errorMessage: 'HTTP ${response.statusCode}',
          dataSize: 0,
        );
      }
    } on DioException catch (e) {
      stopwatch.stop();
      print('❌ [Dio] Test #$testNumber - DioError: ${e.type} - ${e.message}');
      
      return PerformanceResult(
        testNumber: testNumber,
        responseTime: stopwatch.elapsed,
        isSuccess: false,
        errorMessage: '${e.type}: ${e.message}',
        dataSize: 0,
      );
    } catch (e) {
      stopwatch.stop();
      print('❌ [Dio] Test #$testNumber - Error: $e');
      
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
    print('\n🚀 Starting Dio Performance Test ($numberOfTests tests)\n');
    
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
    
    print('\n📊 [Dio] Test Summary:');
    print('   Total Tests: ${results.length}');
    print('   Success: $successCount');
    print('   Failures: $failureCount');
    print('   Total Time: ${overallStopwatch.elapsed.inMilliseconds}ms\n');
    
    return PerformanceStats(
      libraryName: 'Dio Package',
      results: results,
      totalTime: overallStopwatch.elapsed,
      successCount: successCount,
      failureCount: failureCount,
    );
  }
}