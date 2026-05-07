import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  // URL sesuai spesifikasi tugas 
  static const String _bitcoinUrl = 'wss://ws.coincap.io/prices?assets=bitcoin';
  WebSocketChannel? _channel;

  /// Fungsi ini mengembalikan Stream berupa harga Bitcoin (String)
  /// yang bisa langsung didengarkan (listen) oleh Cubit kamu.
  Stream<String> get bitcoinPriceStream {
    // Membuka koneksi
    _channel = WebSocketChannel.connect(Uri.parse(_bitcoinUrl));

    // Mengolah data mentah dari WebSocket menjadi angka harga saja
    return _channel!.stream.map((message) {
      try {
        // Data dari Coincap formatnya: {"bitcoin":"63450.10"}
        final Map<String, dynamic> data = jsonDecode(message);
        return data['bitcoin'].toString();
      } catch (e) {
        return "Error parsing";
      }
    }).asBroadcastStream(); 
    // asBroadcastStream agar bisa didengarkan oleh banyak listener jika perlu
  }

  void disconnect() {
    _channel?.sink.close();
  }
}