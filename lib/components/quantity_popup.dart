import 'package:flutter/material.dart';
import '../style/app_colors.dart';
import '../style/app_styles.dart';

class QuantityPopup extends StatefulWidget {
  @override
  _QuantityPopupState createState() => _QuantityPopupState();
}

class _QuantityPopupState extends State<QuantityPopup> {
  final TextEditingController _totalQuantityController = TextEditingController();
  final TextEditingController _usedQuantityController = TextEditingController();

  @override
  void dispose() {
    _totalQuantityController.dispose();
    _usedQuantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildInputField('Total quantity', _totalQuantityController),
            const SizedBox(height: 20),
            _buildInputField('Used quantity', _usedQuantityController),
            const SizedBox(height: 32),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Group name',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontFamily: AppStyles.fontFamily,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.close,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Row(
      children: [
       Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontFamily: AppStyles.fontFamily,
            ),
          ),
        
        const SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                hintText: '0',
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontFamily: AppStyles.fontFamily,
                ),
              ),
              style: TextStyle(
                fontSize: 16,
                fontFamily: AppStyles.fontFamily,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: 169,
      child: ElevatedButton(
        onPressed: () {
          // Handle submit action
          String totalQuantity = _totalQuantityController.text;
          String usedQuantity = _usedQuantityController.text;
          
          // Add your submission logic here
          print('Total Quantity: $totalQuantity');
          print('Used Quantity: $usedQuantity');
          
          // Close the popup
          Navigator.of(context).pop();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E3A59),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        child: Text(
          'Submit',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontFamily: AppStyles.fontFamily,
          ),
        ),
      ),
    );
  }
}