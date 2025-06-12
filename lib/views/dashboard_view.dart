import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import '../controllers/auth_controller.dart';
import '../controllers/record_controller.dart';
import '../models/user_model.dart';
import 'record_form_view.dart';
import 'records_table_view.dart';
import 'user_management_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RecordController>(context, listen: false).loadRecords();
    });
  }

  /*Widget _buildUserProfileCard(BuildContext context, User user) {
    return Card(
      elevation: 0,
       color: const Color(0xFFF7F7F7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.shade100,
                  ),
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.blue.shade800,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getRoleColor(user.role).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        user.role.displayName,
                        style: TextStyle(
                          color: _getRoleColor(user.role),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Divider(color: Colors.grey.shade200),
            const SizedBox(height: 12),
            _buildUserInfoRow(Icons.email, user.email),
            const SizedBox(height: 12),
            _buildUserInfoRow(Iconsax.calendar, 
              'Joined ${DateFormat.yMMMd().format(DateTime.now())}'),
            const SizedBox(height: 12),
            _buildUserInfoRow(Iconsax.shield, 
              'Permissions: ${_getPermissions(user.role)}'),
          ],
        ),
      ),
    );
  }*/
  Widget _buildUserProfileCard(BuildContext context, User user) {
  return Card(
    elevation: 0,
    color: const Color(0xFFF7F7F7),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(color: Colors.grey.shade200, width: 1),
    ),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.shade100,
                ),
                child: Icon(
                  Icons.person,
                  size: 30,
                  color: Colors.blue.shade800,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (user.role != UserRole.storeManager)
                    Text(
                      user.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getRoleColor(user.role).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      user.role.displayName,
                      style: TextStyle(
                        color: _getRoleColor(user.role),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (user.role != UserRole.storeManager) ...[
            Divider(color: Colors.grey.shade200),
            const SizedBox(height: 12),
            _buildUserInfoRow(Icons.email, user.email),
            const SizedBox(height: 12),
            _buildUserInfoRow(Iconsax.calendar, 'Joined ${DateFormat.yMMMd().format(DateTime.now())}'),
            const SizedBox(height: 12),
          ],
          _buildUserInfoRow(Iconsax.shield, 'Permissions: ${_getPermissions(user.role)}'),
        ],
      ),
    ),
  );
}

  Widget _buildUserInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blue.shade600),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(color: Colors.grey.shade700),
        ),
      ],
    );
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return Colors.purple;
      case UserRole.storeManager:
        return Colors.blue;
      case UserRole.facilitator:
        return Colors.green;
    }
  }

  String _getPermissions(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return 'Full system access';
      case UserRole.storeManager:
        return 'Create/View records';
      case UserRole.facilitator:
        return 'View assigned records';
    }
  }

  Widget _buildQuickActions(BuildContext context, UserRole role) {
    List<Map<String, dynamic>> actions = [];

    if (role == UserRole.admin || role == UserRole.storeManager) {
      actions.addAll([
        {
          'icon': Iconsax.add,
          'label': 'Add Record',
          'color': Colors.blue,
          'onTap': () {
            showDialog(
              context: context,
              builder: (context) => const RecordFormView(),
            );
          },
        },
      ]);
    }

    if (role == UserRole.admin) {
      actions.addAll([
          {
            'icon': Iconsax.user,
            'label': 'Manage Users',
            'color': Colors.purple,
            'onTap': () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const UserManagementView()),
              );
            },
          },
      ]);
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: actions.map((action) {
        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: action['onTap'],
          child: Container(
            decoration: BoxDecoration(
              color: action['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: action['color'].withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  action['icon'],
                  size: 30,
                  color: action['color'],
                ),
                const SizedBox(height: 8),
                Text(
                  action['label'],
                  style: TextStyle(
                    color: action['color'],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthController>(context);
    final records = Provider.of<RecordController>(context);
    final user = auth.currentUser!;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Malex Management Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.refresh),
            onPressed: () => records.loadRecords(),
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Iconsax.logout),
            onPressed: () => auth.logout(),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: records.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
             
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
              
                children: [
                  Text(
                    user.role == UserRole.storeManager
                        ? 'Welcome back, Store Manager'
                        : 'Welcome back, ${user.name}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Here\'s what\'s happening today',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // User profile and quick actions row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: _buildUserProfileCard(context, user),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            Card(
                              elevation: 0,
                              color: const Color(0xFFF7F7F7), 
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(
                                  color: Colors.grey.shade200, 
                                  width: 1),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                 
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                 
                                  children: [
                                    Text(
                                      'Quick Actions',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 16),
                                    _buildQuickActions(context, user.role),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey.shade200, width: 1),
                    ),
                  child: Container(
                     color: const Color(0xFFF7F7F7),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: RecordsTableView(),
                    ),
                  ),

                  ),
                  const SizedBox(height: 16), 
                ],
              ),
            ),
      floatingActionButton: user.role == UserRole.admin ||
              user.role == UserRole.storeManager
          ? FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const RecordFormView(),
                );
              },
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Iconsax.add),
            )
          : null,
    );
  }
}