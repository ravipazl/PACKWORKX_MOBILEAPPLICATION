// import 'package:flutter/material.dart';
// import '../widgets/app_sidebar.dart';
// import '../widgets/app_header.dart';
// import '../style/app_colors.dart';
// import '../style/app_styles.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   String _currentPage = 'Dashboard';

//   void _onMenuItemSelected(String page) {
//     setState(() {
//       _currentPage = page;
//     });
//     Navigator.pop(context); // Close drawer
//   }

//   Widget _buildCurrentPageContent() {
//     switch (_currentPage) {
//       case 'Dashboard':
//         return _buildDashboard();
//       case 'Inventory':
//         return _buildInventory();
//       case 'Orders':
//         return _buildOrders();
//       case 'Products':
//         return _buildProducts();
//       case 'Reports':
//         return _buildReports();
//       case 'Settings':
//         return _buildSettings();
//       default:
//         return _buildDashboard();
//     }
//   }

//   Widget _buildDashboard() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.dashboard, size: 80, color: AppColors.primary),
//           SizedBox(height: AppStyles.spacing16),
//           Text(
//             'Dashboard',
//             style: AppStyles.h3.copyWith(
//               color: AppColors.textPrimary,
//               fontFamily: AppStyles.fontFamily,
//             ),
//           ),
//           SizedBox(height: AppStyles.spacing8),
//           Text(
//             'Welcome to Packworks Dashboard',
//             style: AppStyles.bodyMedium.copyWith(
//               color: AppColors.textSecondary,
//                fontFamily: AppStyles.fontFamily,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInventory() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.inventory, size: 80, color: AppColors.success),
//           SizedBox(height: AppStyles.spacing16),
//           Text(
//             'Inventory Management',
//             style: AppStyles.h3.copyWith(
//               color: AppColors.textPrimary,
//             ),
//           ),
//           SizedBox(height: AppStyles.spacing8),
//           Text(
//             'Manage your inventory here',
//             style: AppStyles.bodyMedium.copyWith(
//               color: AppColors.textSecondary,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOrders() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.shopping_cart, size: 80, color: AppColors.warning),
//           SizedBox(height: AppStyles.spacing16),
//           Text(
//             'Orders',
//             style: AppStyles.h3.copyWith(
//               color: AppColors.textPrimary,
//             ),
//           ),
//           SizedBox(height: AppStyles.spacing8),
//           Text(
//             'View and manage orders',
//             style: AppStyles.bodyMedium.copyWith(
//               color: AppColors.textSecondary,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildProducts() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.category, size: 80, color: AppColors.primary),
//           SizedBox(height: AppStyles.spacing16),
//           Text(
//             'Products',
//             style: AppStyles.h3.copyWith(
//               color: AppColors.textPrimary,
//             ),
//           ),
//           SizedBox(height: AppStyles.spacing8),
//           Text(
//             'Manage your products',
//             style: AppStyles.bodyMedium.copyWith(
//               color: AppColors.textSecondary,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildReports() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.bar_chart, size: 80, color: AppColors.primary),
//           SizedBox(height: AppStyles.spacing16),
//           Text(
//             'Reports',
//             style: AppStyles.h3.copyWith(
//               color: AppColors.textPrimary,
//             ),
//           ),
//           SizedBox(height: AppStyles.spacing8),
//           Text(
//             'View reports and analytics',
//             style: AppStyles.bodyMedium.copyWith(
//               color: AppColors.textSecondary,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSettings() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.settings, size: 80, color: AppColors.textSecondary),
//           SizedBox(height: AppStyles.spacing16),
//           Text(
//             'Settings',
//             style: AppStyles.h3.copyWith(
//               color: AppColors.textPrimary,
//             ),
//           ),
//           SizedBox(height: AppStyles.spacing8),
//           Text(
//             'App settings and preferences',
//             style: AppStyles.bodyMedium.copyWith(
//               color: AppColors.textSecondary,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: AppHeader(
//         title: _currentPage,
//         onMenuPressed: () {
//           _scaffoldKey.currentState?.openDrawer();
//         },
//       ),
//       drawer: AppSidebar(
//         currentPage: _currentPage,
//         onMenuItemSelected: _onMenuItemSelected,
//       ),
//       body: _buildCurrentPageContent(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:packwork/components/dashboard_screen.dart';
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
        return const DashboardScreen(); // Use the new dashboard component
      case 'Inventory':
        return _buildInventory();
      case 'Orders':
        return _buildOrders();
      case 'Products':
        return _buildProducts();
      case 'Reports':
        return _buildReports();
      case 'Settings':
        return _buildSettings();
      default:
        return const DashboardScreen();
    }
  }

  Widget _buildInventory() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory, size: 80, color: AppColors.success),
          SizedBox(height: AppStyles.spacing16),
          Text(
            'Inventory Management',
            style: AppStyles.h3.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppStyles.spacing8),
          Text(
            'Manage your inventory here',
            style: AppStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
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

  Widget _buildProducts() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.category, size: 80, color: AppColors.primary),
          SizedBox(height: AppStyles.spacing16),
          Text(
            'Products',
            style: AppStyles.h3.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppStyles.spacing8),
          Text(
            'Manage your products',
            style: AppStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReports() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bar_chart, size: 80, color: AppColors.primary),
          SizedBox(height: AppStyles.spacing16),
          Text(
            'Reports',
            style: AppStyles.h3.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppStyles.spacing8),
          Text(
            'View reports and analytics',
            style: AppStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettings() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.settings, size: 80, color: AppColors.textSecondary),
          SizedBox(height: AppStyles.spacing16),
          Text(
            'Settings',
            style: AppStyles.h3.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppStyles.spacing8),
          Text(
            'App settings and preferences',
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
