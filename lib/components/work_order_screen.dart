import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../style/app_colors.dart';
import '../style/app_styles.dart';
import '../services/api_service.dart'; // Your ApiService

class WorkOrderScreen extends StatefulWidget {
  const WorkOrderScreen({super.key});

  @override
  State<WorkOrderScreen> createState() => _WorkOrderScreenState();
}

class _WorkOrderScreenState extends State<WorkOrderScreen> {
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  
  // API data
  List<String> _workOrderStatuses = [];
  List<WorkOrderData> _workOrders = [];
  bool _isLoading = true;
  bool _isLoadingOrders = true;

  @override
  void initState() {
    super.initState();
    _fetchWorkOrderStatuses();
    _fetchWorkOrders();
  }

  // Fetch work order statuses from API
  Future<void> _fetchWorkOrderStatuses() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final headers = await ApiService.headers;
      final response = await http.get(
        Uri.parse(ApiService.workOrderStatus),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        if (jsonData['status'] == 'success' && jsonData['data'] != null) {
          List<String> statuses = [];
          
          for (var item in jsonData['data']) {
            if (item['work_order_status'] != null) {
              String status = item['work_order_status'].toString();
              if (!statuses.contains(status)) {
                statuses.add(status);
              }
            }
          }
          
          setState(() {
            _workOrderStatuses = statuses;
            _isLoading = false;
          });
        } else {
          setState(() {
            _workOrderStatuses = [];
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _workOrderStatuses = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _workOrderStatuses = [];
        _isLoading = false;
      });
    }
  }

  // Fetch work orders from API
  Future<void> _fetchWorkOrders({String? searchQuery, String? progressFilter}) async {
    try {
      setState(() {
        _isLoadingOrders = true;
      });

      final headers = await ApiService.headers;
      
      // Build query parameters
      String url = '${ApiService.baseUrl}/production-schedule/employee/work-order-schedule';
      List<String> queryParams = [];
      
      if (progressFilter != null && progressFilter.isNotEmpty && progressFilter != 'All') {
        queryParams.add('progress=$progressFilter');
      }
      
      if (searchQuery != null && searchQuery.isNotEmpty) {
        queryParams.add('search=$searchQuery');
      }
      
      if (queryParams.isNotEmpty) {
        url += '?${queryParams.join('&')}';
      }

      print('Fetching work orders from: $url');
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      print("Work Orders Status Code: ${response.statusCode}");
      
      if (response.statusCode == 200) {
        print('Work Orders Response: ${response.body}');
        final jsonData = json.decode(response.body);
        
        if (jsonData['success'] == true && jsonData['data'] != null) {
          List<WorkOrderData> orders = [];
          
          for (var item in jsonData['data']) {
            orders.add(WorkOrderData(
              id: item['work_generate_id'] ?? '',
              sku: item['sku_name'] ?? '',
              title: item['description'] ?? '',
              priority: item['priority'] ?? 'Low',
              progress: _getProgressPercentage(item['progress']), // Static progress for now
              status: item['progress'] ?? 'Pending',
              date: _formatDate(item['edd']),
            ));
          }
          
          setState(() {
            _workOrders = orders;
            _isLoadingOrders = false;
          });
        } else {
          setState(() {
            _workOrders = [];
            _isLoadingOrders = false;
          });
        }
      } else {
        setState(() {
          _workOrders = [];
          _isLoadingOrders = false;
        });
      }
    } catch (e) {
      print('Error fetching work orders: $e');
      setState(() {
        _workOrders = [];
        _isLoadingOrders = false;
      });
    }
  }

