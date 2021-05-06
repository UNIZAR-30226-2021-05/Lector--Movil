import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

//TODO: DISEÑAR LA GESTIÓN DEL BUFFER DE TEXTO
//TODO: IMPLEMENTAR BUFFER CON COLA CIRCULAR
//TODO: GESTIONAR LOS OFFSETS(CURRENTOFFSET, INITBUFFEROFFSET).
class BookPage extends StatefulWidget {
  final String path;
  const BookPage({Key key, this.path}) : super(key: key);

  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  Map data = {};
  bool loaded = false;
  int pages = 0;
  int currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
  int currentOffset; //Offset actual
  String pathPDF = "";
  String landscapePathPdf = "";
  String remotePDFpath = "";
  String corruptedPathPDF = "";

  @override
  void initState() {
    super.initState();
  }

  Future<File> createFileOfPdfUrl() async {
    Completer<File> completer = Completer();
    try {
      final url = data["book"].url;
      print("Esta es la url del librooooo: " + url);
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      print("${dir.path}/$filename");
      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error al parsear el documento');
    }

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    print("El titulo eeeeeeeeeeeeeeeeeees: *******" + data["book"].title);
    cargarFichero();
    if (loaded) {
      return Scaffold(
          body: PDFScreen(path: remotePDFpath, titulo: data["book"].title));
    } else {
      return Scaffold(
          backgroundColor: Colors.orange[200],
          body: Center(child: CircularProgressIndicator()));
    }
  }

  cargarFichero() {
    createFileOfPdfUrl().then((f) {
      setState(() {
        remotePDFpath = f.path;
        loaded = true;
      });
    });
  }
}

class PDFScreen extends StatefulWidget {
  final String path;
  final String titulo;

  PDFScreen({Key key, this.path, this.titulo}) : super(key: key);

  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int pages = 0;
  int currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: true,
            pageSnap: true,
            defaultPage: currentPage,
            fitPolicy: FitPolicy.BOTH,
            preventLinkNavigation:
                false, // if set to true the link is handled in flutter
            onRender: (_pages) {
              setState(() {
                pages = _pages;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
              print(error.toString());
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
              });
              print('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
            onLinkHandler: (String uri) {
              print('goto uri: $uri');
            },
            onPageChanged: (int page, int total) {
              print('page change: $page/$total');
              setState(() {
                currentPage = page;
              });
            },
          ),
          errorMessage.isEmpty
              ? !isReady
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container()
              : Center(
                  child: Text(errorMessage),
                )
        ],
      ),
      floatingActionButton: FutureBuilder<PDFViewController>(
        future: _controller.future,
        builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
          if (snapshot.hasData) {
            return FloatingActionButton.extended(
              label: Text("Go to ${pages ~/ 2}"),
              onPressed: () async {
                await snapshot.data.setPage(pages ~/ 2);
              },
            );
          }

          return Container();
        },
      ),
    );
  }
}
