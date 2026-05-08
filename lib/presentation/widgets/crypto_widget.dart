import 'dart:async';
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
  StreamSubscription? _cryptoSubscription;

  @override
  void initState() {
    super.initState();
    _listenToPriceUpdates();
    _loadBattery();
  }

  void _listenToPriceUpdates() {
    final ws = GetIt.I<WebSocketService>();
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
    // Mengambil data baterai via MethodChannel [cite: 44, 45]
    final level = await BatteryService.getBatteryLevel();
    setState(() => batteryLevel = level);
  }

  // PERBAIKAN: Fungsi kalkulasi yang sudah dibersihkan
  Future<void> _calculateTax() async {
    setState(() => isCalculating = true);
    
    // Menjalankan Isolate di background [cite: 39, 40]
    // Pastikan CalculateTaxUseCase menggunakan 2 digit terakhir NIM (46)
    final hasilPajak = await compute(_runHeavyLoop, null);
    
    if (mounted) {
      setState(() => isCalculating = false);
      
      // Memunculkan Native Toast Android sesuai instruksi 
      BatteryService.showToast('Kalkulasi Selesai! Hasil: $hasilPajak');
    }
  }

  static int _runHeavyLoop(void _) {
    return CalculateTaxUseCase().executeHeavyLoop();
  }

  @override
  void dispose() {
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
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.orange),
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