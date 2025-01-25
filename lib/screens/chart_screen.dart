import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/app_layout.dart';
import '../services/chart_api_service.dart';
import '../models/chart_data_model.dart';

// Enum'u sınıf dışına taşıdık
enum ChartType { bar, line, pie, radar }

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  final ChartApiService _apiService = ChartApiService();
  ChartResponse? chartData;
  bool isLoading = true;
  ChartType _selectedChartType = ChartType.bar; // Varsayılan grafik tipi

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await _apiService.fetchChartData();
      if (!mounted) return; // Widget hala ağaçta mı kontrol et
      setState(() {
        chartData = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return; // Widget hala ağaçta mı kontrol et
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veri yüklenirken hata oluştu: $e')),
      );
    }
  }

  // Toplam değerlendirme sayısını hesaplayan yardımcı metod
  int _calculateTotal() {
    return chartData!.data.fold(0, (sum, item) => sum + item.count) +
        chartData!.nullValueCount;
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Değerlendirme Grafiği',
      currentIndex: 2,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : chartData == null
              ? const Center(child: Text('Veri bulunamadı'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Butonları Wrap widget'ı ile sararak taşmayı önlüyoruz
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: [
                          _buildChartTypeButton(
                            'Bar',
                            Icons.bar_chart,
                            ChartType.bar,
                          ),
                          _buildChartTypeButton(
                            'Çizgi',
                            Icons.show_chart,
                            ChartType.line,
                          ),
                          _buildChartTypeButton(
                            'Pasta',
                            Icons.pie_chart,
                            ChartType.pie,
                          ),
                          _buildChartTypeButton(
                            'Radar',
                            Icons.radar,
                            ChartType.radar,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Toplam Değerlendirme: ${_calculateTotal()}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: _buildSelectedChart(),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildChartTypeButton(String label, IconData icon, ChartType type) {
    return SizedBox(
      height: 40,
      child: ElevatedButton.icon(
        onPressed: () => setState(() => _selectedChartType = type),
        icon: Icon(icon, size: 20),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: _selectedChartType == type
              ? const Color(0xFF333333)
              : Colors.grey.shade200,
          foregroundColor:
              _selectedChartType == type ? Colors.white : Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
      ),
    );
  }

  Widget _buildSelectedChart() {
    switch (_selectedChartType) {
      case ChartType.bar:
        return _buildBarChart();
      case ChartType.line:
        return _buildLineChart();
      case ChartType.pie:
        return _buildPieChart();
      case ChartType.radar:
        return _buildRadarChart();
    }
  }

  Widget _buildBarChart() {
    final maxValue = [
      ...chartData!.data.map((e) => e.count.toDouble()),
      chartData!.nullValueCount.toDouble()
    ].reduce((a, b) => a > b ? a : b);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxValue,
        barGroups: [
          ...chartData!.data.map((data) {
            return BarChartGroupData(
              x: data.ratingScore,
              barRods: [
                BarChartRodData(
                  toY: data.count.toDouble(),
                  color: _getBarColor(data.ratingScore),
                  width: 40,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }),
          // Belirtilmemiş değerler için bar
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: chartData!.nullValueCount.toDouble(),
                color: Colors.grey.shade300,
                width: 40,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ],
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value == 0) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Belirtilmemiş',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    '${value.toInt()}★',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(),
            left: BorderSide(),
          ),
        ),
      ),
    );
  }

  Widget _buildLineChart() {
    final allValues = [
      ...chartData!.data.map((e) => e.count.toDouble()),
      chartData!.nullValueCount.toDouble()
    ];
    final maxY = allValues.reduce((a, b) => a > b ? a : b);

    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: [
              // Belirtilmemiş değer için nokta
              FlSpot(0, chartData!.nullValueCount.toDouble()),
              // Diğer değerler
              ...chartData!.data.map((data) {
                return FlSpot(
                    data.ratingScore.toDouble(), data.count.toDouble());
              }),
            ],
            isCurved: true,
            color: const Color(0xFF333333),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) =>
                  FlDotCirclePainter(
                radius: 6,
                color: Colors.white,
                strokeWidth: 3,
                strokeColor: const Color(0xFF333333),
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0xFF333333).withAlpha(25),
            ),
          ),
        ],
        minX: 0,
        maxX: 5.5,
        minY: 0,
        maxY: maxY + (maxY * 0.1), // %10 boşluk bırak
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                if (value == 0) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Text(
                      'Belirtilmemiş',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  );
                }
                if (value == 0 || value == 6 || value % 1 != 0) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    '${value.toInt()}★',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: maxY > 10 ? maxY / 5 : 1, // Dinamik aralık
              getTitlesWidget: (value, meta) {
                if (value % 1 != 0) return const SizedBox.shrink();
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY > 10 ? maxY / 5 : 1,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.withAlpha(51),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey.withAlpha(51)),
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    final total = _calculateTotal();

    return Stack(
      alignment: Alignment.center,
      children: [
        // Pasta grafik - ortada
        Center(
          child: PieChart(
            PieChartData(
              sections: [
                ...chartData!.data.map((data) {
                  return PieChartSectionData(
                    color: _getBarColor(data.ratingScore),
                    value: data.count.toDouble(),
                    title: '',
                    radius: 120,
                    showTitle: false,
                  );
                }),
                // Null değerler için yeni dilim
                PieChartSectionData(
                  color: Colors.grey.shade300,
                  value: chartData!.nullValueCount.toDouble(),
                  title: '',
                  radius: 120,
                  showTitle: false,
                ),
              ],
              sectionsSpace: 2,
              centerSpaceRadius: 80,
              startDegreeOffset: -90,
            ),
          ),
        ),
        // Merkezdeki toplam sayı
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Toplam',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            Text(
              total.toString(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
        // Sağ alt köşedeki açıklama listesi
        Positioned(
          right: 20,
          bottom: 20,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(200),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withAlpha(51)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...chartData!.data.map((data) {
                  return _buildLegendItem(
                    '${data.ratingScore}★',
                    data.count,
                    _getBarColor(data.ratingScore),
                  );
                }),
                _buildLegendItem(
                  'Değerlendirilmemiş',
                  chartData!.nullValueCount,
                  Colors.grey.shade300,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$count',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadarChart() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: RadarChart(
        RadarChartData(
          radarShape: RadarShape.polygon,
          ticksTextStyle: const TextStyle(color: Colors.transparent),
          tickBorderData: const BorderSide(color: Colors.transparent),
          gridBorderData: const BorderSide(color: Colors.grey, width: 2),
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          dataSets: [
            RadarDataSet(
              fillColor: const Color(0xFF333333).withAlpha(51),
              borderColor: const Color(0xFF333333),
              entryRadius: 3,
              dataEntries: [
                RadarEntry(value: chartData!.nullValueCount.toDouble()),
                ...chartData!.data.map((data) {
                  return RadarEntry(value: data.count.toDouble());
                }),
              ],
            ),
          ],
          tickCount: 5,
          radarBorderData: const BorderSide(color: Colors.transparent),
          titlePositionPercentageOffset: 0.15,
          getTitle: (index, angle) {
            if (index == 0) {
              return RadarChartTitle(
                text: 'Belirtilmemiş\n(${chartData!.nullValueCount})',
                angle: angle,
              );
            }
            final data = chartData!.data[index - 1];
            return RadarChartTitle(
              text: '${data.ratingScore}★\n(${data.count})',
              angle: angle,
            );
          },
        ),
      ),
    );
  }

  Color _getBarColor(int rating) {
    switch (rating) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.yellow;
      case 4:
        return Colors.lightGreen;
      case 5:
        return Colors.green;
      default:
        return Colors.blue;
    }
  }
}
