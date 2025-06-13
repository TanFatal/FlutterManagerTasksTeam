// import 'package:socket_io_client/socket_io_client.dart' as IO;

// import '../../utils/app_logger.dart';
// import 'base_socket_service.dart';
// import 'socket_service.dart';

// class ProductSocketService implements BaseSocketService {
//   final SocketService _socketService;
//   late IO.Socket _productSocket;
//   bool _isInitialized = false;

//   // Callback cho các sự kiện
//   final Map<String, List<Function(dynamic)>> _eventHandlers = {};

//   ProductSocketService({
//     required SocketService socketService,
//   }) : _socketService = socketService;

//   @override
//   bool get isInitialized => _isInitialized;

//   @override
//   bool get isConnected => _isInitialized && _productSocket.connected;

//   @override
//   void init() {
//     if (_isInitialized) return;

//     // Khởi tạo dịch vụ socket cơ sở nếu chưa được khởi tạo
//     if (!_socketService.isInitialized) {
//       _socketService.init();
//     }

//     // Tạo namespace socket cho sản phẩm
//     _productSocket = _socketService.getNamespaceSocket('/products');

//     _setupEventHandlers();
//     _isInitialized = true;
//   }

//   void _setupEventHandlers() {
//     _productSocket.onConnect((_) {
//       AppLogger.socket('Kết nối namespace products thành công');
//     });

//     _productSocket.onConnectError((error) {
//       AppLogger.socket('Lỗi kết nối namespace products',
//           data: {'error': error.toString()});
//     });

//     _productSocket.onDisconnect((_) {
//       AppLogger.socket('Ngắt kết nối namespace products');
//     });

//     _productSocket.onError((error) {
//       AppLogger.socket('Lỗi namespace products',
//           data: {'error': error.toString()});
//     });
//   }

//   @override
//   void on(String event, Function(dynamic) handler) {
//     if (!_isInitialized) init();

//     // Lưu trữ handler để có thể hủy đăng ký sau này
//     if (!_eventHandlers.containsKey(event)) {
//       _eventHandlers[event] = [];
//     }
//     _eventHandlers[event]!.add(handler);

//     // Đăng ký lắng nghe sự kiện trên socket
//     _productSocket.on(event, (data) {
//       AppLogger.socket('Nhận sự kiện từ namespace products',
//           data: {'event': event, 'data': data});
//       handler(data);
//     });
//   }

//   @override
//   void off(String event) {
//     if (_isInitialized) {
//       _productSocket.off(event);
//       _eventHandlers.remove(event);
//     }
//   }

//   @override
//   void emit(String event, [dynamic data]) {
//     if (!_isInitialized) init();

//     AppLogger.socket('Phát sự kiện đến namespace products',
//         data: {'event': event, 'data': data});

//     if (data != null) {
//       _productSocket.emit(event, data);
//     } else {
//       _productSocket.emit(event);
//     }

//     // Kiểm tra trạng thái kết nối
//     if (!_productSocket.connected) {
//       AppLogger.socket('Socket chưa kết nối, đang thử kết nối lại...');
//       _productSocket.connect();
//     }
//   }

//   @override
//   void reconnect() {
//     if (_isInitialized && !_productSocket.connected) {
//       _productSocket.connect();
//     }
//   }

//   @override
//   void dispose() {
//     if (_isInitialized) {
//       // Hủy đăng ký tất cả event listener
//       _eventHandlers.forEach((event, _) {
//         _productSocket.off(event);
//       });
//       _eventHandlers.clear();

//       _productSocket.disconnect();
//       _isInitialized = false;
//     }
//   }

//   // Phương thức tiện ích để đăng ký theo dõi sản phẩm
//   void subscribeToProduct(int productId) {
//     emit('product:subscribe', {'productId': productId});
//   }

//   // Phương thức tiện ích để hủy đăng ký theo dõi sản phẩm
//   void unsubscribeFromProduct(int productId) {
//     emit('product:unsubscribe', {'productId': productId});
//   }
// }
