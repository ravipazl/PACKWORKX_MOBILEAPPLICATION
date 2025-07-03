import 'package:flutter/material.dart';
import 'package:packwork/components/complete_orders_screen.dart';
import 'package:packwork/components/dashboard_screen.dart';
import 'package:packwork/components/pending_order_screen.dart';
import 'package:packwork/components/work_order_screen.dart';
import '../widgets/app_sidebar.dart';
import '../widgets/app_header.dart';
import '../style/app_colors.dart';
import '../style/app_styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _currentPage = 'Dashboard';

  void _onMenuItemSelected(String page) {
    setState(() {
      _currentPage = page;
    });
    Navigator.pop(context); // Close drawer
  }

  Widget _buildCurrentPageContent() {
    switch (_currentPage) {
      case 'Dashboard':

        return const DashboardScreen();
         // Use the new dashboard component
      case 'In Progress':

        return const InProgressOrdersScreen();

      case 'Complete':

        return const CompletedOrdersScreen();

      case 'Work Order':

       return const WorkOrderScreen();
      
      default:

        return const DashboardScreen();
    }
  }

 

  Widget _buildOrders() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart, size: 80, color: AppColors.warning),
          SizedBox(height: AppStyles.spacing16),
          Text(
            'Orders',
            style: AppStyles.h3.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppStyles.spacing8),
          Text(
            'View and manage orders',
            style: AppStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

 



  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppHeader(
        title: _currentPage,
        onMenuPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
      drawer: AppSidebar(
        currentPage: _currentPage,
        onMenuItemSelected: _onMenuItemSelected,
      ),
      body: _buildCurrentPageContent(),
    );
  }
}
