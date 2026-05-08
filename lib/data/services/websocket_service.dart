import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  // URL sesuai spesifikasi tugas 
  static const String _bitcoinUrl = 'wss://ws.coincap.io/prices?assets=bitcoin';
  WebSocketChannel? _channel;

  /// Fungsi ini mengembalikan Stream berupa harga Bitcoin (String)
  Stream<String> get bitcoinPriceStream {
    _channel = WebSocketChannel.connect(Uri.parse(_bitcoinUrl));

    return _channel!.stream.map((message) {
      try {
        // Mendecode pesan JSON dari Coincap 
        final Map<String, dynamic> data = jsonDecode(message as String);
        
        // Mengambil nilai berdasarkan key "bitcoin"
        if (data.containsKey('bitcoin')) {
          return data['bitcoin'].toString();
        }
        return "0.0";
      } catch (e) {
        return "Error Parsing";
      }
    }).asBroadcastStream();
  }

  void disconnect() {
    _channel?.sink.close();
  }
}