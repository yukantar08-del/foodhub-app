import 'package:flutter/material.dart';
import 'models.dart';
import 'services/demo_store.dart';

void main() {
  runApp(const FoodHubApp());
}

class FoodHubApp extends StatelessWidget {
  const FoodHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FoodHub',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepOrange,
        brightness: Brightness.light,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: const RoleSelector(),
    );
  }
}

class RoleSelector extends StatelessWidget {
  const RoleSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final roles = UserRole.values;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.local_shipping_rounded, size: 64),
              const SizedBox(height: 16),
              Text('FoodHub',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  )),
              const SizedBox(height: 8),
              Text('Satu aplikasi • empat role • satu alur pesanan',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 32),
              ...roles.map((role) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                  ),
                  icon: Icon(_icon(role)),
                  label: Text(_label(role)),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RoleDashboard(role: role),
                    ),
                  ),
                ),
              )),
              const Spacer(),
              Center(child: Text('FoodHub v0.6 Prototype')),
            ],
          ),
        ),
      ),
    );
  }

  static String _label(UserRole r) => switch (r) {
    UserRole.customer => 'Customer',
    UserRole.merchant => 'Merchant',
    UserRole.driver => 'Driver',
    UserRole.admin => 'Admin',
  };

  static IconData _icon(UserRole r) => switch (r) {
    UserRole.customer => Icons.person_rounded,
    UserRole.merchant => Icons.storefront_rounded,
    UserRole.driver => Icons.two_wheeler_rounded,
    UserRole.admin => Icons.admin_panel_settings_rounded,
  };
}

class RoleDashboard extends StatelessWidget {
  final UserRole role;
  const RoleDashboard({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: DemoStore.instance,
      builder: (_, __) => Scaffold(
        appBar: AppBar(
          title: Text('${RoleSelector._label(role)} Dashboard'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_rounded),
            ),
          ],
        ),
        body: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _header(context),
        const SizedBox(height: 18),
        if (DemoStore.instance.activeOrder != null) _orderCard(context),
        const SizedBox(height: 18),
        ..._actions(context),
      ],
    );
  }

  Widget _header(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(radius: 28, child: Icon(RoleSelector._icon(role))),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'FoodHub ${RoleSelector._label(role)}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _orderCard(BuildContext context) {
    final o = DemoStore.instance.activeOrder!;
    final visible = switch (role) {
      UserRole.customer => o.customerTotal,
      UserRole.merchant => o.itemTotal,
      UserRole.driver => o.deliveryFee,
      UserRole.admin => o.customerTotal,
    };
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(o.id,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    )),
                const Spacer(),
                Chip(label: Text(o.status.name)),
              ],
            ),
            const SizedBox(height: 8),
            Text('Merchant: ${o.merchantName}'),
            if (o.driverName != null) Text('Driver: ${o.driverName}'),
            const SizedBox(height: 8),
            Text('Nilai role ini: Rp$visible'),
          ],
        ),
      ),
    );
  }

  List<Widget> _actions(BuildContext context) {
    switch (role) {
      case UserRole.customer:
        return [
          _action(context, Icons.shopping_bag_rounded, 'Buat Pesanan',
              () => DemoStore.instance.createDemoOrder()),
          _action(context, Icons.payment_rounded, 'Pembayaran',
              () => _snack(context, 'Payment module siap diintegrasikan')),
          _action(context, Icons.chat_rounded, 'Chat',
              () => _snack(context, 'Chat realtime siap diintegrasikan')),
          _action(context, Icons.map_rounded, 'Tracking Driver',
              () => _snack(context, 'Google Maps + GPS siap diintegrasikan')),
        ];
      case UserRole.merchant:
        return [
          _action(context, Icons.check_circle_rounded, 'Terima Pesanan',
              DemoStore.instance.merchantAccept),
          _action(context, Icons.restaurant_rounded, 'Mulai Siapkan',
              DemoStore.instance.startPreparing),
          _action(context, Icons.inventory_2_rounded, 'Pesanan Siap',
              DemoStore.instance.markReady),
          _action(context, Icons.receipt_long_rounded, 'Cetak Struk',
              () => _snack(context, 'Struk siap dicetak')),
        ];
      case UserRole.driver:
        return [
          _action(context, Icons.near_me_rounded, 'Ambil/Tugaskan Order',
              DemoStore.instance.assignDriver),
          _action(context, Icons.photo_camera_rounded, 'Konfirmasi Pickup + Foto Struk',
              DemoStore.instance.pickup),
          _action(context, Icons.navigation_rounded, 'Mulai Antar',
              DemoStore.instance.onTheWay),
          _action(context, Icons.verified_rounded, 'Selesai + Bukti Penerimaan',
              DemoStore.instance.delivered),
        ];
      case UserRole.admin:
        return [
          _action(context, Icons.dashboard_rounded, 'Monitor Semua Order',
              () => _snack(context, 'Admin melihat seluruh order')),
          _action(context, Icons.map_rounded, 'Live Driver Map',
              () => _snack(context, 'Live map siap diintegrasikan')),
          _action(context, Icons.account_balance_wallet_rounded, 'Keuangan',
              () => _snack(context, 'Dashboard payment & earnings')),
          _action(context, Icons.analytics_rounded, 'Laporan',
              () => _snack(context, 'Analytics module siap')),
        ];
    }
  }

  Widget _action(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: ListTile(
          leading: CircleAvatar(child: Icon(icon)),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: onTap,
        ),
      ),
    );
  }

  void _snack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
