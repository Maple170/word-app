import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../models/word.dart';
import '../providers/word_provider.dart';
import '../widgets/add_word_dialog.dart';

class WordListScreen extends StatefulWidget {
  const WordListScreen({super.key});

  @override
  State<WordListScreen> createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  String _filter = 'all';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('単語帳', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (v) => setState(() => _filter = v),
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'all', child: Text('すべて')),
              const PopupMenuItem(value: 'unmemorized', child: Text('未暗記')),
              const PopupMenuItem(value: 'memorized', child: Text('暗記済み')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: SearchBar(
              hintText: '単語を検索...',
              leading: const Icon(Icons.search),
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
          ),
          Expanded(
            child: Consumer<WordProvider>(
              builder: (context, provider, _) {
                List<Word> words = provider.allWords;
                if (_filter == 'memorized') {
                  words = words.where((w) => w.isMemorized).toList();
                } else if (_filter == 'unmemorized') {
                  words = words.where((w) => !w.isMemorized).toList();
                }
                if (_searchQuery.isNotEmpty) {
                  final q = _searchQuery.toLowerCase();
                  words = words
                      .where((w) =>
                          w.english.toLowerCase().contains(q) ||
                          w.japanese.contains(q))
                      .toList();
                }

                if (words.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.book_outlined,
                            size: 64,
                            color: Theme.of(context).colorScheme.outline),
                        const SizedBox(height: 16),
                        Text(
                          '単語がありません\n右下の＋ボタンで追加しましょう',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.outline),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: words.length,
                  padding: const EdgeInsets.only(bottom: 80),
                  itemBuilder: (context, index) {
                    final word = words[index];
                    return Slidable(
                      key: ValueKey(word.key),
                      endActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (_) => _showEditDialog(context, provider, word),
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: '編集',
                          ),
                          SlidableAction(
                            onPressed: (_) => _confirmDelete(context, provider, word),
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: '削除',
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: word.isMemorized
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Theme.of(context).colorScheme.surfaceContainerHighest,
                          child: Icon(
                            word.isMemorized ? Icons.check : Icons.school,
                            color: word.isMemorized
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.outline,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          word.english,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(word.japanese),
                            if (word.example != null && word.example!.isNotEmpty)
                              Text(
                                word.example!,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).colorScheme.outline,
                                    fontStyle: FontStyle.italic),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            word.isMemorized
                                ? Icons.star
                                : Icons.star_border,
                            color: word.isMemorized ? Colors.amber : null,
                          ),
                          onPressed: () => provider.toggleMemorized(word),
                        ),
                        isThreeLine:
                            word.example != null && word.example!.isNotEmpty,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const AddWordDialog(),
    );
  }

  void _showEditDialog(BuildContext context, WordProvider provider, Word word) {
    showDialog(
      context: context,
      builder: (_) => AddWordDialog(wordToEdit: word),
    );
  }

  void _confirmDelete(BuildContext context, WordProvider provider, Word word) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('削除の確認'),
        content: Text('「${word.english}」を削除しますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () {
              provider.deleteWord(word);
              Navigator.pop(context);
            },
            child: const Text('削除'),
          ),
        ],
      ),
    );
  }
}
