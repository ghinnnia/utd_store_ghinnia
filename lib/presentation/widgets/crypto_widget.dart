import 'dart:async'; // Tambahkan ini untuk StreamSubscription
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import '../../core/platform/battery_service.dart';
import '../../data/services/websocket_service.dart';
import '../../domain/usecases/calculate_tax_usecase.dart';

class CryptoWidget extends StatefulWidget {
  const CryptoWidget({super.key});

  @override
  State<CryptoWidget> createState() => _CryptoWidgetState();
}

class _CryptoWidgetState extends State<CryptoWidget> {
  String bitcoinPrice = 'Loading...';
  int batteryLevel = -1;
  bool isCalculating = false;
  
  // Tambahkan subscription agar bisa memantau stream secara real-time
  StreamSubscription? _cryptoSubscription;

  @override
  void initState() {
    super.initState();
    _listenToPriceUpdates(); // Gunakan fungsi baru yang berbasis Stream
    _loadBattery();
  }

  // PERBAIKAN UTAMA: Menggunakan Stream.listen, bukan Callback/Connect manual
  void _listenToPriceUpdates() {
    final ws = GetIt.I<WebSocketService>();
    
    // Mendengarkan stream harga dari service yang sudah kita perbaiki tadi
    _cryptoSubscription = ws.bitcoinPriceStream.listen(
      (price) {
        if (mounted) {
          setState(() {
            bitcoinPrice = '\$$price';
          });
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() => bitcoinPrice = 'Error connection');
        }
      },
    );
  }

  Future<void> _loadBattery() async {
    final level = await BatteryService.getBatteryLevel();
    setState(() => batteryLevel = level);
  }

  Future<void> _calculateTax() async {
    setState(() => isCalculating = true);
    
    // LOGIKA PERSONAL: Pastikan CalculateTaxUseCase().executeHeavyLoop() 
    // sudah mengandung perulangan [2 Digit NIM] x 10.000.000
    await compute(_runHeavyLoop, null);
    
    if (mounted) {
      setState(() => isCalculating = false);
      // Memanggil Native Toast melalui MethodChannel
      BatteryService.showToast('Kalkulasi pajak selesai!');
    }
  }

  // Fungsi isolate harus static agar bisa dipanggil oleh compute
  static int _runHeavyLoop(void _) {
    return CalculateTaxUseCase().executeHeavyLoop();
  }

  @override
  void dispose() {
    // Kritis: Batalkan subscription agar tidak terjadi memory leak
    _cryptoSubscription?.cancel();
    GetIt.I<WebSocketService>().disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B35), Color(0xFFFFB347)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Bitcoin (BTC)',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              // Harga akan terupdate otomatis di sini
              Text(
                bitcoinPrice,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.battery_std, color: Colors.white),
                  const SizedBox(width: 4),
                  Text(
                    'Baterai: ${batteryLevel == -1 ? "?" : batteryLevel}%',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: isCalculating ? null : _calculateTax,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.orange,
                ),
                child: isCalculating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Kalkulasi Pajak'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}