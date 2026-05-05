import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  static const String _bitcoinUrl = 'wss://ws.coincap.io/prices?assets=bitcoin';
  late WebSocketChannel _channel;
  Function(String)? onPriceUpdate;

  void connect() {
    _channel = WebSocketChannel.connect(Uri.parse(_bitcoinUrl));
    _channel.stream.listen((message) {
      if (onPriceUpdate != null) {
        onPriceUpdate!(message);
      }
    });
  }

  void disconnect() {
    _channel.sink.close();
  }
}