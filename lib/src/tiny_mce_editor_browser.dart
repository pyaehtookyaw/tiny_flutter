import 'dart:async';
import 'dart:js_interop';
import 'dart:ui_web' as ui;

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

/// TinyMCE editor for Flutter web **wasm** builds (`package:web` + js_interop).
class TinyMceEditor extends StatelessWidget {
  final double heightFactor;

  const TinyMceEditor({super.key, this.heightFactor = 0.6});

  static const String _viewType = 'tinymce-editor-view';
  static bool _viewFactoryRegistered = false;
  static web.HTMLIFrameElement? _iframe;
  static Completer<String?>? _contentCompleter;
  static JSFunction? _messageListener;
  static String? _pendingContent;

  static const String _iframeSrc =
      '/assets/packages/tiny_flutter/assets/tinymce_editor.html';

  static void _ensureViewFactoryRegistered() {
    if (_viewFactoryRegistered) return;
    _viewFactoryRegistered = true;

    void onMessage(web.Event event) {
      final data = (event as web.MessageEvent).data?.dartify();
      if (data is Map && data['type'] == 'editorContent') {
        final completer = _contentCompleter;
        if (completer != null && !completer.isCompleted) {
          completer.complete(data['content'] as String?);
        }
        _contentCompleter = null;
      }
    }

    _messageListener = onMessage.toJS;
    web.window.addEventListener('message', _messageListener!);

    ui.platformViewRegistry.registerViewFactory(_viewType, (int _) {
      final iframe = web.HTMLIFrameElement()
        ..src = _iframeSrc
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%';
      iframe.onload = ((web.Event _) {
        if (_pendingContent != null) {
          iframe.contentWindow?.postMessage(
            {'type': 'setContent', 'content': _pendingContent}.jsify(),
            '*'.toJS,
          );
          _pendingContent = null;
        }
      }).toJS;
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
    iframeWindow.postMessage('getContent'.toJS, '*'.toJS);

    return _contentCompleter!.future.timeout(timeout, onTimeout: () => null);
  }

  static void setEditorContent(String htmlContent) {
    _pendingContent = htmlContent;
    _iframe?.contentWindow?.postMessage(
      {'type': 'setContent', 'content': htmlContent}.jsify(),
      '*'.toJS,
    );
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
