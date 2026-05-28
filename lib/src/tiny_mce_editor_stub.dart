import 'package:flutter/material.dart';

/// Embeds [TinyMCE](https://www.tiny.cloud/) in Flutter **web** via an iframe.
///
/// On other platforms this shows a short placeholder; use Flutter web for the
/// real editor.
class TinyMceEditor extends StatelessWidget {
  /// Editor height as a fraction of the screen height (default `0.6`).
  final double heightFactor;

  /// Creates a TinyMCE editor surface.
  const TinyMceEditor({super.key, this.heightFactor = 0.6});

  /// Returns the current HTML from the editor, or `null` if unavailable.
  static Future<String?> getEditorContent({
    Duration timeout = const Duration(seconds: 5),
  }) async =>
      null;

  /// Pre-fills the editor with [htmlContent] (web only).
  static void setEditorContent(String htmlContent) {}

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * heightFactor,
      child: const Center(
        child: Text('TinyMceEditor runs on Flutter web only.'),
      ),
    );
  }
}
