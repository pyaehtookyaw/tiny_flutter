# tiny_flutter

A Flutter package that embeds **TinyMCE** in your app on **Flutter web** using `HtmlElementView`. The package ships the editor shell as an asset; your app composes labels, dialogs, and layout around [`TinyMceEditorWidget`](lib/src/tiny_mce_editor_widget_web.dart).

## Features

✅ **Web** — Rich text editing via TinyMCE inside Flutter web.  
✅ **Lightweight API** — One widget plus `getEditorContent` / `setEditorContent`.  
✅ **No extra runtime deps** — Only `flutter` SDK; TinyMCE loads from CDN in the bundled HTML.

## Getting started

Add `tiny_flutter` to your `pubspec.yaml`:

```yaml
dependencies:
  tiny_flutter:
    path: ../tiny_flutter # or pub.dev / git
```

Import the library:

```dart
import 'package:tiny_flutter/tiny_flutter.dart';
```

## Demo

![Tiny Flutter — Flutter web example](screenshots/tiny_flutter_demo.gif)

## Screenshots (Web)

| ![Create article dialog](screenshots/tiny_flutter_create_web.png) | ![Update article dialog](screenshots/tiny_flutter_update_web.png) |
| :--: | :--: |
| Create article (empty editor) | Update article (demo HTML in editor) |

## Example usage

Place [`TinyMceEditorWidget`](lib/src/tiny_mce_editor_widget_web.dart) where you need the editor (often inside a dialog or a `Row` with your own “Article content” label):

```dart
import 'package:flutter/material.dart';
import 'package:tiny_flutter/tiny_flutter.dart';

class ArticleBody extends StatelessWidget {
  const ArticleBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 1,
          child: Row(
            children: [
              Text('* ', style: TextStyle(color: Colors.red.shade700)),
              const Expanded(
                child: Text(
                  'Article content',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        const Flexible(
          flex: 5,
          child: TinyMceEditorWidget(heightFactor: 0.35),
        ),
      ],
    );
  }
}

Future<void> readAndSave() async {
  final html = await TinyMceEditorWidget.getEditorContent();
  TinyMceEditorWidget.setEditorContent('<p>Hello</p>');
  // use html (e.g. send to API)
}
```

A full flow (home buttons, white dialogs, create vs update) lives in the [`example`](example/lib/main.dart) app — run from the `example/` folder on web.
