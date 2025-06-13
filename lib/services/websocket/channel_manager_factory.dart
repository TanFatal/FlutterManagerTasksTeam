// import 'package:vinachem_shop/core/services/socket_service.dart';
// import 'base_channel_manager.dart';
// import 'channel_type.dart';
// import 'product_channel_manager.dart';
//
// class ChannelManagerFactory {
//   static BaseChannelManager create(
//       ChannelType type, SocketService socketService) {
//     switch (type) {
//       case ChannelType.products:
//         return ProductChannelManager(socketService);
//       case ChannelType.orders:
//         // Add OrderChannelManager when needed
//         throw UnimplementedError('Order channel manager not implemented yet');
//       case ChannelType.promotions:
//         // Add PromotionChannelManager when needed
//         throw UnimplementedError(
//             'Promotion channel manager not implemented yet');
//     }
//   }
//
//   // Helper method to create multiple channel managers at once
//   static Map<ChannelType, BaseChannelManager> createMany(
//     Set<ChannelType> types,
//     SocketService socketService,
//   ) {
//     return {
//       for (final type in types) type: create(type, socketService),
//     };
//   }
// }
