/// API Endpoints - Pusat Definisi URL API Backend Laravel
/// Semua endpoint API didefinisikan di sini untuk memudahkan maintenance
class ApiEndpoints {
  // ==================== AUTHENTICATION ====================
  static const String login = '/mobile/login';
  static const String logout = '/mobile/logout';
  static const String user = '/mobile/user';
  static const String registerFcm = '/mobile/register-fcm';

  // ==================== SURAT MASUK ====================
  static const String suratMasukList = '/surat_masuk';
  static String suratMasukDetail(String id) => '/surat_masuk/$id';
  static String suratMasukTimeline(String id) => '/surat_masuk/$id/timeline';
  static const String suratMasukSummary = '/surat_masuk/summary';
  static String suratMasukDistribute(String id) => '/surat_masuk/$id/distribute';
  static String suratMasukRead(String id) => '/surat_masuk/$id/read';
  static String suratMasukDone(String id) => '/surat_masuk/$id/done';
  static String suratMasukArchive(String id) => '/surat_masuk/$id/archive';

  // ==================== SURAT KELUAR ====================
  static const String suratKeluarList = '/surat_keluar';
  static String suratKeluarDetail(String id) => '/surat_keluar/$id';
  static String suratKeluarSubmit(String id) => '/surat_keluar/$id/submit';
  static String suratKeluarApprove(String id) => '/surat_keluar/$id/approve';
  static String suratKeluarReject(String id) => '/surat_keluar/$id/reject';
  static String suratKeluarSign(String id) => '/surat_keluar/$id/sign';
  static String suratKeluarSend(String id) => '/surat_keluar/$id/send';
  static String suratKeluarArchive(String id) => '/surat_keluar/$id/archive';
  static String suratKeluarTimeline(String id) => '/surat_keluar/$id/timeline';

  // ==================== DISPOSISI ====================
  static const String disposisiList = '/surat_disposisi';
  static const String disposisiCreate = '/surat_disposisi';
  static String disposisiDetail(String id) => '/surat_disposisi/$id';
  static String disposisiComplete(String id) => '/surat_disposisi/$id/complete';
  static String disposisiTimeline(String id) => '/surat_disposisi/$id/timeline';

  // ==================== APPROVAL QUEUE ====================
  static const String approvalQueue = '/surat_approval';

  // ==================== FILES & DOCUMENTS ====================
  static String getFile(String path) => '/getfile/$path';
  static const String uploadFile = '/upload';

  // ==================== DIGITAL SIGNATURE ====================
  static const String digitalSignatureVerify = '/digital-signature/verify';

  // Constructor private untuk mencegah instantiasi
  ApiEndpoints._();
}
