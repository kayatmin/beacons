//  Copyright (c) 2018 Loup Inc.
//  Licensed under Apache License v2.0

part of beacons;

Future<dynamic> _invokeChannelMethod(String tag, MethodChannel channel, String method, [dynamic arguments]) async {
  _log('invoke ${channel.name}->$method $arguments', tag: tag);
  String data;
  try {
    data = await channel.invokeMethod(method, arguments);
  } catch (exception, stack) {
    FlutterError.reportError(new FlutterErrorDetails(
      exception: exception,
      stack: stack,
      library: 'beacons',
    ));
  }

  _log(data ?? 'finished without data', tag: tag);
  return data;
}
