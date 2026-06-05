import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/surat_model.dart';

class DetailSuratScreen extends StatelessWidget {
  final SuratModel surat;

  const DetailSuratScreen({super.key, required this.surat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(surat.nomorSurat),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMetadataCard(context),
            const SizedBox(height: 16),
            _buildTrackingCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informasi Surat',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _buildInfoRow('Asal Surat', surat.asalSurat),
            _buildInfoRow('Tanggal Diterima', DateFormat('dd MMMM yyyy, HH:mm').format(surat.tanggalDiterima)),
            _buildInfoRow('Perihal', surat.perihal),
            _buildInfoRow('Status', surat.status.replaceAll('_', ' ').toUpperCase(), isStatus: true),
            const SizedBox(height: 8),
            Text(
              'Ringkasan:',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(surat.ringkasan),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isStatus = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isStatus ? _getStatusColor(surat.status) : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tracking Disposisi',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(),
            // Remove const from Stepper as it might conflict with dynamic properties in some versions
            // and removed shrinkWrap which is not a parameter of Stepper
            Stepper(
              physics: const NeverScrollableScrollPhysics(),
              currentStep: 2,
              controlsBuilder: _nullControlsBuilder,
              steps: const [
                Step(
                  title: Text('Diterima Admin'),
                  subtitle: Text('Surat telah diverifikasi oleh bagian umum'),
                  content: SizedBox.shrink(),
                  isActive: true,
                  state: StepState.complete,
                ),
                Step(
                  title: Text('Disposisi Manager'),
                  subtitle: Text('Diteruskan ke Manager Unit untuk arahan'),
                  content: SizedBox.shrink(),
                  isActive: true,
                  state: StepState.complete,
                ),
                Step(
                  title: Text('Menunggu Persetujuan'),
                  subtitle: Text('Sedang dalam tahap review akhir'),
                  content: SizedBox.shrink(),
                  isActive: true,
                  state: StepState.indexed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _nullControlsBuilder(BuildContext context, ControlsDetails details) {
    return const SizedBox.shrink();
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
