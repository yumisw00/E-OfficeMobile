import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/surat_model.dart';
import '../../core/network/api_endpoints.dart';

abstract class SuratRepository {
  Future<PimpinanDashboard> getDashboard();
  Future<List<SuratModel>> getMyActions({int page = 1, int pageSize = 15});
  Future<List<TimelineEvent>> getTracking(String id, String? actionType);
  Future<void> approveSurat(String id);
  Future<void> rejectSurat(String id, String reason);
  Future<Map<String, dynamic>> signSurat(String id, {required String signatureData});
  Future<void> completeDisposisi(String id, {required String catatan, String? fileBuktiPath});
  Future<Map<String, dynamic>> uploadAttachment(String id, dynamic file);
  
  // Notifikasi
  Future<List<dynamic>> getNotifications({int page = 1, int perPage = 15});
  Future<void> markNotificationRead(String id);
  Future<void> markAllNotificationsRead();

  // Detail
  Future<SuratModel?> getSuratMasukDetail(String id);
  Future<SuratModel?> getSuratKeluarDetail(String id);
}

class ApiSuratRepository implements SuratRepository {
  final Dio _dio;

  ApiSuratRepository(this._dio);

  @override
  Future<PimpinanDashboard> getDashboard() async {
    try {
      final response = await _dio.get(ApiEndpoints.pimpinanDashboard);
      return PimpinanDashboard.fromJsonApi(response.data);
    } catch (e) {
      if (kDebugMode) print('❌ GetDashboard Error: $e');
      rethrow;
    }
  }

  @override
  Future<List<SuratModel>> getMyActions({int page = 1, int pageSize = 15}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.myActions,
        queryParameters: {'page': page, 'page_size': pageSize},
      );
      
      final rawData = response.data;
      List<dynamic> listData = [];

      if (rawData is Map<String, dynamic>) {
        if (rawData['data'] is List) {
          listData = rawData['data'];
        } else if (rawData['items'] is List) {
          listData = rawData['items'];
        } else if (rawData['results'] is List) {
          listData = rawData['results'];
        }
      } else if (rawData is List) {
        listData = rawData;
      }

      return listData.map((json) => SuratModel.fromJsonApi(json)).toList();
    } catch (e) {
      if (kDebugMode) print('❌ GetMyActions Error: $e');
      rethrow;
    }
  }

  @override
  Future<List<TimelineEvent>> getTracking(String id, String? actionType) async {
    try {
      final endpoint = ApiEndpoints.tracking(id);
      final response = await _dio.get(endpoint);
      
      final rawData = response.data;
      List<dynamic> listData = [];

      if (rawData is Map<String, dynamic>) {
        if (rawData['data'] is List) {
          listData = rawData['data'];
        } else if (rawData['timeline'] is List) {
          listData = rawData['timeline'];
        } else if (rawData['history'] is List) {
          listData = rawData['history'];
        }
      } else if (rawData is List) {
        listData = rawData;
      }

      return listData.map((json) => TimelineEvent.fromJsonApi(json)).toList();
    } catch (e) {
      if (kDebugMode) print('❌ GetTracking Error: $e');
      return [];
    }
  }

  @override
  Future<void> approveSurat(String id) async {
    await _dio.post(ApiEndpoints.suratKeluarApprove(id));
  }

  @override
  Future<void> rejectSurat(String id, String reason) async {
    await _dio.post(
      ApiEndpoints.suratKeluarReject(id),
      data: {'reason': reason},
    );
  }

  @override
  Future<Map<String, dynamic>> signSurat(String id, {required String signatureData}) async {
    final response = await _dio.post(
      ApiEndpoints.suratKeluarSign(id),
      data: {'signature': signatureData},
    );
    return response.data is Map<String, dynamic> ? response.data : {'message': 'Success'};
  }

  @override
  Future<void> completeDisposisi(String id, {required String catatan, String? fileBuktiPath}) async {
    final formData = FormData.fromMap({
      'catatan': catatan,
      if (fileBuktiPath != null)
        'file_bukti': await MultipartFile.fromFile(fileBuktiPath),
    });

    await _dio.post(
      ApiEndpoints.disposisiComplete(id),
      data: formData,
    );
  }

  @override
  Future<Map<String, dynamic>> uploadAttachment(String id, dynamic file) async {
    String? filePath;
    if (file is String) {
      filePath = file;
    }
    
    final formData = FormData.fromMap({
      if (filePath != null) 'file': await MultipartFile.fromFile(filePath),
    });

    final response = await _dio.post(
      ApiEndpoints.disposisiUploadAttachment(id),
      data: formData,
    );
    return response.data is Map<String, dynamic> ? response.data : {};
  }

  @override
  Future<List<dynamic>> getNotifications({int page = 1, int perPage = 15}) async {
    final response = await _dio.get(
      ApiEndpoints.notifications,
      queryParameters: {'page': page, 'per_page': perPage},
    );
    return response.data['data'] as List? ?? [];
  }

  @override
  Future<void> markNotificationRead(String id) async {
    await _dio.patch(ApiEndpoints.notificationMarkRead(id));
  }

  @override
  Future<void> markAllNotificationsRead() async {
    await _dio.post(ApiEndpoints.notificationsMarkAllRead);
  }

  @override
  Future<SuratModel?> getSuratMasukDetail(String id) async {
    try {
      final response = await _dio.get(ApiEndpoints.suratMasukDetail(id));
      final data = response.data['data'] ?? response.data;
      if (data != null && data is Map<String, dynamic>) {
        return SuratModel.fromJsonApi(data);
      }
      return null;
    } catch (e) {
      if (kDebugMode) print('❌ GetSuratMasukDetail Error: $e');
      return null;
    }
  }

  @override
  Future<SuratModel?> getSuratKeluarDetail(String id) async {
    try {
      final response = await _dio.get(ApiEndpoints.suratKeluarDetail(id));
      final data = response.data['data'] ?? response.data;
      if (data != null && data is Map<String, dynamic>) {
        return SuratModel.fromJsonApi(data);
      }
      return null;
    } catch (e) {
      if (kDebugMode) print('❌ GetSuratKeluarDetail Error: $e');
      return null;
    }
  }
}
