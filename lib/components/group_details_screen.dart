import 'package:flutter/material.dart';
import 'package:packwork/components/quantity_popup.dart';
import '../style/app_colors.dart';
import '../style/app_styles.dart';

class GroupDetailsScreen extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String status;

  const GroupDetailsScreen({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.status,
  });

  @override
  _GroupDetailsScreenState createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Group Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: AppStyles.fontFamily,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGroupInfoSection(),
            const SizedBox(height: 24),
            _buildQuantitySection(),
            const SizedBox(height: 24),
            _buildLineLayersSection(),
            const SizedBox(height: 32),
            _buildBottomSection(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // You can now access widget.groupId, widget.groupName, widget.status

  Widget _buildGroupInfoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Group ID :', style: _labelStyle()),
                const SizedBox(height: 4),
                Text(widget.groupId, style: _valueStyle()),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Group Name :', style: _labelStyle()),
                const SizedBox(height: 4),
                Text(widget.groupName, style: _valueStyle()),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Status:', style: _labelStyle()),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.status == 'Active'
                      ? Colors.green.shade100
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.status,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: widget.status == 'Active'
                        ? Colors.green.shade700
                        : Colors.grey.shade700,
                    fontFamily: AppStyles.fontFamily,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  TextStyle _labelStyle() => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        fontFamily: AppStyles.fontFamily,
      );

  TextStyle _valueStyle() => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        fontFamily: AppStyles.fontFamily,
      );

  Widget _buildQuantitySection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildQuantityColumn('Total Quantity', 'XXXX'),
              _buildQuantityColumn('Allocation', 'XXXX'),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildQuantityColumn('Group Quantity', '50'),
              _buildQuantityColumn('Balance Quantity', '50'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityColumn(String title, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(title, style: _labelStyle()),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                fontFamily: AppStyles.fontFamily,
              )),
        ],
      ),
    );
  }

  Widget _buildLineLayersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLineLayerCard('Line Layer 1'),
        const SizedBox(height: 12),
        _buildLineLayerCard('Line Layer 2'),
        const SizedBox(height: 12),
        _buildLineLayerCard('Line Layer 3'),
      ],
    );
  }

  Widget _buildLineLayerCard(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: _valueStyle()),
          const SizedBox(height: 8),
          Text(
            'GSM: 120, BF: 18, Material : Kraft',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              fontFamily: AppStyles.fontFamily,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 0),
            child: ElevatedButton(
              onPressed: () {
                // Handle update quantity action
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return QuantityPopup();
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E3A59),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Update Quantity',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontFamily: AppStyles.fontFamily,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
