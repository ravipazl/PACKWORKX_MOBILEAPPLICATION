import 'package:flutter/material.dart';
import '../style/app_colors.dart';
import '../style/app_styles.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onMenuPressed;
  final List<Widget>? actions;

  const AppHeader({
    super.key,
    required this.title,
    this.onMenuPressed,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textOnPrimary,
      elevation: 2,
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: onMenuPressed,
      ),
      title: Row(
        children: [
          const Icon(Icons.inventory_2, size: 24),
          SizedBox(width: AppStyles.spacing8),
          Text(
            title,
            style: AppStyles.appBarTitle.copyWith(
              color: AppColors.textOnPrimary,
            ),
          ),
        ],
      ),
      actions: actions ?? [
        // IconButton(
        //   icon: const Icon(Icons.notifications),
        //   onPressed: () {
        //     // Handle notifications
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       SnackBar(
        //         content: Text(
        //           'No new notifications',
        //           style: AppStyles.bodyMedium.copyWith(
        //             color: AppColors.textOnPrimary,
        //           ),
        //         ),
        //         duration: Duration(seconds: 2),
        //         backgroundColor: AppColors.textPrimary,
        //       ),
        //     );
        //   },
        // ),
        // PopupMenuButton<String>(
        //   icon: const Icon(Icons.account_circle),
        //   onSelected: (value) {
        //     switch (value) {
        //       case 'profile':
        //         // Handle profile
        //         break;
        //       case 'logout':
        //         Navigator.pushReplacementNamed(context, '/login');
        //         break;
        //     }
        //   },
        //   itemBuilder: (BuildContext context) => [
        //     PopupMenuItem<String>(
        //       value: 'profile',
        //       child: Row(
        //         children: [
        //           Icon(Icons.person, color: AppColors.textSecondary),
        //           SizedBox(width: AppStyles.spacing8),
        //           Text(
        //             'Profile',
        //             style: AppStyles.bodyMedium.copyWith(
        //               color: AppColors.textPrimary,
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //     PopupMenuItem<String>(
        //       value: 'logout',
        //       child: Row(
        //         children: [
        //           Icon(Icons.logout, color: AppColors.textSecondary),
        //           SizedBox(width: AppStyles.spacing8),
        //           Text(
        //             'Logout',
        //             style: AppStyles.bodyMedium.copyWith(
        //               color: AppColors.textPrimary,
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
