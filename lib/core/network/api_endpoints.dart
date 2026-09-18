import '../constants/app_config.dart';

class ApiEndpoints {
  // Auth endpoints
  static const String login = '/mobile/login'; // FIXED PER USER REAL EXPERIENCE
  static const String logout = '/logout';
  static const String verifyMfa = '/verify-mfa';

  // User endpoint
  static const String user = '/user';

  // FCM registration - BUTUH-BACKEND
  static const String registerFcm = '/register-fcm';

  // Surat Masuk endpoints - ADJUSTED PER REAL WEB LOGS
  static const String suratMasukList = '/surat_masuk/master-data';
  static String suratMasukDetail(String id) => '/surat_masuk/$id';
  static String suratMasukTimeline(String id) => '/surat_masuk/$id/timeline';
  static const String suratMasukSummary = '/surat_masuk/summary';

  // Surat Keluar endpoints
  static const String suratKeluarList = '/surat_keluar';
  static String suratKeluarDetail(String id) => '/surat_keluar/$id';
  static String suratKeluarSubmit(String id) => '/surat_keluar/$id/submit';
  static String suratKeluarApprove(String id) => '/surat_keluar/$id/approve';
  static String suratKeluarReject(String id) => '/surat_keluar/$id/reject';
  static String suratKeluarSign(String id) => '/surat_keluar/$id/sign';
  static String suratKeluarSend(String id) => '/surat_keluar/$id/send';
  static String suratKeluarArchive(String id) => '/surat_keluar/$id/archive';
  static String suratKeluarTimeline(String id) => '/surat_keluar/$id/timeline';

  // Approval queue endpoint - ADJUSTED PER REAL WEB LOGS
  static const String approvalQueue = '/surat_approval';

  // Disposisi endpoints - ADJUSTED PER REAL WEB LOGS
  static const String disposisiList = '/surat_disposisi';
  static String disposisiDetail(String id) => '/surat_disposisi/$id';

  // Disposisi upload attachment
  static String disposisiUploadAttachment(String id) => '/surat_disposisi/$id/upload-attachment';

  // Disposisi complete
  static String disposisiComplete(String id) => '/surat_disposisi/$id/complete';

  // Disposisi forward - BUTUH-BACKEND
  static String disposisiForward(String id) => '/surat_disposisi/$id/forward';

  // Disposisi create - BUTUH-BACKEND
  static const String disposisiCreate = '/surat_disposisi'; // POST

  // Notifications
  static const String notifications = '/eoffice/notifications';
  static String notificationMarkRead(String id) => '/eoffice/notifications/$id/read';
  static const String notificationsMarkAllRead = '/eoffice/notifications/read-all';

  // File storage endpoint
  static String getFile(String path) => '/storage/$path';

  static String buildStorageUrl(String filePath) {
    if (filePath.startsWith('http://') || filePath.startsWith('https://')) {
      return filePath;
    }
    final cleanPath = filePath.startsWith('/') ? filePath.substring(1) : filePath;
    final base = AppConfig.baseUrl.endsWith('/')
        ? AppConfig.baseUrl.substring(0, AppConfig.baseUrl.length - 1)
        : AppConfig.baseUrl;
    return '$base/storage/$cleanPath';
  }

  // Upload endpoint
  static const String uploadFile = '/upload';
  static const String digitalSignatureVerify = '/digital-signature/verify';
  ApiEndpoints._();
}
