import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mkpv_socket/mkpv_socket.dart';
import 'package:mkpv_socket/socket/socket_server.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MarkdownViewModel {
  final ValueNotifier<bool> loadingNotifier = ValueNotifier(true);
  late MkpvSocket socket;
  void init() async {
    socket = await MkpvSocket.connect();
    socket.addListener(onData: onData);
    socket.send(Request.connect());
    loadingNotifier.value = false;
  }

  void onData(Request request) {
    switch (request.type) {
      case RequestType.connect:
        break;
      case RequestType.scroll:
        // jumpToScroll(request.data);
        break;
      case RequestType.update:
        updateMarkdown(request.data);
        return;
      case RequestType.close:
        exit(0);
    }
  }

  void dispose() {
    socket.dispose();
  }

  final ValueNotifier<String> markdownNotofier = ValueNotifier("");
  void updateMarkdown(String data) {
    markdownNotofier.value = data;
  }

  final AutoScrollController scrollController = AutoScrollController();
  void jumpToScroll(int line) {
    // scrollController.scrollToIndex(line,
    //     preferPosition: AutoScrollPosition.middle);
  }

  void onTapLink(String text, String? href, String? title) {
    final address = href;
    if (address == null) return;
    launchUrlString(address);
  }

  final ValueNotifier<bool> darkModeNotifier = ValueNotifier(false);

  void onTapMode() {
    darkModeNotifier.value = !darkModeNotifier.value;
  }
}
