import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:seller_information_v2/base_url.dart';
import '../models/chart_data_model.dart';
import 'package:logging/logging.dart';

class ChartApiService {
  final _logger = Logger('/ApplicationContentApi/ChartData');

  ChartApiService() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      // ignore: avoid_print
      print('${record.level.name}: ${record.time}: ${record.message}');
    });
  }

  Future<ChartResponse> fetchChartData() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/ApplicationContentApi/ChartData'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData == null) {
          throw Exception('API yanıtı boş');
        }

        try {
          return ChartResponse.fromJson(jsonData);
        } catch (e) {
          _logger.warning('JSON dönüşüm hatası: $e');
          _logger.warning('Gelen JSON veri: ${response.body}');
          throw Exception('Veri formatı hatası: $e');
        }
      } else {
        _logger.severe('API Hata kodu: ${response.statusCode}');
        _logger.severe('API Hata mesajı: ${response.body}');
        throw Exception('API yanıt kodu: ${response.statusCode}');
      }
    } on FormatException catch (e) {
      _logger.severe('Format hatası: $e');
      throw Exception('Veri format hatası');
    } catch (e) {
      _logger.severe('Genel hata: $e');
      throw Exception('Beklenmeyen bir hata oluştu: $e');
    }
  }
}
