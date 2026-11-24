import 'package:app_links/app_links.dart';
import 'package:hiddify/core/router/deep_linking/url_protocol/api.dart';
import 'package:hiddify/utils/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_app_links.g.dart';

@riverpod
Stream<String> myAppLinks(Ref ref) async* {
  // Do not take over existing Hiddify URL associations in a portable preview.
  if (PlatformUtils.isWindows && !const bool.fromEnvironment('doomnet_windows_preview')) {
    for (final protocol in LinkParser.protocols) {
      registerProtocolHandler(protocol);
    }
  }
  yield* AppLinks().uriLinkStream.map((event) => event.toString());
}
