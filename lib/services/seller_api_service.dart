import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:seller_information_v2/base_url.dart';
import '../models/seller_infos_list_model.dart';
import '../models/seller_infos_detail_model.dart';

class SellerApiService {
  // HTTP başlıkları eklendi
  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  int _currentPage = 1;
  final int _pageSize = 50;

  Future<List<SellerInfosListModel>> getSellerList(
      {bool loadMore = false}) async {
    if (loadMore) {
      _currentPage++;
    } else {
      _currentPage = 1;
    }

    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/ApplicationContentApi/MarketPlaceData?page=$_currentPage&pageSize=$_pageSize'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['data'] == null) {
          return [];
        }
        final List<dynamic> data = responseData['data'] as List<dynamic>;
        return data.map((json) => SellerInfosListModel.fromJson(json)).toList();
      } else {
        throw Exception(
            'Satıcılar yüklenirken hata oluştu: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Hata!: $e');
    }
  }

  Future<SellerInfosDetailModel> getSellerDetail(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/ApplicationContentApi/StoreDetails?id=$id'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['data'] == null) {
          throw Exception('Veri bulunamadı');
        }
        final Map<String, dynamic> data = responseData['data'];
        return SellerInfosDetailModel.fromJson(data);
      } else {
        throw Exception(
            'Satıcı detayları yüklenirken hata oluştu: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Hata!: $e');
    }
  }
}
