import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../core/services/auth_service.dart';
import '../../core/utils/theme.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  void _logout() {
    AuthService.logout();
    Get.offAllNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final user = box.read('user') ?? {};
    final String name = user['name'] ?? 'Admin';
    final String email = user['email'] ?? 'admin@productsphere.com';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.purple.shade700,
        foregroundColor: Colors.white,
        title: const Text(
          'Admin Control Panel',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- ADMIN WELCOME HEADER ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple.shade700, Colors.deepPurple.shade900],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                  boxShadow: [AppTheme.cardShadow],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white.withOpacity(0.25),
                      child: const Icon(
                        Icons.admin_panel_settings_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            email,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // --- STATS GRID ---
              const Text(
                'Platform Overview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: _statCard(
                      label: 'Verified Businesses',
                      value: '184',
                      color: Colors.green,
                      icon: Icons.verified_user_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _statCard(
                      label: 'Pending Approvals',
                      value: '6',
                      color: Colors.orange,
                      icon: Icons.pending_actions_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _statCard(
                      label: 'Active Products',
                      value: '1,492',
                      color: Colors.blue,
                      icon: Icons.grid_view_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _statCard(
                      label: 'Flagged Listings',
                      value: '0',
                      color: Colors.red,
                      icon: Icons.report_problem_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // --- PENDING VERIFICATION LIST ---
              const Text(
                'Pending Business Verifications',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  boxShadow: [AppTheme.cardShadow],
                ),
                child: Column(
                  children: [
                    _verificationItem(
                      businessName: 'Zubair Cloth House',
                      role: 'Wholesaler',
                      docName: 'Tax_Registration_Certificate.pdf',
                    ),
                    const Divider(color: AppTheme.border, height: 24),
                    _verificationItem(
                      businessName: 'Faisalabad Garment Outlet',
                      role: 'Buyer',
                      docName: 'Trade_License_2026.jpg',
                    ),
                    const Divider(color: AppTheme.border, height: 24),
                    _verificationItem(
                      businessName: 'Sialkot Surgical Goods',
                      role: 'Wholesaler',
                      docName: 'ISO_Certificate_Sialkot.pdf',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard({
    required String label,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _verificationItem({
    required String businessName,
    required String role,
    required String docName,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.purple.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(
            role.toLowerCase() == 'wholesaler'
                ? Icons.storefront_outlined
                : Icons.shopping_bag_outlined,
            color: Colors.purple.shade700,
            size: 22,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                businessName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Role: $role  |  Doc: $docName',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.check_circle_outline_rounded, color: Colors.green, size: 22),
              onPressed: () {},
              tooltip: 'Approve',
            ),
            IconButton(
              icon: const Icon(Icons.cancel_outlined, color: Colors.red, size: 22),
              onPressed: () {},
              tooltip: 'Reject',
            ),
          ],
        ),
      ],
    );
  }
}
