class SellerInfosListModel {
  final int id;
  final String storeName;
  final String? telephone;
  final Map<String, dynamic>? data;

  SellerInfosListModel({
    required this.id,
    required this.storeName,
    this.telephone,
    this.data,
  });

  factory SellerInfosListModel.fromJson(Map<String, dynamic> json) {
    return SellerInfosListModel(
      id: json['id'] as int,
      storeName: json['storeName']?.toString() ?? '',
      telephone: json['telephone']?.toString(),
      data: json['data'] as Map<String, dynamic>?,
    );
  }
}
