import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/word.dart';
import '../providers/word_provider.dart';

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  int _currentIndex = 0;
  String _mode = 'all';
  List<Word> _words = [];
  final GlobalKey<FlipCardState> _cardKey = GlobalKey<FlipCardState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('フラッシュカード',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.tune),
            onSelected: (v) => setState(() {
              _mode = v;
              _currentIndex = 0;
            }),
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'all', child: Text('すべて')),
              const PopupMenuItem(value: 'unmemorized', child: Text('未暗記のみ')),
            ],
          ),
        ],
      ),
      body: Consumer<WordProvider>(
        builder: (context, provider, _) {
          _words = _mode == 'unmemorized'
              ? provider.unstudiedWords
              : provider.allWords;

          if (_words.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.style_outlined,
                      size: 64, color: Theme.of(context).colorScheme.outline),
                  const SizedBox(height: 16),
                  Text(
                    _mode == 'unmemorized'
                        ? 'すべての単語が暗記済みです！'
                        : '単語を追加してください',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.outline,
                        fontSize: 16),
                  ),
                ],
              ),
            );
          }

          if (_currentIndex >= _words.length) _currentIndex = 0;
          final word = _words[_currentIndex];

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  '${_currentIndex + 1} / ${_words.length}',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.outline,
                      fontSize: 14),
                ),
              ),
              LinearProgressIndicator(
                value: (_currentIndex + 1) / _words.length,
                backgroundColor:
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                minHeight: 6,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: FlipCard(
                    key: ValueKey('${word.key}_$_currentIndex'),
                    flipOnTouch: true,
                    front: _buildCardFace(
                      context,
                      word.english,
                      'タップして答えを見る',
                      Theme.of(context).colorScheme.primaryContainer,
                      Theme.of(context).colorScheme.onPrimaryContainer,
                      isBack: false,
                    ),
                    back: _buildCardFace(
                      context,
                      word.japanese,
                      word.example,
                      Theme.of(context).colorScheme.secondaryContainer,
                      Theme.of(context).colorScheme.onSecondaryContainer,
                      isBack: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          provider.recordReview(word);
                          _next();
                        },
                        icon: const Icon(Icons.close, color: Colors.red),
                        label: const Text('もう一度',
                            style: TextStyle(color: Colors.red)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {
                          provider.recordReview(word);
                          if (!word.isMemorized) {
                            provider.toggleMemorized(word);
                          }
                          _next();
                        },
                        icon: const Icon(Icons.check),
                        label: const Text('覚えた！'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }

  void _next() {
    setState(() {
      if (_currentIndex < _words.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
        _showCompletionDialog();
      }
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('お疲れ様でした！'),
        content: const Text('全ての単語を確認しました。\nもう一度最初から始めますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('終了'),
          ),
          FilledButton(
            onPressed: () {
              setState(() => _currentIndex = 0);
              Navigator.pop(context);
            },
            child: const Text('もう一度'),
          ),
        ],
      ),
    );
  }

  Widget _buildCardFace(
    BuildContext context,
    String mainText,
    String? subText,
    Color backgroundColor,
    Color textColor, {
    required bool isBack,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isBack ? '意味' : '英語',
                style: TextStyle(
                    fontSize: 12,
                    color: textColor.withOpacity(0.6),
                    letterSpacing: 2),
              ),
              const SizedBox(height: 16),
              Text(
                mainText,
                style: TextStyle(
                  fontSize: mainText.length > 20 ? 22 : 32,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
              ),
              if (subText != null && subText.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  subText,
                  style: TextStyle(
                      fontSize: 14,
                      color: textColor.withOpacity(0.7),
                      fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
              ],
              if (!isBack) ...[
                const SizedBox(height: 32),
                Text(
                  'タップして答えを見る',
                  style: TextStyle(
                      fontSize: 12, color: textColor.withOpacity(0.5)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
