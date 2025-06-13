/// Lớp giao diện trừu tượng cho các dịch vụ Socket
abstract class BaseSocketService {
  /// Kiểm tra xem dịch vụ socket đã được khởi tạo chưa
  bool get isInitialized;

  /// Kiểm tra trạng thái kết nối của socket
  bool get isConnected;

  /// Khởi tạo dịch vụ socket
  void init();

  /// Đăng ký lắng nghe một sự kiện socket
  /// [event] tên sự kiện cần lắng nghe
  /// [handler] hàm xử lý khi sự kiện xảy ra
  void on(String event, Function(dynamic) handler);

  /// Hủy đăng ký lắng nghe sự kiện socket
  /// [event] tên sự kiện cần hủy đăng ký
  void off(String event);

  /// Phát sự kiện socket với dữ liệu tùy chọn
  /// [event] tên sự kiện cần phát
  /// [data] dữ liệu gửi kèm sự kiện (tùy chọn)
  void emit(String event, [dynamic data]);

  /// Kết nối lại socket nếu đã mất kết nối
  void reconnect();

  /// Ngắt kết nối và giải phóng tài nguyên
  void dispose();
}
