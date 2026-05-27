import 'package:flutter/material.dart';

/// TinyMCE editor surface. On non-web platforms this is a placeholder; use
/// Flutter web for the real editor.
class TinyMceEditorWidget extends StatelessWidget {
  final double heightFactor;

  const TinyMceEditorWidget({super.key, this.heightFactor = 0.6});

  static Future<String?> getEditorContent({
    Duration timeout = const Duration(seconds: 5),
  }) async =>
      null;

  static void setEditorContent(String htmlContent) {}

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * heightFactor,
      child: const Center(
        child: Text('TinyMceEditorWidget runs on Flutter web only.'),
      ),
    );
  }
}
