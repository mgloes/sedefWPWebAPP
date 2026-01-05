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
  late html.DivElement _container;

  @override
  void initState() {
    super.initState();
    // DOM ready olmasını bekle ve element oluştur
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _createFullScreenViewer();
      }
    });
  }

  void _createFullScreenViewer() {
    try {
      // Eğer zaten var ise, sil
      final existing = html.document.getElementById('pdf-viewer-container');
      existing?.remove();

      // Ana container - full screen overlay
      _container = html.DivElement()
        ..id = 'pdf-viewer-container'
        ..style.position = 'fixed'
        ..style.top = '0'
        ..style.left = '0'
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.zIndex = '10000'
        ..style.backgroundColor = 'rgba(0, 0, 0, 0.9)'
        ..style.display = 'flex'
        ..style.alignItems = 'center'
        ..style.justifyContent = 'center'
        ..style.padding = '0'
        ..style.margin = '0';

      // İçerik container
      final contentDiv = html.DivElement()
        ..style.width = '95vw'
        ..style.height = '95vh'
        ..style.maxWidth = '1600px'
        ..style.maxHeight = '900px'
        ..style.backgroundColor = 'white'
        ..style.borderRadius = '8px'
        ..style.position = 'relative'
        ..style.overflow = 'hidden'
        ..style.boxShadow = '0 10px 50px rgba(0, 0, 0, 0.5)'
        ..style.display = 'flex'
        ..style.flexDirection = 'column';

      // Header container
      final headerDiv = html.DivElement()
        ..style.height = '50px'
        ..style.backgroundColor = '#f5f5f5'
        ..style.borderBottom = '1px solid #e0e0e0'
        ..style.display = 'flex'
        ..style.alignItems = 'center'
        ..style.justifyContent = 'space-between'
        ..style.padding = '0 16px'
        ..style.flexShrink = '0';

      // Title
      final titleSpan = html.SpanElement()
        ..text = 'PDF Dosyasını Görüntüle'
        ..style.fontSize = '16px'
        ..style.fontWeight = 'bold'
        ..style.color = '#333';

      // Close button
      final closeBtn = html.ButtonElement()
        ..text = '✕'
        ..style.position = 'relative'
        ..style.width = '40px'
        ..style.height = '40px'
        ..style.border = 'none'
        ..style.borderRadius = '50%'
        ..style.backgroundColor = '#FF6B6B'
        ..style.color = 'white'
        ..style.fontSize = '24px'
        ..style.cursor = 'pointer'
        ..style.padding = '0'
        ..style.display = 'flex'
        ..style.alignItems = 'center'
        ..style.justifyContent = 'center'
        ..onClick.listen((_) {
          _closeViewer();
        });

      headerDiv.append(titleSpan);
      headerDiv.append(closeBtn);

      // PDF container
      final pdfDiv = html.DivElement()
        ..style.flex = '1'
        ..style.overflow = 'hidden'
        ..style.backgroundColor = '#f0f0f0';

      // Google Docs Viewer URL
      final viewerUrl = 'https://docs.google.com/gview?url=${Uri.encodeComponent(widget.pdfUrl)}&embedded=true';

      // iframe
      final iframe = html.IFrameElement()
        ..src = viewerUrl
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.border = 'none'
        ..allowFullscreen = true;

      // Sandbox ayarları (null safety)
      if (iframe.sandbox != null) {
        iframe.sandbox!.add('allow-same-origin');
        iframe.sandbox!.add('allow-scripts');
      }

      // Error handling
      iframe.onError.listen((_) {
        print('PDF iframe yükleme hatası');
      });

      pdfDiv.append(iframe);
      contentDiv.append(headerDiv);
      contentDiv.append(pdfDiv);
      _container.append(contentDiv);

      // DOM'a ekle
      html.document.body?.insertBefore(_container, html.document.body?.firstChild);
    } catch (e) {
      print('PDF viewer oluşturma hatası: $e');
      Navigator.of(context).pop();
    }
  }

  void _closeViewer() {
    try {
      if (_container.parent != null) {
        _container.remove();
      }
    } catch (e) {
      print('Container silme hatası: $e');
    }
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    try {
      final container = html.document.getElementById('pdf-viewer-container');
      if (container != null && container.parent != null) {
        container.remove();
      }
    } catch (e) {
      print('Dispose sırasında hatası: $e');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build metodunda bir şey render etme, sadece HTML'ye bırak
    return WillPopScope(
      onWillPop: () async {
        _closeViewer();
        return false;
      },
      child: const SizedBox(),
    );
  }
}

