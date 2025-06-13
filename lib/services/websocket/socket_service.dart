// import 'package:socket_io_client/socket_io_client.dart' as IO;

// import '../../utils/app_logger.dart';
// import 'base_socket_service.dart';

// class SocketService implements BaseSocketService {
//   late IO.Socket _socket;
//   final String _serverUrl;
//   bool _isInitialized = false;

//   SocketService({required String serverUrl}) : _serverUrl = serverUrl;

//   @override
//   bool get isInitialized => _isInitialized;

//   @override
//   bool get isConnected => _isInitialized && _socket.connected;

//   @override
//   void init() {
//     if (_isInitialized) return;

//     try {
//       _socket = IO.io(_serverUrl, <String, dynamic>{
//         'transports': ['websocket'],
//         'autoConnect': true,
//         'reconnection': true,
//         'reconnectionAttempts': 5,
//         'reconnectionDelay': 1000,
//       });

//       _socket.onConnect((_) {
//         AppLogger.socket('Kết nối socket thành công');
//       });

//       _socket.onConnectError((error) {
//         AppLogger.socket('Lỗi kết nối socket',
//             data: {'error': error.toString()});
//       });

//       _socket.onDisconnect((_) {
//         AppLogger.socket('Ngắt kết nối socket');
//       });

//       _socket.onError((error) {
//         AppLogger.socket('Lỗi socket', data: {'error': error.toString()});
//       });

//       _isInitialized = true;
//     } catch (e) {
//       AppLogger.error('Lỗi khởi tạo socket', data: {'error': e.toString()});
//       rethrow;
//     }
//   }

//   @override
//   void on(String event, Function(dynamic) handler) {
//     if (!_isInitialized) init();
//     _socket.on(event, handler);
//   }

//   @override
//   void off(String event) {
//     if (_isInitialized) {
//       _socket.off(event);
//     }
//   }

//   @override
//   void emit(String event, [dynamic data]) {
//     if (!_isInitialized) init();

//     if (data != null) {
//       _socket.emit(event, data);
//     } else {
//       _socket.emit(event);
//     }
//   }

//   @override
//   void reconnect() {
//     if (_isInitialized && !_socket.connected) {
//       _socket.connect();
//     }
//   }

//   @override
//   void dispose() {
//     if (_isInitialized) {
//       _socket.disconnect();
//       _socket.dispose();
//       _isInitialized = false;
//     }
//   }

//   // Phương thức tạo namespace socket
//   IO.Socket getNamespaceSocket(String namespace) {
//     if (!_isInitialized) {
//       init();
//     }

//     final namespaceUrl = '$_serverUrl$namespace';
//     AppLogger.socket('Kết nối đến namespace',
//         data: {'namespace': namespaceUrl});

//     return IO.io(namespaceUrl, <String, dynamic>{
//       'transports': ['websocket'],
//       'autoConnect': true,
//       'reconnection': true,
//     });
//   }

//   // Getter để truy cập socket gốc nếu cần
//   IO.Socket get socket => _socket;
// }
