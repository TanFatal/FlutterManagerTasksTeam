// ignore_for_file: file_names

import 'dart:io';
import 'dart:developer';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:testflutter/models/RoomChatPreView.dart';
import 'package:testflutter/models/MessageModel.dart';
import 'package:testflutter/models/UserSession.dart';
import 'package:testflutter/services/messageService.dart';
import 'package:testflutter/services/auth_api_service.dart';
import 'package:testflutter/config/api_config.dart';

class ChatScreen extends StatefulWidget {
  final RoomChatPreviewModel roomChatPreview;

  const ChatScreen({super.key, required this.roomChatPreview});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final MessageApiService _messageService = MessageApiService();
  final AuthApiService _authService = AuthApiService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<MessageModel> _messages = [];
  bool _isLoading = true;
  bool _isSending = false;

  // Cache for user data to avoid repeated API calls
  final Map<int, Map<String, String>> _userDataCache = {};

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final messages = await _messageService.getAllMessageByRoomChat(
        widget.roomChatPreview.roomChat.roomChatId,
      );

      // Load user data for all unique senders
      final uniqueSenderIds = messages
          .map((msg) => msg.senderId)
          .where((id) => id != UserSession.currentUser?.id)
          .toSet();

      for (final senderId in uniqueSenderIds) {
        await _loadUserData(senderId);
      }

      setState(() {
        _messages = messages; // Keep original order
        _isLoading = false;
      });

      // Scroll to bottom after loading
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      log('Error loading messages: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _sendMessage(String content, String type) async {
    if (content.trim().isEmpty) return;

    setState(() {
      _isSending = true;
    });

    try {
      final result = await _messageService.sendMessageToRoomChatId(
        widget.roomChatPreview.roomChat.roomChatId,
        content,
        type,
      );

      log('Send message result: $result');

      // Reload messages after sending
      await _loadMessages();

      // Clear input
      _messageController.clear();
    } catch (e) {
      log('Error sending message: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message: $e')),
      );
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  String get _roomName {
    final room = widget.roomChatPreview.roomChat;
    String roomName = room.nameRoom;
    final parts = roomName.split('_');
    if (parts.length == 2 && UserSession.currentUser != null) {
      roomName =
          (parts[0] == UserSession.currentUser?.fullname) ? parts[1] : parts[0];
    }
    return roomName;
  }

  bool _isValidImageUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    try {
      final uri = Uri.tryParse(url);
      if (uri == null || !uri.hasAbsolutePath) return false;
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  bool _isCurrentUser(int senderId) {
    return UserSession.currentUser?.id == senderId;
  }

  Future<void> _loadUserData(int senderId) async {
    if (_userDataCache.containsKey(senderId)) return;

    try {
      // Get full user data from API
      final response = await _authService.apiService.getData(
          _authService.baseUrl +
              ApiConfig.users +
              "/id/" +
              senderId.toString());

      if (response != null && response.statusCode == 200) {
        final userData = response.data;
        _userDataCache[senderId] = {
          'name': userData['fullname'] ?? 'Unknown User',
          'avatar': userData['urlImg'] ?? '', // Get avatar URL from API
        };
        log('✅ Loaded user data for $senderId: ${userData['fullname']}, avatar: ${userData['urlImg']}');
      } else {
        log('❌ Failed to load user data for $senderId');
        _userDataCache[senderId] = {
          'name': 'Unknown User',
          'avatar': '',
        };
      }
    } catch (e) {
      log('Error loading user data for $senderId: $e');
      _userDataCache[senderId] = {
        'name': 'Unknown User',
        'avatar': '',
      };
    }
  }

  String _getSenderName(int senderId) {
    if (senderId == UserSession.currentUser?.id) {
      return UserSession.currentUser?.fullname ?? 'You';
    }

    return _userDataCache[senderId]?['name'] ?? 'Loading...';
  }

  String _getSenderAvatar(int senderId) {
    return _userDataCache[senderId]?['avatar'] ?? '';
  }

  String _getSenderInitials(int senderId) {
    final name = _getSenderName(senderId);
    if (name.isEmpty || name == 'Loading...') return '?';

    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else {
      return name.substring(0, 1).toUpperCase();
    }
  }

  Widget _buildMessageBubble(MessageModel message) {
    final isCurrentUser = _isCurrentUser(message.senderId);
    final time = DateFormat('HH:mm').format(message.timestamp);

    if (isCurrentUser) {
      // Current user message - align right, no avatar
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(18),
          ),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (message.type == 'image' && _isValidImageUrl(message.content))
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    message.content,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey.shade300,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey.shade300,
                        child: const Center(
                          child: Icon(Icons.broken_image, size: 50),
                        ),
                      );
                    },
                  ),
                )
              else
                Text(
                  message.content,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              const SizedBox(height: 4),
              Text(
                time,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // Other user message - align left with avatar and name
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.blue.shade300,
                backgroundImage:
                    _isValidImageUrl(_getSenderAvatar(message.senderId))
                        ? NetworkImage(_getSenderAvatar(message.senderId))
                        : null,
                child: !_isValidImageUrl(_getSenderAvatar(message.senderId))
                    ? Text(
                        _getSenderInitials(message.senderId),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 8),
              // Message content
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sender name
                    Text(
                      _getSenderName(message.senderId),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Message bubble
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.6,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (message.type == 'image' &&
                              _isValidImageUrl(message.content))
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                message.content,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    height: 200,
                                    width: double.infinity,
                                    color: Colors.grey.shade300,
                                    child: const Center(
                                        child: CircularProgressIndicator()),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 200,
                                    width: double.infinity,
                                    color: Colors.grey.shade300,
                                    child: const Center(
                                      child: Icon(Icons.broken_image, size: 50),
                                    ),
                                  );
                                },
                              ),
                            )
                          else
                            Text(
                              message.content,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                              ),
                            ),
                          const SizedBox(height: 4),
                          Text(
                            time,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final room = widget.roomChatPreview.roomChat;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: _isValidImageUrl(room.urlImages)
                  ? Colors.transparent
                  : Colors.blue.shade700,
              backgroundImage: _isValidImageUrl(room.urlImages)
                  ? NetworkImage(room.urlImages)
                  : null,
              child: !_isValidImageUrl(room.urlImages)
                  ? const Icon(Icons.groups, color: Colors.white, size: 24)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _roomName,
                style: const TextStyle(fontSize: 18, color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _messages.isEmpty
                    ? const Center(
                        child: Text(
                          'No messages yet.\nStart the conversation!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          return _buildMessageBubble(_messages[index]);
                        },
                      ),
          ),

          // Message input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image, color: Colors.blue),
                  onPressed: _pickImage,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    onSubmitted: (value) => _sendMessage(value, 'text'),
                  ),
                ),
                const SizedBox(width: 8),
                _isSending
                    ? const CircularProgressIndicator()
                    : IconButton(
                        icon: const Icon(Icons.send, color: Colors.blue),
                        onPressed: () =>
                            _sendMessage(_messageController.text, 'text'),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // TODO: Upload image to your image service and get URL
      // For now, just send the local path (this won't work in production)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Image upload not implemented yet. Please add your image upload service.'),
        ),
      );
    }
  }
}