  // Static progress percentage mapping since progress values are not available yet
  int _getProgressPercentage(String? status) {
    switch (status) {
      case 'Completed':
        return 100;
      case 'Board Stage':
      case 'Finish Stage':
        return 75;
      case 'Production Planned':
        return 50;
      case 'Raw Material Allocation':
        return 30;
      case 'Invoiced':
        return 90;
      case 'Pending':
      default:
        return 20;
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

  // Get filter options: All + all work_order_status values from API
  // If API fails, just show "All"
  List<String> get _filterOptions {
    List<String> filters = ['All'];
    if (_workOrderStatuses.isNotEmpty) {
      filters.addAll(_workOrderStatuses);
    }
    return filters;
  }

  List<WorkOrderData> get _filteredOrders {
    // Return API data directly - no local filtering needed
    return _workOrders;
  }

  // Handle search and filter changes
  void _onSearchOrFilterChanged() {
    String searchQuery = _searchController.text.trim();
    String progressFilter = _selectedFilter;
    
    // Fetch new data from API with current search and filter
    _fetchWorkOrders(
      searchQuery: searchQuery.isNotEmpty ? searchQuery : null,
      progressFilter: progressFilter != 'All' ? progressFilter : null,
    );
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
          _buildSearchBar(),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            )
          else
            _buildFilterTabs(),
          Expanded(
            child: _isLoadingOrders 
              ? const Center(child: CircularProgressIndicator())
              : _buildOrdersList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
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
          onChanged: (value) {
            // Debounce search to avoid too many API calls
            Future.delayed(const Duration(milliseconds: 500), () {
              if (_searchController.text == value) {
                _onSearchOrFilterChanged();
              }
            });
          },
          decoration: InputDecoration(
            hintText: 'Search',
            hintStyle: TextStyle(
              color: Colors.black.withOpacity(0.5),
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
    );
  }

  Widget _buildFilterTabs() {
    final filters = _filterOptions;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: 30,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: filters.length,
          itemBuilder: (context, index) {
            final filter = filters[index];
            final isSelected = _selectedFilter == filter;
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedFilter = filter;
                  });
                  _onSearchOrFilterChanged();
                },
                child: Container(
                 
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 0,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.orange : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? Colors.orange : Colors.grey.shade300,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      filter,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppStyles.fontFamily,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrdersList() {
    final filteredOrders = _filteredOrders;
    
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        return _buildOrderCard(filteredOrders[index]);
      },
    );
  }

  Widget _buildOrderCard(WorkOrderData order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          // First Row: Work Order ID & Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.id,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontFamily: AppStyles.fontFamily,
                ),
              ),
              Text(
                order.date,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontFamily: AppStyles.fontFamily,
                ),
              ),
            ],
          ),
          
          // Second Row: SKU
          if (order.sku.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'SKU #${order.sku}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontFamily: AppStyles.fontFamily,
              ),
            ),
          ],
          
          // Third Row: Priority Label & Progress Bar
          const SizedBox(height: 12),
          Row(
            children: [
              // Priority Label
              Text(
                'Priority',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontFamily: AppStyles.fontFamily,
                ),
              ),
              const SizedBox(width: 16),
              // Progress Bar
              Expanded(
                child: LinearProgressIndicator(
                  value: order.progress / 100,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getProgressColor(order.progress),
                  ),
                  minHeight: 6,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${order.progress}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontFamily: AppStyles.fontFamily,
                ),
              ),
            ],
          ),
          
          // Fourth Row: Status & Priority Value
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getPriorityColor(order.priority),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  order.priority,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontFamily: AppStyles.fontFamily,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(order.status),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  order.status,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontFamily: AppStyles.fontFamily,
                  ),
                ),
              )
              
            ],
          ),
        ],
      ),
    );
  }

  Color _getProgressColor(int progress) {
    if (progress >= 100) return Colors.green;
    if (progress >= 60) return Colors.red;
    if (progress >= 40) return Colors.orange;
    return Colors.grey;
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'low':
        return Colors.red;
      case 'high':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'Pending':
        return Colors.red;
      case 'Invoiced':
        return Colors.orange;
      case 'Raw Material Allocation':
        return Colors.blue;
      case 'Production Planned':
        return Colors.purple;
      case 'Board Stage':
        return Colors.indigo;
      case 'Finish Stage':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
}

class WorkOrderData {
  final String id;
  final String sku;
  final String title;
  final String priority;
  final int progress;
  final String status;
  final String date;

  WorkOrderData({
    required this.id,
    required this.sku,
    required this.title,
    required this.priority,
    required this.progress,
    required this.status,
    required this.date,
  });
}