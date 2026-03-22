import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_receipt/pages/qrCodeResponse/failed.dart';
import 'package:get_receipt/pages/qrCodeResponse/success.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../helpers/utils.dart';
import '../services/mainservice.dart';
import '../widgets/qrScannerOverlay.dart';

class QrCodeScan extends StatefulWidget {
  const QrCodeScan({Key? key}) : super(key: key);

  @override
  State<QrCodeScan> createState() => _QrCodeScanState();
}

class _QrCodeScanState extends State<QrCodeScan> {
  late final MobileScannerController cameraController;
  StreamSubscription<BarcodeCapture>? _barcodeSubscription;
  bool _screenOpened = false;

  @override
  void initState() {
    super.initState();
    cameraController = MobileScannerController();

    // Start listening to barcodes
    _barcodeSubscription = cameraController.barcodes.listen((capture) {
      for (final barcode in capture.barcodes) {
        _onBarcodeDetected(barcode);
        // Optionally break after first to avoid multiple triggers
        break;
      }
    });
  }

  @override
  void dispose() {
    _barcodeSubscription?.cancel();
    cameraController.dispose();
    super.dispose();
  }

  void _onBarcodeDetected(Barcode barcode) async {
    if (_screenOpened) return;

    _screenOpened = true;
    // Optionally stop scanning
    cameraController.stop();

    final String code = barcode.rawValue ?? "";
    UserInfoService userInfo =
    Provider.of<UserInfoService>(context, listen: false);
    bool exists = await readByBarcode(code, userInfo);

    if (exists) {
      // Navigate to success page
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SuccessPage(errorText: "Correct Receipt"),
          ),
        );
      }
    } else {
      // Reset flag so future scans can open screens
      _screenOpened = false;

      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const FailedPage(
              errorText: "Invalid Receipt",
              callPhone: '(+8199)',
              rewardText: 'Please Call now & Claim Reward!',
            ),
          ),
        );
      }
    }
  }

  Future<bool> readByBarcode(
      String barcode, UserInfoService userInfo) async {
    bool exist = await userInfo.checkIfQrcodeExist(barcode);
    return exist;
  }

  void _toggleTorch() {
    cameraController.toggleTorch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Utils.mainAppNav.currentState!.pushNamed('/welcomepage');
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.green),
        actions: [
          IconButton(
            onPressed: _toggleTorch,
            iconSize: 32,
            icon: ValueListenableBuilder<MobileScannerState>(
              valueListenable: cameraController,
              builder: (context, state, child) {
                switch (state.torchState) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                  case TorchState.unavailable:
                    return const Icon(Icons.flash_off, color: Colors.red);
                }
                return const Icon(Icons.flash_off, color: Colors.grey);
              },
            )
          ),
        ],
      ),
      body: Stack(
        children: [
          // The camera / scanner view
          MobileScanner(
            key: ValueKey('mobile-scanner'), // new added
            controller: cameraController,
            // The new version doesn’t use onDetect parameter
            // you already listen via controller.barcodes in initState
          ),
          // Your overlay widget
          QRScannerOverlay(
          overlayColour: Colors.black54,
          ),
        ],
      ),
    );
  }
}
