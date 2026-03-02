import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        elevation: 0,
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _buildCard(
            icon: Icons.account_balance_wallet,
            title: 'Wallet',
            color: Colors.blue,
            onTap: () {
              // Handle wallet tap
            },
          ),
          _buildCard(
            icon: Icons.history,
            title: 'History',
            color: Colors.green,
            onTap: () {
              // Handle history tap
            },
          ),
          _buildCard(
            icon: Icons.payment,
            title: 'Payments',
            color: Colors.orange,
            onTap: () {
              // Handle payments tap
            },
          ),
          _buildCard(
            icon: Icons.settings,
            title: 'Settings',
            color: Colors.purple,
            onTap: () {
              // Handle settings tap
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}