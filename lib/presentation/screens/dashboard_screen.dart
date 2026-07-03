import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/providers/surat_provider.dart';
import '../../domain/providers/auth_provider.dart';
import '../widgets/surat_shimmer_list.dart';
import '../widgets/empty_state_view.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suratMasukAsync = ref.watch(suratMasukProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Office Dashboard'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.blue),
              ),
              accountName: const Text(
                'Bpk. Budi Santoso',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: const Text('Direktur Utama'),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Keluar (Logout)',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                // Tutup drawer
                context.pop();
                // Jalankan logout
                ref.read(authProvider.notifier).logout();
                // Arahkan ke login
                context.go('/login');
              },
            ),
          ],
        ),
      ),
      body: suratMasukAsync.when(
        loading: () => const SuratShimmerList(),
        error: (error, stackTrace) => EmptyStateView(
          icon: Icons.error_outline,
          title: 'Terjadi Kesalahan',
          message: 'Gagal memuat data surat: $error',
          onRetry: () => ref.refresh(suratMasukProvider),
        ),
        data: (suratList) {
          if (suratList.isEmpty) {
            return EmptyStateView(
              icon: Icons.inbox_outlined,
              title: 'Kotak Masuk Kosong',
              message: 'Saat ini belum ada surat masuk untuk Anda.',
              onRetry: () => ref.refresh(suratMasukProvider),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: suratList.length,
            itemBuilder: (context, index) {
              final surat = suratList[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.email_outlined),
                  ),
                  title: Text(
                    surat.nomorSurat,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        surat.perihal,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getStatusColor(surat.status).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: _getStatusColor(surat.status),
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          surat.status.replaceAll('_', ' ').toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            color: _getStatusColor(surat.status),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    context.push('/detail', extra: surat);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'belum_dibaca':
        return Colors.blue;
      case 'disposisi':
        return Colors.orange;
      case 'selesai':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
