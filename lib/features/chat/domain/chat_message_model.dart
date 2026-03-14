/// A single message in the AI chat conversation.
///
/// [role] matches the OpenAI/Claude convention: `'user'`, `'assistant'`,
/// or `'system'`.  Only `user` and `assistant` messages are rendered in the
/// UI; `system` messages are used internally for context injection.
class ChatMessageModel {
  const ChatMessageModel({
    required this.role,
    required this.content,
    required this.timestamp,
  });

  final String role;
  final String content;
  final DateTime timestamp;

  bool get isUser => role == 'user';
  bool get isAssistant => role == 'assistant';

  Map<String, dynamic> toJson() => {
        'role': role,
        'content': content,
      };

  factory ChatMessageModel.user(String content) => ChatMessageModel(
        role: 'user',
        content: content,
        timestamp: DateTime.now(),
      );

  factory ChatMessageModel.assistant(String content) => ChatMessageModel(
        role: 'assistant',
        content: content,
        timestamp: DateTime.now(),
      );
}
