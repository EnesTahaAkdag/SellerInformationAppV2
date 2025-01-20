import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/seller_infos_list_model.dart';
import '../models/seller_infos_detail_model.dart';

class SellerApiService {
  static const String baseUrl = 'https://dda6-37-130-115-91.ngrok-free.app';

  Future<List<SellerInfosListModel>> getSellerList() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/ApplicationContentApi/MarketPlaceData'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'] as List<dynamic>;

        return data.map((json) => SellerInfosListModel.fromJson(json)).toList();
      } else {
        throw Exception('Satıcılar yüklenirken hata oluştu');
      }
    } catch (e) {
      throw Exception('Hata!: $e');
    }
  }

  Future<SellerInfosDetailModel> getSellerDetail(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/ApplicationContentApi/StoreDetails?id=$id'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final Map<String, dynamic> data = responseData['data'];

        return SellerInfosDetailModel.fromJson(data);
      } else {
        throw Exception('Satıcı detayları yüklenirken hata oluştu');
      }
    } catch (e) {
      throw Exception('Hata!: $e');
    }
  }
}
