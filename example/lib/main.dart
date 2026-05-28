import 'package:flutter/material.dart';
import 'package:tiny_flutter/tiny_flutter.dart';

void main() {
  runApp(const MyApp());
}

class _DemoAuthor {
  static const String name = 'Pyae Htoo Kyaw';
  static const String email = 'phk99977@gmail.com';
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'tiny_flutter example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ExamplePage(),
    );
  }
}

/// Home: two actions. Each opens a dialog — editor lives only inside the dialog.
class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  static String _demoArticleHtml() => '''
<table style="border-collapse: collapse; width: 100%;" border="1">
<tbody>
<tr>
<td>Name</td>
<td>${_DemoAuthor.name}</td>
</tr>
<tr>
<td>Email</td>
<td>${_DemoAuthor.email}</td>
</tr>
</tbody>
</table>
''';

  Future<void> _openCreateDialog(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => _ArticleEditorDialog(
        title: 'Create article',
        initialHtml: '',
        onCancel: () => Navigator.pop(dialogContext),
        onSave: (html) {
          Navigator.pop(dialogContext);
          messenger.showSnackBar(SnackBar(content: Text(_snippet(html))));
        },
      ),
    );
  }

  Future<void> _openUpdateDialog(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => _ArticleEditorDialog(
        title: 'Update article',
        initialHtml: _demoArticleHtml(),
        onCancel: () => Navigator.pop(dialogContext),
        onSave: (html) {
          Navigator.pop(dialogContext);
          messenger.showSnackBar(SnackBar(content: Text(_snippet(html))));
        },
      ),
    );
  }

  static String _snippet(String? html) {
    if (html == null || html.isEmpty) return '(empty or unavailable)';
    if (html.length <= 160) return html;
    return '${html.substring(0, 160)}…';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('tiny_flutter')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FilledButton.tonal(
                  onPressed: () => _openCreateDialog(context),
                  child: const Text('Create article'),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => _openUpdateDialog(context),
                  child: const Text('Update article'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ArticleEditorDialog extends StatefulWidget {
  const _ArticleEditorDialog({
    required this.title,
    required this.initialHtml,
    required this.onCancel,
    required this.onSave,
  });

  final String title;
  final String initialHtml;
  final VoidCallback onCancel;
  final void Function(String? html) onSave;

  @override
  State<_ArticleEditorDialog> createState() => _ArticleEditorDialogState();
}

class _ArticleEditorDialogState extends State<_ArticleEditorDialog> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TinyMceEditor.setEditorContent(widget.initialHtml);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: size.width * 0.70,
          maxHeight: size.height * 0.90,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 12, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    onPressed: widget.onCancel,
                    icon: const Icon(Icons.close),
                    tooltip: 'Close',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '* ',
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Article content',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Flexible(
                      flex: 5,
                      child: TinyMceEditor(heightFactor: 0.38),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: widget.onCancel,
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () async {
                      final html = await TinyMceEditor.getEditorContent();
                      widget.onSave(html);
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
