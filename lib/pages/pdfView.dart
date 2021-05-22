

import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';

import 'package:quarry/styles/app_theme.dart';
import 'package:share_extend/share_extend.dart';

class PdfViewerPage extends StatelessWidget {
  final String path;
  final String filename;
  const PdfViewerPage({Key key, this.path,this.filename}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.yellowColor,
        actions: [
          IconButton(icon: Icon(Icons.share), onPressed: (){
            ShareExtend.share(path,filename,sharePanelTitle: "$filename");
          })
        ],
      ),
      path: path,
    );
  }
}
