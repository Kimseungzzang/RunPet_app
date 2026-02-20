// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

bool _scriptInjected = false;

Widget? buildPet3DWeb({
  required String modelUrl,
  required String animationName,
  required String fallbackLabel,
  required double borderRadius,
}) {
  if (!_scriptInjected) {
    _scriptInjected = true;
    final script = html.ScriptElement()
      ..type = 'module'
      ..src = 'https://unpkg.com/@google/model-viewer/dist/model-viewer.min.js';
    html.document.head?.append(script);
  }

  final viewType = 'pet-model-viewer-${DateTime.now().microsecondsSinceEpoch}';
  // ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
    final container = html.DivElement()
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.borderRadius = '${borderRadius}px'
      ..style.overflow = 'hidden';

    final modelViewer = html.Element.tag('model-viewer')
      ..setAttribute('src', modelUrl)
      ..setAttribute('alt', fallbackLabel)
      ..setAttribute('auto-rotate', '')
      ..setAttribute('camera-controls', '')
      ..setAttribute('disable-zoom', '')
      ..setAttribute('animation-name', animationName)
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.backgroundColor = 'transparent';

    container.children.add(modelViewer);
    return container;
  });

  return HtmlElementView(viewType: viewType);
}
