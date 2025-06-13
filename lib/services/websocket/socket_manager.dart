// import '../../utils/app_logger.dart';
// import 'base_socket_service.dart';
// import 'product_socket_service.dart';
// import 'socket_service.dart';
// // Import các service khác...

// /// Trình quản lý tập trung cho tất cả các dịch vụ WebSocket trong ứng dụng
// class SocketManager {
//   static final SocketManager _instance = SocketManager._internal();

//   factory SocketManager() => _instance;

//   SocketManager._internal();

//   // Socket chính
//   late SocketService _mainSocketService;

//   // Map lưu trữ các namespace socket
//   final Map<String, BaseSocketService> _socketServices = {};
//   bool _isInitialized = false;

//   /// Khởi tạo tất cả các dịch vụ socket
//   void initialize(String serverUrl) {
//     if (_isInitialized) return;

//     AppLogger.info('Khởi tạo SocketManager');

//     // Khởi tạo socket chính
//     _mainSocketService = SocketService(serverUrl: serverUrl);
//     _mainSocketService.init();

//     // Khởi tạo các socket namespace
//     _registerSocketServices();

//     _isInitialized = true;
//     AppLogger.info('SocketManager đã khởi tạo thành công');
//   }

//   /// Đăng ký các dịch vụ socket namespace
//   void _registerSocketServices() {
//     // Đăng ký socket sản phẩm
//     _registerSocketService(
//         'product', ProductSocketService(socketService: _mainSocketService));

//     // Đăng ký các socket khác ở đây...
//     // _registerSocketService('chat', ChatSocketService(socketService: _mainSocketService));
//     // _registerSocketService('order', OrderSocketService(socketService: _mainSocketService));
//   }

//   /// Đăng ký một dịch vụ socket mới
//   void _registerSocketService(String name, BaseSocketService service) {
//     _socketServices[name] = service;
//     service.init();
//     AppLogger.info('Đăng ký socket service: $name');
//   }

//   /// Lấy dịch vụ socket theo tên
//   T? getSocketService<T extends BaseSocketService>(String name) {
//     if (!_isInitialized) {
//       AppLogger.error('SocketManager chưa được khởi tạo');
//       return null;
//     }

//     final service = _socketServices[name];
//     if (service == null) {
//       AppLogger.error('Không tìm thấy socket service: $name');
//       return null;
//     }

//     if (service is T) {
//       return service;
//     }

//     AppLogger.error(
//         'Socket service không phải kiểu yêu cầu: $name, kiểu ${service.runtimeType}');
//     return null;
//   }

//   /// Lấy dịch vụ socket chính
//   SocketService get mainSocketService => _mainSocketService;

//   /// Kiểm tra trạng thái khởi tạo
//   bool get isInitialized => _isInitialized;

//   /// Hủy tất cả kết nối socket
//   void dispose() {
//     if (!_isInitialized) return;

//     AppLogger.info('Hủy các kết nối socket');

//     // Hủy các socket namespace
//     for (final entry in _socketServices.entries) {
//       AppLogger.info('Hủy socket service: ${entry.key}');
//       entry.value.dispose();
//     }
//     _socketServices.clear();

//     // Hủy socket chính
//     _mainSocketService.dispose();

//     _isInitialized = false;
//   }
// }
