import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/word.dart';
import '../providers/word_provider.dart';

class AddWordDialog extends StatefulWidget {
  final Word? wordToEdit;

  const AddWordDialog({super.key, this.wordToEdit});

  @override
  State<AddWordDialog> createState() => _AddWordDialogState();
}

class _AddWordDialogState extends State<AddWordDialog> {
  late final TextEditingController _englishCtrl;
  late final TextEditingController _japaneseCtrl;
  late final TextEditingController _exampleCtrl;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _englishCtrl = TextEditingController(text: widget.wordToEdit?.english ?? '');
    _japaneseCtrl =
        TextEditingController(text: widget.wordToEdit?.japanese ?? '');
    _exampleCtrl =
        TextEditingController(text: widget.wordToEdit?.example ?? '');
  }

  @override
  void dispose() {
    _englishCtrl.dispose();
    _japaneseCtrl.dispose();
    _exampleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.wordToEdit != null;

    return AlertDialog(
      title: Text(isEditing ? '単語を編集' : '単語を追加'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _englishCtrl,
                decoration: const InputDecoration(
                  labelText: '英単語 *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.translate),
                ),
                validator: (v) => v?.trim().isEmpty ?? true ? '英単語を入力してください' : null,
                textCapitalization: TextCapitalization.none,
                autofocus: true,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _japaneseCtrl,
                decoration: const InputDecoration(
                  labelText: '意味（日本語）*',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.text_fields),
                ),
                validator: (v) =>
                    v?.trim().isEmpty ?? true ? '意味を入力してください' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _exampleCtrl,
                decoration: const InputDecoration(
                  labelText: '例文（任意）',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.edit_note),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('キャンセル'),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(isEditing ? '更新' : '追加'),
        ),
      ],
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<WordProvider>();
    final english = _englishCtrl.text.trim();
    final japanese = _japaneseCtrl.text.trim();
    final example = _exampleCtrl.text.trim();

    if (widget.wordToEdit != null) {
      provider.updateWord(widget.wordToEdit!, english, japanese,
          example: example.isEmpty ? null : example);
    } else {
      provider.addWord(english, japanese,
          example: example.isEmpty ? null : example);
    }
    Navigator.pop(context);
  }
}
