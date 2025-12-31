import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MoreInfo extends StatefulWidget {
  final String url;
  // url = url.replaceAll('_', " ");

MoreInfo(
  {required this.url}
);

  @override
  MoreInfoState createState() => MoreInfoState();
}

class MoreInfoState extends State<MoreInfo> {
  
// final Completer<WebViewController> =  Completer<>

 final Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    // widget.url = widget.url.replaceAll('_', " ");
    String url1 = widget.url.replaceAll('_', " ");
    String url2 = widget.url.replaceAll(" ", "");
    return Scaffold(
      appBar: AppBar(
        shape: Border(
          bottom: BorderSide(color: Colors.blue, width: 2)
        ),
        title: Text("https://www.google.com/search?q=$url2", style: TextStyle(fontSize: 16, overflow: TextOverflow.ellipsis),),
        titleTextStyle: TextStyle(color: Colors.blue),
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.close, color: Colors.black,)),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        // padding: EdgeInsets.all(16),
        child: WebView(
          initialUrl: 'https://www.google.com/search?q=$url1',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
        ),
      ),
    );
  }
}
