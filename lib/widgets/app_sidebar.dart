import 'package:flutter/material.dart';
import '../style/app_colors.dart';
import '../style/app_styles.dart';

class AppSidebar extends StatefulWidget {
  final String currentPage;
  final Function(String) onMenuItemSelected;

  const AppSidebar({
    super.key,
    required this.currentPage,
    required this.onMenuItemSelected,
  });

  @override
  State<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends State<AppSidebar> {
  bool isOrderManagementExpanded = false;

  @override
  void initState() {
    super.initState();
    // Auto-expand Order Management if current page is one of its sub-items
    if (widget.currentPage == 'In Progress' || widget.currentPage == 'Complete') {
      isOrderManagementExpanded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Custom header
          Container(
            width: double.infinity,
            color: AppColors.primary,
            padding: EdgeInsets.fromLTRB(
              AppStyles.spacing16,
              40,
              AppStyles.spacing16,
              AppStyles.spacing16,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: AppColors.surface,
                    child: Icon(
                      Icons.inventory_2,
                      size: 35,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: AppStyles.spacing8),
                  Text(
                    'PACKWORKX',
                    style: AppStyles.sidebarTitle.copyWith(
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Menu Items
          Flexible(
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: [
                _buildMenuItem(
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  isSelected: widget.currentPage == 'Dashboard',
                ),
                
                // Order Management with sub-items
                _buildExpandableMenuItem(
                  icon: Icons.shopping_cart,
                  title: 'Order Management',
                  isExpanded: isOrderManagementExpanded,
                  isSelected: widget.currentPage == 'In Progress' || widget.currentPage == 'Complete',
                  onTap: () {
                    setState(() {
                      isOrderManagementExpanded = !isOrderManagementExpanded;
                    });
                  },
                  subItems: [
                    _buildSubMenuItem(
                      icon: Icons.schedule,
                      title: 'In Progress',
                      isSelected: widget.currentPage == 'In Progress',
                    ),
                    _buildSubMenuItem(
                      icon: Icons.check_circle,
                      title: 'Complete',
                      isSelected: widget.currentPage == 'Complete',
                    ),
                  ],
                ),
                
                _buildMenuItem(
                  icon: Icons.work,
                  title: 'Work Order',
                  isSelected: widget.currentPage == 'Work Order',
                ),
                
                _buildMenuItem(
                  icon: Icons.inventory,
                  title: 'Inventory',
                  isSelected: widget.currentPage == 'Inventory',
                ),
                
                _buildMenuItem(
                  icon: Icons.category,
                  title: 'Products',
                  isSelected: widget.currentPage == 'Products',
                ),
                
                _buildMenuItem(
                  icon: Icons.bar_chart,
                  title: 'Reports',
                  isSelected: widget.currentPage == 'Reports',
                ),
                
                const Divider(),
                
                _buildMenuItem(
                  icon: Icons.settings,
                  title: 'Settings',
                  isSelected: widget.currentPage == 'Settings',
                ),
              ],
            ),
          ),
          
          // Footer
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppStyles.spacing16,
              vertical: AppStyles.spacing8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(height: 1),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  leading: Icon(Icons.logout, color: AppColors.error),
                  title: Text(
                    'Logout',
                    style: AppStyles.sidebarMenuItem.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required bool isSelected,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppStyles.spacing8,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppStyles.borderRadiusSmall),
        color: isSelected ? AppColors.primary.withOpacity(0.1) : null,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
        ),
        title: Text(
          title,
          style: AppStyles.sidebarMenuItem.copyWith(
            
            fontFamily: AppStyles.fontFamily,
            color: isSelected ? AppColors.primary : AppColors.textPrimary,
            fontWeight: isSelected ? AppStyles.semiBold : AppStyles.medium,
          ),
        ),
        onTap: () => widget.onMenuItemSelected(title),
        selected: isSelected,
        selectedTileColor: AppColors.primary.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppStyles.borderRadiusSmall),
        ),
      ),
    );
  }

  Widget _buildExpandableMenuItem({
    required IconData icon,
    required String title,
    required bool isExpanded,
    required bool isSelected,
    required VoidCallback onTap,
    required List<Widget> subItems,
  }) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: AppStyles.spacing8,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppStyles.borderRadiusSmall),
            color: isSelected ? AppColors.primary.withOpacity(0.1) : null,
          ),
          child: ListTile(
            leading: Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            title: Text(
              title,
              style: AppStyles.sidebarMenuItem.copyWith(
                fontFamily: AppStyles.fontFamily,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontWeight: isSelected ? AppStyles.semiBold : AppStyles.medium,
              ),
            ),
            trailing: Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            onTap: onTap,
            selected: isSelected,
            selectedTileColor: AppColors.primary.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppStyles.borderRadiusSmall),
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          height: isExpanded ? null : 0,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: isExpanded ? 1.0 : 0.0,
            child: Column(
              children: isExpanded ? subItems : [],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubMenuItem({
    required IconData icon,
    required String title,
    required bool isSelected,
  }) {
    return Container(
      margin: EdgeInsets.only(
        left: AppStyles.spacing16 + AppStyles.spacing8,
        right: AppStyles.spacing8,
        top: 2,
        bottom: 2,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppStyles.borderRadiusSmall),
        color: isSelected ? AppColors.primary.withOpacity(0.1) : null,
      ),
      child: ListTile(
        contentPadding: EdgeInsets.only(
          left: AppStyles.spacing12,
          right: AppStyles.spacing16,
        ),
        leading: Icon(
          icon,
          size: 18,
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
        ),
        title: Text(
          title,
          style: AppStyles.sidebarMenuItem.copyWith(
            fontFamily: AppStyles.fontFamily,
            color: isSelected ? AppColors.primary : AppColors.textPrimary,
            fontWeight: isSelected ? AppStyles.semiBold : AppStyles.medium,
            fontSize: 14, // Slightly smaller for sub-items
          ),
        ),
        onTap: () => widget.onMenuItemSelected(title),
        selected: isSelected,
        selectedTileColor: AppColors.primary.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppStyles.borderRadiusSmall),
        ),
      ),
    );
  }
}