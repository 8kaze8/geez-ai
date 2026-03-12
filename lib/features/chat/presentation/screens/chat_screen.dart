import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:geez_ai/core/theme/colors.dart';
import 'package:geez_ai/core/theme/spacing.dart';
import 'package:geez_ai/core/theme/typography.dart';
import 'package:geez_ai/features/chat/presentation/widgets/chat_bubble.dart';
import 'package:geez_ai/features/chat/presentation/widgets/question_chips.dart';

enum ChatStep { destination, style, transport, budget, loading }

class _ChatMessage {
  final String text;
  final bool isAI;

  const _ChatMessage({required this.text, this.isAI = true});
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatStep _currentStep = ChatStep.destination;
  final List<_ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _showChips = false;

  // User selections
  String? _selectedCity;
  String? _selectedStyle;
  // ignore: unused_field — will be used when passing data to route generation
  String? _selectedTransport;

  @override
  void initState() {
    super.initState();
    _addAIMessage('Merhaba! Ben Geez, senin travel buddy\'n. ✈️\n\nNereye gitmek istiyorsun?');
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _showChips = true);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _addAIMessage(String text) {
    setState(() {
      _messages.add(_ChatMessage(text: text, isAI: true));
    });
    _scrollToBottom();
  }

  void _addUserMessage(String text) {
    setState(() {
      _messages.add(_ChatMessage(text: text, isAI: false));
      _showChips = false;
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _onDestinationSelected(String city) {
    _selectedCity = city;
    _addUserMessage(city);

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      _addAIMessage(
        'Harika seçim! $city mükemmel bir destinasyon. 🎉\n\n'
        'Ne tarz bir gezi istiyorsun? Tarih mi, yemek mi, yoksa beni şaşırt mı? 😄',
      );
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) {
          setState(() {
            _currentStep = ChatStep.style;
            _showChips = true;
          });
          _scrollToBottom();
        }
      });
    });
  }

  void _onStyleSelected(String style) {
    _selectedStyle = style;
    _addUserMessage(style);

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      _addAIMessage(
        '$_selectedCity\'da ${style.toLowerCase()} — çok iyi kombinasyon! 🔥\n\n'
        'Nasıl dolaşmayı planlıyorsun?',
      );
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) {
          setState(() {
            _currentStep = ChatStep.transport;
            _showChips = true;
          });
          _scrollToBottom();
        }
      });
    });
  }

  void _onTransportSelected(String transport) {
    _selectedTransport = transport;
    _addUserMessage(transport);

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      _addAIMessage(
        'Tamam, not aldım! Son bir soru:\n\n'
        'Bütçen ne kadar? Bu sayede sana en uygun mekanları önerebilirim. 💰',
      );
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) {
          setState(() {
            _currentStep = ChatStep.budget;
            _showChips = true;
          });
          _scrollToBottom();
        }
      });
    });
  }

  void _onBudgetSelected(String budget) {
    _addUserMessage(budget);

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      _addAIMessage(
        'Mükemmel! Her şeyi anladım. 🧠\n\n'
        '$_selectedCity\'da ${_selectedStyle?.toLowerCase()} bir rota hazırlıyorum. '
        'Biraz bekle, sana özel bir şeyler bulacağım...',
      );
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          context.go('/route-loading');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? GeezColors.backgroundDark : GeezColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          _selectedCity != null ? '$_selectedCity Rotası' : 'Yeni Rota',
          style: GeezTypography.h3.copyWith(
            color:
                isDark ? GeezColors.textPrimaryDark : GeezColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(
                top: GeezSpacing.sm,
                bottom: GeezSpacing.md,
              ),
              itemCount: _messages.length + (_showChips ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < _messages.length) {
                  final msg = _messages[index];
                  return _AnimatedMessage(
                    key: ValueKey('msg_$index'),
                    child: ChatBubble(
                      text: msg.text,
                      isAI: msg.isAI,
                    ),
                  );
                }

                // Chips at the end
                return _buildCurrentChips();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentChips() {
    return switch (_currentStep) {
      ChatStep.destination => _buildDestinationChips(),
      ChatStep.style => _buildStyleChips(),
      ChatStep.transport => _buildTransportChips(),
      ChatStep.budget => _buildBudgetChips(),
      ChatStep.loading => const SizedBox.shrink(),
    };
  }

  Widget _buildDestinationChips() {
    return QuestionChips(
      options: const [
        ChipOption(label: 'İstanbul', emoji: '🇹🇷'),
        ChipOption(label: 'Paris', emoji: '🇫🇷'),
        ChipOption(label: 'Roma', emoji: '🇮🇹'),
        ChipOption(label: 'Tokyo', emoji: '🇯🇵'),
        ChipOption(label: 'Barcelona', emoji: '🇪🇸'),
        ChipOption(label: 'Londra', emoji: '🇬🇧'),
      ],
      onSelected: _onDestinationSelected,
      allowCustomInput: true,
      customInputHint: 'Şehir veya ülke yaz...',
    );
  }

  Widget _buildStyleChips() {
    return QuestionChips(
      options: const [
        ChipOption(label: 'Tarihi keşif', emoji: '🏛️'),
        ChipOption(label: 'Yemek turu', emoji: '🍕'),
        ChipOption(label: 'Hidden gems', emoji: '💎'),
        ChipOption(label: 'Karma', emoji: '🎲'),
        ChipOption(label: 'Surprise me!', emoji: '🎁'),
      ],
      onSelected: _onStyleSelected,
    );
  }

  Widget _buildTransportChips() {
    return QuestionChips(
      options: const [
        ChipOption(label: 'Yürüyerek', emoji: '🚶'),
        ChipOption(label: 'Toplu taşıma', emoji: '🚌'),
        ChipOption(label: 'Arabam var', emoji: '🚗'),
        ChipOption(label: 'Taksi/Uber OK', emoji: '🚕'),
      ],
      onSelected: _onTransportSelected,
    );
  }

  Widget _buildBudgetChips() {
    return QuestionChips(
      options: const [
        ChipOption(label: '₺500 altı', emoji: '💸'),
        ChipOption(label: '₺500-1000', emoji: '💰'),
        ChipOption(label: '₺1000+', emoji: '💎'),
        ChipOption(label: 'Farketmez', emoji: '🤷'),
      ],
      onSelected: _onBudgetSelected,
    );
  }
}

class _AnimatedMessage extends StatefulWidget {
  const _AnimatedMessage({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<_AnimatedMessage> createState() => _AnimatedMessageState();
}

class _AnimatedMessageState extends State<_AnimatedMessage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}
