import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:packwork/components/group_details_screen.dart';
import '../style/app_colors.dart';
import '../style/app_styles.dart';
import '../services/api_service.dart';

class CompletedOrdersScreen extends StatefulWidget {
  const CompletedOrdersScreen({super.key});

  @override
  _CompletedOrdersScreenState createState() => _CompletedOrdersScreenState();
}

class _CompletedOrdersScreenState extends State<CompletedOrdersScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<GroupData> _groups = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchGroups();
  }

  // Fetch groups from API
  Future<void> _fetchGroups({String? searchQuery}) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final headers = await ApiService.headers;
      
      // Build query parameters
      String url = '${ApiService.groupSchedule}';
      List<String> queryParams = ['group_status=completed']; // Use Completed status
      
      if (searchQuery != null && searchQuery.isNotEmpty) {
        queryParams.add('search=$searchQuery');
      }
      
      url += '?${queryParams.join('&')}';

      print('Fetching completed groups from: $url');
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      print("Completed Groups Status Code: ${response.statusCode}");
      
      if (response.statusCode == 200) {
        print('Completed Groups Response: ${response.body}');
        final jsonData = json.decode(response.body);
        
        if (jsonData['success'] == true && jsonData['groups'] != null) {
          List<GroupData> groups = [];
          
          for (var item in jsonData['groups']) {
            groups.add(GroupData(
              id: item['id']?.toString() ?? '',
              groupId: item['production_group_generate_id']?.toString() ?? 'ID_${item['id']}',
              groupName: item['group_name'] ?? 'Group name',
              status: item['group_status'] ?? 'Completed',
              date: _formatDate(item['updated_at']),
              groupQty: item['group_Qty'] ?? 0,
              allocatedQty: item['allocated_qty'] ?? 0,
              progress: 100, // Completed groups are always 100%
            ));
          }
          
          setState(() {
            _groups = groups;
            _isLoading = false;
          });
        } else {
          setState(() {
            _groups = [];
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _groups = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching completed groups: $e');
      setState(() {
        _groups = [];
        _isLoading = false;
      });
    }
  }

  // Format date from API response
  String _formatDate(String? dateString) {
    if (dateString == null) return '';
    
    try {
      DateTime date = DateTime.parse(dateString);
      return '${_getMonthName(date.month)} ${date.day}, ${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  String _getMonthName(int month) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month];
  }

  // Handle search changes
  void _onSearchChanged() {
    String searchQuery = _searchController.text.trim();
    
    // Debounce search to avoid too many API calls
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_searchController.text.trim() == searchQuery) {
        _fetchGroups(searchQuery: searchQuery.isNotEmpty ? searchQuery : null);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => _onSearchChanged(),
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontWeight: FontWeight.w500,
                    fontFamily: AppStyles.fontFamily,
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
              ),
            ),
          ),

          // Completed Status Indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Text(
                  'Completed',
                  style: AppStyles.bodyMedium.copyWith(
                    color: Colors.green,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Orders List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _groups.isEmpty
                    ? const Center(
                        child: Text(
                          'No completed groups found',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: AppStyles.fontFamily,
                            color: Colors.black,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: _groups.length,
                        itemBuilder: (context, index) {
                          final group = _groups[index];
                          return _buildOrderCard(
                            context: context,
                            group: group,
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard({
    required BuildContext context,
    required GroupData group,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Group ID : ${group.groupId}',
                  style: AppStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    fontFamily: AppStyles.fontFamily,
                    fontSize: 18,
                  ),
                ),
                Text(
                  group.date,
                  style: AppStyles.bodySmall.copyWith(
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              group.groupName,
              style: AppStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
                fontFamily: AppStyles.fontFamily,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status',
                      style: AppStyles.bodySmall.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          width: 100,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '100%',
                          style: AppStyles.bodySmall.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  height: 40,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupDetailsScreen(
                            groupId: group.groupId,
                            groupName: group.groupName,
                            status: group.status,
                          ),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.black),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                    ),
                    child: Text(
                      'View Details',
                      style: AppStyles.bodySmall.copyWith(
                        color: AppColors.textPrimary,
                        fontFamily: AppStyles.fontFamily,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GroupData {
  final String id;
  final String groupId;
  final String groupName;
  final String status;
  final String date;
  final int groupQty;
  final int allocatedQty;
  final int progress;

  GroupData({
    required this.id,
    required this.groupId,
    required this.groupName,
    required this.status,
    required this.date,
    required this.groupQty,
    required this.allocatedQty,
    required this.progress,
  });
}