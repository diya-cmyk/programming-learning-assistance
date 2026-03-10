import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../services/ai_service.dart';
import '../providers/gamification_provider.dart';
import '../theme/cyberpunk_theme.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  AIMode _selectedMode = AIMode.chat;

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'content': text});
      _isLoading = true;
      _controller.clear();
    });

    final response = await AIService.sendMessage(text, mode: _selectedMode);

    setState(() {
      _messages.add({'role': 'assistant', 'content': response});
      _isLoading = false;
    });

    // Award points for engagement
    context.read<GamificationProvider>().addPoints(5, skill: 'chat');

    await Future.delayed(const Duration(milliseconds: 100));
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AI Tutor',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton<AIMode>(
            icon: const Icon(Icons.tune),
            onSelected: (m) => setState(() => _selectedMode = m),
            itemBuilder: (_) => AIMode.values
                .map(
                  (m) => PopupMenuItem(
                    value: m,
                    child: Text(m.name.toUpperCase()),
                  ),
                )
                .toList(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Mode indicator
          Container(
            color: CyberpunkTheme.secondary.withOpacity(0.2),
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                const Icon(
                  Icons.smart_toy,
                  size: 16,
                  color: CyberpunkTheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Mode: ${_selectedMode.name.toUpperCase()}',
                  style: const TextStyle(
                    color: CyberpunkTheme.primary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Messages
          Expanded(
            child: _messages.isEmpty
                ? const Center(
                    child: Text(
                      'Ask me anything about programming!',
                      style: TextStyle(color: CyberpunkTheme.textMuted),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length + (_isLoading ? 1 : 0),
                    itemBuilder: (ctx, i) {
                      if (i == _messages.length) {
                        return const Padding(
                          padding: EdgeInsets.all(8),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text('AI is thinking...'),
                            ],
                          ),
                        );
                      }
                      final msg = _messages[i];
                      final isUser = msg['role'] == 'user';
                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(ctx).size.width * 0.8,
                          ),
                          decoration: BoxDecoration(
                            color: isUser
                                ? CyberpunkTheme.secondary
                                : CyberpunkTheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: isUser
                                ? null
                                : Border.all(
                                    color: CyberpunkTheme.primary.withOpacity(
                                      0.3,
                                    ),
                                  ),
                          ),
                          child: isUser
                              ? Text(msg['content']!)
                              : MarkdownBody(data: msg['content']!),
                        ),
                      );
                    },
                  ),
          ),
          // Input bar
          Container(
            padding: const EdgeInsets.all(12),
            color: CyberpunkTheme.surface,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: InputDecoration(
                      hintText: 'Ask a question...',
                      filled: true,
                      fillColor: CyberpunkTheme.bg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  mini: true,
                  onPressed: _sendMessage,
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
