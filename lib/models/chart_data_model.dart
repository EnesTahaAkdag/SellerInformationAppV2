class ChartResponse {
  final bool success;
  final String? errorMessage;
  final List<ChartData> data;
  final int count;
  final int totalCount;
  final int nullValueCount;

  ChartResponse({
    required this.success,
    this.errorMessage,
    required this.data,
    required this.count,
    required this.totalCount,
    required this.nullValueCount,
  });

  factory ChartResponse.fromJson(Map<String, dynamic> json) {
    return ChartResponse(
      success: json['success'],
      errorMessage: json['errorMessage'],
      data: (json['data'] as List)
          .map((item) => ChartData.fromJson(item))
          .toList(),
      count: json['count'],
      totalCount: json['totalCount'],
      nullValueCount: json['nullValueCount'],
    );
  }
}

class ChartData {
  final int ratingScore;
  final int count;
  final bool isNullValue;

  ChartData({
    required this.ratingScore,
    required this.count,
    required this.isNullValue,
  });

  factory ChartData.fromJson(Map<String, dynamic> json) {
    return ChartData(
      ratingScore: json['ratingScore'],
      count: json['count'],
      isNullValue: json['isNullValue'],
    );
  }
}
