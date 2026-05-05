import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  @override
  void initState() {
    super.initState();
    _connectWebSocket();
    _loadBattery();
  }

  void _connectWebSocket() {
    final ws = GetIt.I<WebSocketService>();
    ws.onPriceUpdate = (msg) {
      try {
        final match = RegExp(r'"bitcoin":"([^"]+)"').firstMatch(msg);
        if (match != null) {
          setState(() => bitcoinPrice = '\$${match.group(1)}');
        }
      } catch (_) {}
    };
    ws.connect();
  }

  Future<void> _loadBattery() async {
    final level = await BatteryService.getBatteryLevel();
    setState(() => batteryLevel = level);
  }

  Future<void> _calculateTax() async {
    setState(() => isCalculating = true);
    await compute(_runHeavyLoop, null);
    if (mounted) {
      setState(() => isCalculating = false);
      BatteryService.showToast('Kalkulasi pajak selesai!');
    }
  }

  static int _runHeavyLoop(void _) {
    return CalculateTaxUseCase().executeHeavyLoop();
  }

  @override
  void dispose() {
    GetIt.I<WebSocketService>().disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFFF6B35), Color(0xFFFFB347)]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Bitcoin (BTC)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text(bitcoinPrice, style: const TextStyle(color: Colors.white)),
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
                  Text('Baterai: ${batteryLevel == -1 ? "?" : batteryLevel}%', style: const TextStyle(color: Colors.white70)),
                ],
              ),
              ElevatedButton(
                onPressed: isCalculating ? null : _calculateTax,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.orange),
                child: isCalculating
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator())
                    : const Text('Kalkulasi Pajak'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}