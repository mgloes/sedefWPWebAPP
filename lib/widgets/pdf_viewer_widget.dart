import 'package:flutter/material.dart';
import 'dart:html' as html;

class PdfViewerWidget extends StatefulWidget {
  final String pdfUrl;

  const PdfViewerWidget({
    Key? key,
    required this.pdfUrl,
  }) : super(key: key);

  @override
  State<PdfViewerWidget> createState() => _PdfViewerWidgetState();
}

class _PdfViewerWidgetState extends State<PdfViewerWidget> {
  final String _containerId = 'pdf-fullscreen-${DateTime.now().millisecondsSinceEpoch}';
  late html.DivElement _container;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _createFullScreenPdf();
    });
  }

  void _createFullScreenPdf() {
    // Ana container - full screen overlay
    _container = html.DivElement()
      ..id = _containerId
      ..style.position = 'fixed'
      ..style.top = '0'
      ..style.left = '0'
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.zIndex = '10000'
      ..style.backgroundColor = 'rgba(0, 0, 0, 0.85)'
      ..style.display = 'flex'
      ..style.alignItems = 'center'
      ..style.justifyContent = 'center'
      ..style.padding = '0';

    // İçerik container
    final contentDiv = html.DivElement()
      ..style.width = '95%'
      ..style.height = '95%'
      ..style.maxWidth = '1400px'
      ..style.backgroundColor = 'white'
      ..style.borderRadius = '8px'
      ..style.position = 'relative'
      ..style.overflow = 'hidden'
      ..style.boxShadow = '0 10px 40px rgba(0, 0, 0, 0.3)';

    // Close button
    final closeBtn = html.ButtonElement()
      ..text = '✕'
      ..style.position = 'absolute'
      ..style.top = '12px'
      ..style.right = '12px'
      ..style.width = '44px'
      ..style.height = '44px'
      ..style.border = 'none'
      ..style.borderRadius = '50%'
      ..style.backgroundColor = '#FF6B6B'
      ..style.color = 'white'
      ..style.fontSize = '32px'
      ..style.cursor = 'pointer'
      ..style.zIndex = '10001'
      ..style.display = 'flex'
      ..style.alignItems = 'center'
      ..style.justifyContent = 'center'
      ..onClick.listen((_) {
        _container.remove();
        Navigator.of(context).pop();
      });

    // Google Docs Viewer URL'si (indirme sorununu çözer)
    final viewerUrl = 'https://docs.google.com/gview?url=${Uri.encodeComponent(widget.pdfUrl)}&embedded=true';

    // PDF iframe
    final iframe = html.IFrameElement()
      ..src = viewerUrl
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.border = 'none'
      ..style.borderRadius = '8px'
      ..allow = 'autoplay';

    contentDiv.append(iframe);
    contentDiv.append(closeBtn);
    _container.append(contentDiv);
    html.document.body?.append(_container);
  }

  @override
  void dispose() {
    _container.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Widget boş - PDF HTML'de gösteriliyor
    return const SizedBox();
  }
}
