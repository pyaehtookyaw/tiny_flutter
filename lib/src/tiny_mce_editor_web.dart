// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:async';
import 'dart:html' as html;
import 'dart:ui_web' as ui;

import 'package:flutter/material.dart';

class TinyMceEditor extends StatelessWidget {
  final double heightFactor;

  const TinyMceEditor({super.key, this.heightFactor = 0.6});

  static const String _viewType = 'tinymce-editor-view';
  static bool _viewFactoryRegistered = false;
  static html.IFrameElement? _iframe;
  static Completer<String?>? _contentCompleter;
  static html.EventListener? _messageListener;
  static String? _pendingContent;

  static void _ensureViewFactoryRegistered() {
    if (_viewFactoryRegistered) return;
    _viewFactoryRegistered = true;

    _messageListener = (html.Event event) {
      if (event is html.MessageEvent) {
        final data = event.data;
        if (data is Map && data['type'] == 'editorContent') {
          final completer = _contentCompleter;
          if (completer != null && !completer.isCompleted) {
            completer.complete(data['content'] as String?);
          }
          _contentCompleter = null;
        }
      }
    };
    html.window.addEventListener('message', _messageListener!);

    const iframeSrc =
        '/assets/packages/tiny_flutter/assets/tinymce_editor.html';

    ui.platformViewRegistry.registerViewFactory(_viewType, (int _) {
      final iframe = html.IFrameElement()
        ..src = iframeSrc
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%';
      iframe.onLoad.listen((_) {
        if (_pendingContent != null) {
          iframe.contentWindow?.postMessage({
            'type': 'setContent',
            'content': _pendingContent,
          }, '*');
          _pendingContent = null;
        }
      });
      _iframe = iframe;
      return iframe;
    });
  }

  static Future<String?> getEditorContent({
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final iframe = _iframe;
    if (iframe == null) return null;
    final iframeWindow = iframe.contentWindow;
    if (iframeWindow == null) return null;

    _contentCompleter = Completer<String?>();
    iframeWindow.postMessage('getContent', '*');

    return _contentCompleter!.future.timeout(timeout, onTimeout: () => null);
  }

  static void setEditorContent(String htmlContent) {
    _pendingContent = htmlContent;
    _iframe?.contentWindow?.postMessage({
      'type': 'setContent',
      'content': htmlContent,
    }, '*');
  }

  @override
  Widget build(BuildContext context) {
    _ensureViewFactoryRegistered();

    return Container(
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height * heightFactor,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const HtmlElementView(viewType: _viewType),
    );
  }
}
