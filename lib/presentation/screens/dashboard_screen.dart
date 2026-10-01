import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/providers/auth_provider.dart';
import '../../domain/providers/surat_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/custom_card.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(pimpinanDashboardProvider.notifier).refresh();
      ref.read(myActionsProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final dashboardAsync = ref.watch(pimpinanDashboardProvider);

    String userName = 'User';
    String userRole = 'Pimpinan';
    authState.whenData((user) {
      if (user != null) {
        userName = user.nama;
        userRole = user.role;
      }
    });

    final topPadding = MediaQuery.of(context).padding.top + kToolbarHeight + 16.0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(
        title: 'Dashboard',
      ),
      body: RefreshIndicator(
        edgeOffset: topPadding,
        onRefresh: () async {
          await ref.read(pimpinanDashboardProvider.notifier).refresh();
          await ref.read(myActionsProvider.notifier).refresh();
          HapticFeedback.mediumImpact();
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.0, topPadding, 16.0, 100.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Identity Card
              CustomCard(
                borderRadius: 20,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Icon(Icons.person_outline_rounded, color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selamat Datang,',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            userName,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            userRole,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Statistik Section
              Text(
                'Ringkasan',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              dashboardAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => EmptyStateView(
                  message: 'Gagal memuat statistik: ${err.toString().replaceAll('Exception: ', '')}',
                  icon: Icons.error_outline_rounded,
                ),
                data: (data) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              title: 'Pending Approval',
                              count: data.pendingApproval,
                              icon: Icons.task_alt_rounded,
                              color: const Color(0xFFE67E22),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _StatCard(
                              title: 'Pending Disposisi',
                              count: data.pendingDisposisi,
                              icon: Icons.alt_route_rounded,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _StatCard(
                        title: 'Surat Masuk Bulan Ini',
                        count: data.totalSuratMasukBulanIni,
                        icon: Icons.move_to_inbox_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  );
                },
              ),
              
              const SizedBox(height: 24),

              // Section Tindakan Saya (My Actions)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Menunggu Tindakan',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/surat-masuk'),
                    child: const Text('Lihat Semua'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ref.watch(myActionsProvider).when(
                loading: () => const Center(child: LinearProgressIndicator()),
                error: (err, st) => const Text('Gagal memuat daftar tindakan.'),
                data: (list) {
                  if (list.isEmpty) return const Text('Tidak ada tindakan menunggu');
                  final recent = list.take(5).toList();
                  return Column(
                    children: recent.map((item) => CustomCard(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.zero,
                      onTap: () {
                        context.push('/surat-masuk/${item.id}', extra: item.actionType);
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: item.actionType == 'approval' ? Colors.orange.shade100 : Colors.blue.shade100,
                          child: Icon(
                            item.actionType == 'approval' ? Icons.task_alt_rounded : Icons.alt_route_rounded,
                            size: 20,
                            color: item.actionType == 'approval' ? Colors.orange.shade800 : Colors.blue.shade800,
                          ),
                        ),
                        title: Text(item.perihal, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w500)),
                        subtitle: Text(item.nomorSurat),
                        trailing: const Icon(Icons.chevron_right, size: 16),
                      ),
                    )).toList(),
                  );
                },
              ),

              const SizedBox(height: 24),
              
              // Tombol Aksi Cepat
              Text(
                'Aksi Cepat',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => context.push('/surat-masuk'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Daftar Tindakan'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.push('/notifications'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Notifikasi'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 28),
              Text(
                count.toString(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
