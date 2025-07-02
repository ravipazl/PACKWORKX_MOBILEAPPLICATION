import 'package:flutter/material.dart';
import '../style/app_colors.dart';
import '../style/app_styles.dart';
import 'dart:math' as math;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DateTime fromDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime toDate = DateTime.now();

  // Interactive states
  int selectedPieIndex = -1;
  int selectedBarIndex = -1;
  bool showPieDetails = false;
  bool showBarDetails = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateRangeSelector(),
          const SizedBox(height: 20),
          _buildMetricsCards(),
          const SizedBox(height: 30),
          _buildProductionKPIChart(),
          const SizedBox(height: 30),
          _buildMachinePerformanceChart(),
        ],
      ),
    );
  }

  // Helper methods for interactive charts
  PieChartData _getPieDataByIndex(int index) {
    final pieData = [
      PieChartData(
          value: 50,
          color: const Color(0xFF4CAF50),
          label: '50%',
          name: 'Quality Pass Rate'),
      PieChartData(
          value: 20,
          color: const Color(0xFF2196F3),
          label: '20%',
          name: 'Machine Utilization'),
      PieChartData(
          value: 12,
          color: const Color(0xFFFFC107),
          label: '12%',
          name: 'On-time delivery'),
      PieChartData(
          value: 8,
          color: const Color(0xFF00BCD4),
          label: '8%',
          name: 'Daily production Target'),
    ];
    return pieData[index];
  }

  BarChartDataPoint _getBarDataByIndex(int index) {
    final barData = [
      BarChartDataPoint(
          label: 'AM',
          value: 50,
          color: const Color(0xFF2196F3),
          details: '50% efficiency - Good performance'),
      BarChartDataPoint(
          label: 'SAM',
          value: 100,
          color: const Color(0xFFE91E63),
          details: '100% efficiency - Excellent performance'),
      BarChartDataPoint(
          label: 'RS4',
          value: 80,
          color: const Color(0xFF4CAF50),
          details: '80% efficiency - Very good performance'),
      BarChartDataPoint(
          label: 'new',
          value: 45,
          color: const Color(0xFFFF5722),
          details: '45% efficiency - Needs improvement'),
      BarChartDataPoint(
          label: 'KK',
          value: 100,
          color: const Color(0xFF2196F3),
          details: '100% efficiency - Excellent performance'),
      BarChartDataPoint(
          label: 'Autoplant',
          value: 200,
          color: const Color(0xFFFF5722),
          details: '200% efficiency - Outstanding performance'),
    ];
    return barData[index];
  }

  Widget _buildDateRangeSelector() {
    return Row(
      children: [
        Expanded(
          child: _buildDateSelector('From Date', fromDate, (date) {
            setState(() => fromDate = date);
          }),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildDateSelector('To Date', toDate, (date) {
            setState(() => toDate = date);
          }),
        ),
      ],
    );
  }

  Widget _buildDateSelector(
      String label, DateTime date, Function(DateTime) onDateSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppStyles.bodyMedium.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: DateTime(2020),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (picked != null) {
              onDateSelected(picked);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year.toString().substring(2)}',
                    style: AppStyles.bodyMedium,
                  ),
                ),
                const Icon(Icons.calendar_today, size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricsCards() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Sales Order',
                'Active Orders',
                '1',
                '+11.1%',
                'Target progress 1%',
                '100',
                const Color(0xFF4CAF50),
                const Color(0XFFF4F8F6),
                Icons.shopping_bag,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                'Work Orders',
                'In Production',
                '8',
                '+11.1%',
                'Target progress 1%',
                '50',
                const Color(0xFFFF0303),
                const Color(0xFFF4F8F6),
                Icons.work,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'SKU Inventory',
                'Total Stock',
                '4',
                '+11.1%',
                'Target progress 1%',
                '200',
                const Color(0xFF7A99F3),
                const Color(0xFFFFFFFF),
                Icons.inventory_2,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                'Active machines',
                'Operational status',
                '17/19',
                '+11.1%',
                'Target progress 1%',
                '19',
                const Color(0xFFE5B700),
                const Color(0xFFFFFFFF),
                Icons.precision_manufacturing,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    String title,
    String subtitle,
    String mainValue,
    String percentage,
    String targetText,
    String targetValue,
    Color color,
    Color color1,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color,
            color1,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        // border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.black, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: AppStyles.bodySmall.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppStyles.fontFamily,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: AppStyles.bodySmall.copyWith(
              color: Colors.black.withOpacity(0.5),
              fontFamily: AppStyles.fontFamily,
              fontSize: 10,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(children: [
            Flexible(
              child: Text(
                mainValue,
                style: AppStyles.h2.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                percentage,
                style: AppStyles.bodySmall.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'View details',
                  style: AppStyles.bodySmall.copyWith(
                    color: Colors.black,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  targetText,
                  style: AppStyles.bodySmall.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                targetValue,
                style: AppStyles.bodySmall.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
           Container(
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(5),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.5, // Fixed: Changed from 5 to 0.5 (50%)
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductionKPIChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Production KPIs & Machine Efficiency',
            style: AppStyles.h4.copyWith(
              color: Colors.black,
              fontFamily: AppStyles.fontFamily,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: CustomPieChart(
                        data: [
                          PieChartData(
                              value: 50,
                              color: const Color(0xFF4CAF50),
                              label: '50%',
                              name: 'Quality Pass Rate'),
                          PieChartData(
                              value: 20,
                              color: const Color(0xFF2196F3),
                              label: '20%',
                              name: 'Machine Utilization'),
                          PieChartData(
                              value: 12,
                              color: const Color(0xFFFFC107),
                              label: '12%',
                              name: 'On-time delivery'),
                          PieChartData(
                              value: 8,
                              color: const Color(0xFF00BCD4),
                              label: '8%',
                              name: 'Daily production Target'),
                        ],
                        selectedIndex: selectedPieIndex,
                        onTap: (index) {
                          setState(() {
                            selectedPieIndex =
                                selectedPieIndex == index ? -1 : index;
                            showPieDetails = selectedPieIndex != -1;
                          });
                        },
                      ),
                    ),
                    if (showPieDetails && selectedPieIndex != -1) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _getPieDataByIndex(selectedPieIndex)
                              .color
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: _getPieDataByIndex(selectedPieIndex)
                                  .color
                                  .withOpacity(0.3)),
                        ),
                        child: Column(
                          children: [
                            Text(
                              _getPieDataByIndex(selectedPieIndex).name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:
                                    _getPieDataByIndex(selectedPieIndex).color,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Value: ${_getPieDataByIndex(selectedPieIndex).value.toInt()}%',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLegendItem(
                        'Daily production Target', const Color(0xFF00BCD4)),
                    _buildLegendItem(
                        'Quality Pass Rate', const Color(0xFF4CAF50)),
                    _buildLegendItem(
                        'Machine Utilization', const Color(0xFF2196F3)),
                    _buildLegendItem(
                        'On-time delivery', const Color(0xFFFFC107)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: AppStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMachinePerformanceChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Machine performance',
            style: AppStyles.h4.copyWith(
              color: Colors.black,
              fontFamily: AppStyles.fontFamily,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 250,
            child: Column(
              children: [
                Expanded(
                  child: CustomBarChart(
                    data: [
                      BarChartDataPoint(
                          label: 'AM',
                          value: 50,
                          color: const Color(0xFF2196F3),
                          details: '50% efficiency - Good performance'),
                      BarChartDataPoint(
                          label: 'SAM',
                          value: 100,
                          color: const Color(0xFFE91E63),
                          details: '100% efficiency - Excellent performance'),
                      BarChartDataPoint(
                          label: 'RS4',
                          value: 80,
                          color: const Color(0xFF4CAF50),
                          details: '80% efficiency - Very good performance'),
                      BarChartDataPoint(
                          label: 'new',
                          value: 45,
                          color: const Color(0xFFFF5722),
                          details: '45% efficiency - Needs improvement'),
                      BarChartDataPoint(
                          label: 'KK',
                          value: 100,
                          color: const Color(0xFF2196F3),
                          details: '100% efficiency - Excellent performance'),
                      BarChartDataPoint(
                          label: 'Autoplant',
                          value: 200,
                          color: const Color(0xFFFF5722),
                          details: '200% efficiency - Outstanding performance'),
                    ],
                    maxValue: 250,
                    selectedIndex: selectedBarIndex,
                    onTap: (index) {
                      setState(() {
                        selectedBarIndex =
                            selectedBarIndex == index ? -1 : index;
                        showBarDetails = selectedBarIndex != -1;
                      });
                    },
                  ),
                ),
                if (showBarDetails && selectedBarIndex != -1) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getBarDataByIndex(selectedBarIndex)
                          .color
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: _getBarDataByIndex(selectedBarIndex)
                              .color
                              .withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${_getBarDataByIndex(selectedBarIndex).label} Machine',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _getBarDataByIndex(selectedBarIndex).color,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getBarDataByIndex(selectedBarIndex).details,
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Pie Chart Data Class
class PieChartData {
  final double value;
  final Color color;
  final String label;
  final String name;

  PieChartData(
      {required this.value,
      required this.color,
      required this.label,
      required this.name});
}

// Custom Pie Chart Widget
class CustomPieChart extends StatelessWidget {
  final List<PieChartData> data;
  final int selectedIndex;
  final Function(int) onTap;

  const CustomPieChart(
      {super.key,
      required this.data,
      required this.selectedIndex,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) {
        _handleTap(details.localPosition);
      },
      child: CustomPaint(
        size: const Size(200, 200),
        painter: PieChartPainter(data, selectedIndex),
      ),
    );
  }

  void _handleTap(Offset localPosition) {
    final center = const Offset(100, 100);
    final radius = 90.0;
    final innerRadius = radius * 0.4;

    final distance = (localPosition - center).distance;
    if (distance >= innerRadius && distance <= radius) {
      double total = data.fold(0, (sum, item) => sum + item.value);
      double currentAngle = -math.pi / 2;

      final tapAngle = math.atan2(
          localPosition.dy - center.dy, localPosition.dx - center.dx);
      final normalizedTapAngle =
          tapAngle < -math.pi / 2 ? tapAngle + 2 * math.pi : tapAngle;

      for (int i = 0; i < data.length; i++) {
        final sweepAngle = (data[i].value / total) * 2 * math.pi;
        final endAngle = currentAngle + sweepAngle;

        if (normalizedTapAngle >= currentAngle &&
            normalizedTapAngle <= endAngle) {
          onTap(i);
          break;
        }
        currentAngle += sweepAngle;
      }
    }
  }
}

class PieChartPainter extends CustomPainter {
  final List<PieChartData> data;
  final int selectedIndex;

  PieChartPainter(this.data, this.selectedIndex);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 10;
    final innerRadius = radius * 0.4;

    double total = data.fold(0, (sum, item) => sum + item.value);
    double currentAngle = -math.pi / 2;

    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      final sweepAngle = (item.value / total) * 2 * math.pi;
      final isSelected = i == selectedIndex;
      final segmentRadius =
          isSelected ? radius + 5 : radius; // Expand selected segment

      final paint = Paint()
        ..color = isSelected ? item.color : item.color.withOpacity(0.8)
        ..style = PaintingStyle.fill;

      final path = Path();
      path.moveTo(center.dx + innerRadius * math.cos(currentAngle),
          center.dy + innerRadius * math.sin(currentAngle));
      path.arcTo(
        Rect.fromCircle(center: center, radius: innerRadius),
        currentAngle,
        sweepAngle,
        false,
      );
      path.arcTo(
        Rect.fromCircle(center: center, radius: segmentRadius),
        currentAngle + sweepAngle,
        -sweepAngle,
        false,
      );
      path.close();

      canvas.drawPath(path, paint);

      // Draw label
      final labelAngle = currentAngle + sweepAngle / 2;
      final labelRadius = (segmentRadius + innerRadius) / 2;
      final labelX = center.dx + labelRadius * math.cos(labelAngle);
      final labelY = center.dy + labelRadius * math.sin(labelAngle);

      final textPainter = TextPainter(
        text: TextSpan(
          text: item.label,
          style: TextStyle(
            color: Colors.white,
            fontSize: isSelected ? 16 : 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(labelX - textPainter.width / 2, labelY - textPainter.height / 2),
      );

      currentAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

// Custom Bar Chart Data Class
class BarChartDataPoint {
  final String label;
  final double value;
  final Color color;
  final String details;

  BarChartDataPoint(
      {required this.label,
      required this.value,
      required this.color,
      required this.details});
}

// Custom Bar Chart Widget
class CustomBarChart extends StatelessWidget {
  final List<BarChartDataPoint> data;
  final double maxValue;
  final int selectedIndex;
  final Function(int) onTap;

  const CustomBarChart(
      {super.key,
      required this.data,
      required this.maxValue,
      required this.selectedIndex,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth =
            constraints.maxWidth - 60; // Reserve space for Y-axis
        final availableHeight =
            constraints.maxHeight - 40; // Reserve space for X-axis
        final barWidth = availableWidth / data.length;

        return Stack(
          children: [
            // Grid lines and Y-axis
            CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              painter: AxisPainter(maxValue),
            ),
            // Bars and labels
            Positioned(
              left: 50, // Space for Y-axis labels
              bottom: 30, // Space for X-axis labels
              child: SizedBox(
                width: availableWidth,
                height: availableHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: data.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final isSelected = index == selectedIndex;

                    return GestureDetector(
                      onTap: () => onTap(index),
                      child: SizedBox(
                        width: barWidth,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Column(
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: math.min(barWidth - 8, 25),
                                    height: (item.value / maxValue) *
                                        (availableHeight - 20),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? item.color
                                          : item.color.withOpacity(0.8),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4),
                                        topRight: Radius.circular(4),
                                      ),
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color:
                                                    item.color.withOpacity(0.3),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ]
                                          : null,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            // X-axis labels
            Positioned(
              left: 50,
              bottom: 0,
              child: SizedBox(
                width: availableWidth,
                height: 30,
                child: Row(
                  children: data.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final isSelected = index == selectedIndex;

                    return SizedBox(
                      width: barWidth,
                      child: Center(
                        child: Text(
                          item.label,
                          style: TextStyle(
                            fontSize: isSelected ? 11 : 10,
                            color: isSelected ? item.color : Colors.grey,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Custom Painter for Axes Only
class AxisPainter extends CustomPainter {
  final double maxValue;

  AxisPainter(this.maxValue);

  @override
  void paint(Canvas canvas, Size size) {
    final axisPaint = Paint()
      ..color = Colors.grey.withOpacity(0.6)
      ..strokeWidth = 2;

    final textStyle = TextStyle(
      color: Colors.grey.shade600,
      fontSize: 10,
    );

    // Chart area dimensions
    final chartLeft = 50.0;
    final chartRight = size.width - 10;
    final chartTop = 10.0;
    final chartBottom = size.height - 30;
    final chartHeight = chartBottom - chartTop;

    // Draw Y-axis line only
    canvas.drawLine(
      Offset(chartLeft, chartTop),
      Offset(chartLeft, chartBottom),
      axisPaint,
    );

    // Draw X-axis line only
    canvas.drawLine(
      Offset(chartLeft, chartBottom),
      Offset(chartRight, chartBottom),
      axisPaint,
    );

    // Draw Y-axis labels only (no grid lines)
    final intervals = 5; // Number of intervals
    for (int i = 0; i <= intervals; i++) {
      final value = (maxValue / intervals) * i;
      final y = chartBottom - (i / intervals) * chartHeight;

      // Draw Y-axis label only
      final textPainter = TextPainter(
        text: TextSpan(
          text: value.toInt().toString(),
          style: textStyle,
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(chartLeft - textPainter.width - 5, y - textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
