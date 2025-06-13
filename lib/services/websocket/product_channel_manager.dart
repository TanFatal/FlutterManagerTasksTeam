// import 'package:vinachem_shop/core/services/socket_service.dart';
// import 'base_channel_manager.dart';
// import 'channel_type.dart';
//
// class ProductChannelManager extends BaseChannelManager {
//   ProductChannelManager(SocketService socketService)
//       : super(socketService, ChannelType.products);
//
//   // Subscribe to a product using its ID
//   void subscribeToProduct(int productId) {
//     subscribe(productId.toString());
//   }
//
//   // Unsubscribe from a product using its ID
//   void unsubscribeFromProduct(int productId) {
//     unsubscribe(productId.toString());
//   }
//
//   // Check if subscribed to a product
//   bool isSubscribedToProduct(int productId) {
//     return isSubscribed(productId.toString());
//   }
//
//   // Get all subscribed product IDs
//   Set<int> get subscribedProductIds {
//     return subscriptions.map((id) => int.parse(id)).toSet();
//   }
// }
