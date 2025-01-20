class SellerInfosDetailModel {
  final int id;
  final String? link;
  final String storeName;
  final String? telephone;
  final String? email;
  final String? address;
  final String? sellerName;
  final Map<String, dynamic>? data;

  SellerInfosDetailModel({
    required this.id,
    this.link,
    required this.storeName,
    this.telephone,
    this.email,
    this.address,
    this.sellerName,
    this.data,
  });

  factory SellerInfosDetailModel.fromJson(Map<String, dynamic> json) {
    return SellerInfosDetailModel(
      id: json['id'] as int,
      link: json['link']?.toString(),
      storeName: json['storeName']?.toString() ?? '',
      telephone: json['telephone']?.toString(),
      email: json['email']?.toString(),
      address: json['address']?.toString(),
      sellerName: json['sellerName']?.toString(),
      data: json['data'] as Map<String, dynamic>?,
    );
  }
}
