import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import '../../core/constants/app_config.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/network/dio_client.dart';
import '../../data/models/surat_model.dart';
import '../../domain/providers/surat_provider.dart';
import '../widgets/signature_pad.dart';
import '../widgets/custom_app_bar.dart';

class DetailSuratScreen extends ConsumerStatefulWidget {
  final String idSurat;
  final String? actionType;

  const DetailSuratScreen({
    super.key,
    required this.idSurat,
    this.actionType,
  });

  @override
  ConsumerState<DetailSuratScreen> createState() => _DetailSuratScreenState();
}

class _DetailSuratScreenState extends ConsumerState<DetailSuratScreen> {
  String? _authToken;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final storage = ref.read(secureStorageProvider);
    _authToken = await storage.read(key: AppConfig.authTokenKey);
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(suratDetailProvider((id: widget.idSurat, type: widget.actionType)));
    final trackingAsync = ref.watch(trackingProvider((id: widget.idSurat, type: widget.actionType)));
    final topPadding = MediaQuery.of(context).padding.top + kToolbarHeight + 16.0;

    return detailAsync.when(
      loading: () => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: const CustomAppBar(title: 'Memuat Detail...'),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, st) {
        final isPermissionError = err.toString().contains('PERM_403');
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: const CustomAppBar(title: 'Detail Surat'),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isPermissionError ? Icons.lock_person_rounded : Icons.error_outline_rounded,
                    size: 64,
                    color: isPermissionError ? Colors.orange : Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isPermissionError ? 'Akses Ditolak' : 'Terjadi Kesalahan',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isPermissionError 
                      ? 'Akun grup Pimpinan belum diberi izin (permission) untuk mengakses fitur detail surat ini. Silakan hubungi admin sistem.'
                      : err.toString().replaceAll('Exception: ', ''),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  if (!isPermissionError) ...[
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(suratDetailProvider((id: widget.idSurat, type: widget.actionType))),
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
      data: (currentSurat) {
        if (currentSurat == null) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: const CustomAppBar(title: 'Detail Surat'),
            body: const Center(child: Text('Data surat tidak ditemukan')),
          );
        }

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: CustomAppBar(
            title: currentSurat.nomorSurat,
          ),
          body: RefreshIndicator(
            edgeOffset: topPadding,
            onRefresh: () async {
              ref.invalidate(suratDetailProvider((id: widget.idSurat, type: widget.actionType)));
              ref.invalidate(trackingProvider((id: widget.idSurat, type: widget.actionType)));
              await ref.read(myActionsProvider.notifier).refresh();
              HapticFeedback.mediumImpact();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(16.0, topPadding, 16.0, 120.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildMetadataCard(context, currentSurat),
                  const SizedBox(height: 16),
                  trackingAsync.when(
                    data: (events) => _buildTrackingCard(context, currentSurat, events),
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (err, st) => Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('Gagal memuat riwayat: $err'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMetadataCard(BuildContext context, SuratModel surat) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Chip(
                  label: Text(surat.actionType?.toUpperCase() ?? 'SURAT'),
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  DateFormat('dd MMM yyyy').format(surat.tanggalDiterima),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              surat.perihal,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 24),
            _infoRow('Nomor Surat', surat.nomorSurat),
            _infoRow('Asal Surat', surat.asalSurat),
            _infoRow('Pengaju', surat.pemohon ?? '-'),
            _infoRow('Status', surat.status),
            if (surat.activeFilePath != null && surat.activeFilePath!.isNotEmpty) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    context.push('/pdf', extra: surat.activeFilePath);
                  },
                  icon: const Icon(Icons.picture_as_pdf_rounded),
                  label: const Text('Buka Dokumen PDF'),
                ),
              ),
            ],
            // Aksi tombol Approval / Disposisi
            const SizedBox(height: 20),
            _buildActionSection(context, surat),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13))),
          const Text(': ', style: TextStyle(color: Colors.grey)),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13))),
        ],
      ),
    );
  }

  Widget _buildActionSection(BuildContext context, SuratModel surat) {
    final isApproval = surat.actionType == 'approval';
    final status = surat.status.toLowerCase();

    if (isApproval) {
      if (status == 'approved') {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal.shade700, foregroundColor: Colors.white),
            onPressed: () {
              HapticFeedback.mediumImpact();
              _showSignPad(context, surat);
            },
            icon: const Icon(Icons.draw_rounded),
            label: const Text('Tanda Tangan Digital (Sign)'),
          ),
        );
      } else {
        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                  side: BorderSide(color: Theme.of(context).colorScheme.error),
                ),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  _showRejectDialog(context, surat);
                },
                child: const Text('Tolak'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  _showApproveConfirm(context, surat);
                },
                child: const Text('Setujui'),
              ),
            ),
          ],
        );
      }
    } else {
      // Disposisi
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            HapticFeedback.mediumImpact();
            _showCompleteDisposisiDialog(context, surat);
          },
          icon: const Icon(Icons.check_circle_outline_rounded),
          label: const Text('Selesaikan Disposisi'),
        ),
      );
    }
  }

  Widget _buildTrackingCard(BuildContext context, SuratModel surat, List<TimelineEvent> events) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Riwayat / Tracking', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Divider(height: 20),
            if (events.isEmpty)
              const Text('Belum ada riwayat tracking.', style: TextStyle(color: Colors.grey))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: index == 0 ? Theme.of(context).colorScheme.primary : Colors.grey.shade400,
                              ),
                            ),
                            if (index < events.length - 1)
                              Container(
                                width: 2,
                                height: 35,
                                color: Colors.grey.shade300,
                              ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(event.status, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              const SizedBox(height: 2),
                              if (event.catatan != null && event.catatan!.isNotEmpty)
                                Text(event.catatan!, style: const TextStyle(fontSize: 12)),
                              Text(
                                '${event.pelaku} • ${DateFormat('dd/MM/yy HH:mm').format(event.tanggal)}',
                                style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  // --- ACTIONS ---

  void _showApproveConfirm(BuildContext context, SuratModel surat) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Setujui Surat'),
        content: Text('Apakah Anda yakin ingin menyetujui surat nomor ${surat.nomorSurat}?'),
        actions: [
          TextButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              context.pop();
            },
            child: const Text('Tidak'),
          ),
          ElevatedButton(
            onPressed: () async {
              HapticFeedback.mediumImpact();
              context.pop();
              try {
                await ref.read(suratRepositoryProvider).approveSurat(surat.id);
                if (context.mounted) {
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Surat berhasil disetujui. Silakan lakukan tanda tangan digital.')));
                   ref.read(myActionsProvider.notifier).refresh();
                }
              } catch (e) {
                if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: $e')));
              }
            },
            child: const Text('Setujui'),
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(BuildContext context, SuratModel surat) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tolak Surat'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Catatan Revisi', border: OutlineInputBorder()),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              context.pop();
            },
            child: const Text('Tidak'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error, foregroundColor: Colors.white),
            onPressed: () async {
              if (controller.text.isEmpty) return;
              HapticFeedback.mediumImpact();
              context.pop();
              try {
                await ref.read(suratRepositoryProvider).rejectSurat(surat.id, controller.text);
                if (context.mounted) {
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Surat berhasil ditolak.')));
                   ref.read(myActionsProvider.notifier).refresh();
                }
              } catch (e) {
                if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: $e')));
              }
            },
            child: const Text('Tolak'),
          ),
        ],
      ),
    );
  }

  void _showCompleteDisposisiDialog(BuildContext context, SuratModel surat) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selesaikan Disposisi'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Catatan Penyelesaian', border: OutlineInputBorder()),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              context.pop();
            },
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isEmpty) return;
              HapticFeedback.mediumImpact();
              context.pop();
              try {
                await ref.read(suratRepositoryProvider).completeDisposisi(surat.id, catatan: controller.text);
                if (context.mounted) {
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Disposisi berhasil diselesaikan.')));
                   ref.read(myActionsProvider.notifier).refresh();
                }
              } catch (e) {
                if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: $e')));
              }
            },
            child: const Text('Selesaikan'),
          ),
        ],
      ),
    );
  }

  void _showSignPad(BuildContext context, SuratModel surat) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SignaturePad(
          onSaved: (signatureBase64) async {
            HapticFeedback.mediumImpact();
            context.pop();
            try {
              await ref.read(myActionsProvider.notifier).signSurat(surat.id, signatureBase64);
              if (context.mounted) {
                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tanda tangan digital berhasil disimpan.')));
                 ref.read(myActionsProvider.notifier).refresh();
              }
            } catch (e) {
              if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal Tanda Tangan: $e')));
            }
          },
        ),
      ),
    );
  }
}
