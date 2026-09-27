//B Munezero Ami christian
//2401000232
import 'package:flutter/material.dart';

class MockInterstitialAd extends StatelessWidget {
  const MockInterstitialAd({super.key});

  static Future<void> show(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black87,
      builder: (context) {
        return const MockInterstitialAd();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 430),
        decoration: BoxDecoration(
          color: const Color(0xFF0C1913),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withOpacity(0.10)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded, color: Colors.white70),
              ),
            ),
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF6DDB78).withOpacity(0.12),
              ),
              child: const Icon(
                Icons.fitness_center_rounded,
                size: 52,
                color: Color(0xFF6DDB78),
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'YOUR FITNESS,\nYOUR PROGRESS.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                height: 1.1,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Stay consistent, track every workout, and keep moving toward your goals.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 28),
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF6DDB78),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Center(
                child: Text(
                  'GET STARTED',
                  style: TextStyle(
                    color: Color(0xFF07110D),
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'ADVERTISEMENT',
              style: TextStyle(
                color: Colors.white30,
                fontSize: 9,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}
