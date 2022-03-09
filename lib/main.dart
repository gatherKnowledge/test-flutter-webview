import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyWebView().buildWebView(),
    );
  }
}

class MyWebView {
  WebViewController? _webViewController;

  Widget buildWebView() {
      return WebView(
        initialUrl: 'about:blank',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) async {
            _webViewController = webViewController;
            String fileContent = await rootBundle.loadString('assets/index.html');
            _webViewController?.loadUrl(Uri.dataFromString(fileContent, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString());
        },
        javascriptChannels: <JavascriptChannel>{
          JavascriptChannel(
              name: 'messageHandler',
              onMessageReceived: (JavascriptMessage message) {
                  final script = "document.getElementById('value').innerText=\"${message.message}\"";
                  _webViewController?.runJavascript(script);
              },
          )
      },
    );
  }
}
