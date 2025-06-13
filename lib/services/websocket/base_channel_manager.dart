// import 'package:vinachem_shop/core/services/socket_service.dart';
// import 'package:vinachem_shop/core/utils/app_logger.dart';
// import 'channel_type.dart';
//
// abstract class BaseChannelManager {
//   final SocketService socketService;
//   final ChannelType channelType;
//   final Set<String> _subscriptions = {};
//
//   BaseChannelManager(this.socketService, this.channelType);
//
//   String get channelName => channelType.name;
//   String get updateEventName => channelType.updateEvent;
//   String get subscribeEventName => channelType.subscribeEvent;
//   String get unsubscribeEventName => channelType.unsubscribeEvent;
//
//   /// Subscribe to an item in this channel
//   void subscribe(String itemId) {
//     if (_subscriptions.contains(itemId)) return;
//
//     try {
//       _subscriptions.add(itemId);
//       socketService.socket.emit(subscribeEventName, {
//         'channel': channelName,
//         'itemId': itemId,
//       });
//       AppLogger.info('Subscribed to $channelName item $itemId');
//     } catch (e, stackTrace) {
//       AppLogger.error(
//         'Error subscribing to $channelName item $itemId',
//         error: e,
//         stackTrace: stackTrace,
//       );
//       _subscriptions.remove(itemId);
//     }
//   }
//
//   /// Unsubscribe from an item in this channel
//   void unsubscribe(String itemId) {
//     if (!_subscriptions.contains(itemId)) return;
//
//     try {
//       _subscriptions.remove(itemId);
//       socketService.socket.emit(unsubscribeEventName, {
//         'channel': channelName,
//         'itemId': itemId,
//       });
//       AppLogger.info('Unsubscribed from $channelName item $itemId');
//     } catch (e, stackTrace) {
//       AppLogger.error(
//         'Error unsubscribing from $channelName item $itemId',
//         error: e,
//         stackTrace: stackTrace,
//       );
//     }
//   }
//
//   /// Handle update events for this channel
//   void onUpdate(Function(Map<String, dynamic>) handler) {
//     socketService.socket.on(updateEventName, (data) {
//       try {
//         if (data is! Map<String, dynamic>) {
//           AppLogger.error(
//             'Invalid update data type for $channelName',
//             data: {'actualType': data.runtimeType},
//           );
//           return;
//         }
//
//         final itemId = data['itemId']?.toString();
//         if (itemId == null) {
//           AppLogger.error(
//             'Missing itemId in update data for $channelName',
//             data: data,
//           );
//           return;
//         }
//
//         if (!_subscriptions.contains(itemId)) {
//           AppLogger.debug(
//             'Received update for unsubscribed $channelName item',
//             data: {'itemId': itemId},
//           );
//           return;
//         }
//
//         AppLogger.debug(
//           'Processing update for $channelName item',
//           data: {'itemId': itemId},
//         );
//
//         // Acknowledge receipt of update
//         socketService.socket.emit('${channelName}_update_received', {
//           'itemId': itemId,
//           'timestamp': DateTime.now().toIso8601String(),
//         });
//         handler(data);
//       } catch (e, stackTrace) {
//         AppLogger.error(
//           'Error processing update for $channelName',
//           error: e,
//           stackTrace: stackTrace,
//           data: data is Map ? data : {'rawData': data},
//         );
//       }
//     });
//   }
//
//   /// Unsubscribe from all items in this channel
//   void dispose() {
//     final subscriptions = List.from(_subscriptions);
//     for (final itemId in subscriptions) {
//       unsubscribe(itemId);
//     }
//     _subscriptions.clear();
//   }
//
//   /// Check if a specific item ID is subscribed
//   bool isSubscribed(String itemId) => _subscriptions.contains(itemId);
//
//   /// Get all current subscriptions
//   Set<String> get subscriptions => Set.from(_subscriptions);
// }
