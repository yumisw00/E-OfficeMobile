import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/providers/surat_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/custom_card.dart';

class ApprovalScreen extends ConsumerStatefulWidget {
  const ApprovalScreen({super.key});

  @override
  ConsumerState<ApprovalScreen> createState() => _ApprovalScreenState();
}

class _ApprovalScreenState extends ConsumerState<ApprovalScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(myActionsProvider.notifier).fetchMyActions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(myActionsProvider);
    final topPadding = MediaQuery.of(context).padding.top + kToolbarHeight + 16.0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(title: 'Antrian Persetujuan'),
      body: RefreshIndicator(
        edgeOffset: topPadding,
        onRefresh: () async => ref.read(myActionsProvider.notifier).fetchMyActions(),
        child: provider.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => EmptyStateView(
            message: 'Gagal memuat antrian: $err',
            icon: Icons.info_outline_rounded,
          ),
          data: (queueList) {
            final approvalTasks = queueList.where((item) => item.actionType == 'approval').toList();

            if (approvalTasks.isEmpty) {
              return const EmptyStateView(
                message: 'Tidak ada surat yang menunggu persetujuan.',
                icon: Icons.check_circle_outline_rounded,
              );
            }

            return ListView.builder(
              padding: EdgeInsets.fromLTRB(16.0, topPadding, 16.0, 100.0),
              itemCount: approvalTasks.length,
              itemBuilder: (context, index) {
                final item = approvalTasks[index];
                final status = item.status.toLowerCase();
                final isApproved = status == 'approved';

                return CustomCard(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  onTap: () => context.push('/surat-masuk/${item.id}', extra: 'approval'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.perihal,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const Divider(height: 24),
                      Text('Nomor: ${item.nomorSurat}'),
                      Text('Pengaju: ${item.pemohon ?? '-'}'),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (isApproved)
                            ElevatedButton.icon(
                              onPressed: () => context.push('/surat-masuk/${item.id}', extra: 'approval'),
                              icon: const Icon(Icons.draw_outlined),
                              label: const Text('Buka untuk Tanda Tangan'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal.shade700,
                                foregroundColor: Colors.white,
                              ),
                            )
                          else ...[
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Theme.of(context).colorScheme.error,
                                side: BorderSide(color: Theme.of(context).colorScheme.error),
                              ),
                              onPressed: () => context.push('/surat-masuk/${item.id}', extra: 'approval'),
                              child: const Text('Detail / Tolak'),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: () => context.push('/surat-masuk/${item.id}', extra: 'approval'),
                              child: const Text('Setujui'),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
