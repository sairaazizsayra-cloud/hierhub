import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double height;

  const AppLogo({super.key, this.height = 160});

  @override
  Widget build(BuildContext context) {
    // Chrome/web can fail with AssetManifest.bin.json; keep a branded fallback.
    return Image.asset(
      'assets/logo.png',
      height: height,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      errorBuilder: (context, error, stackTrace) {
        if (kIsWeb) {
          return Image.network(
            Uri.base.resolve('logo.png').toString(),
            height: height,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
            errorBuilder: (_, __, ___) => _HireHubFallback(height: height),
          );
        }
        return _HireHubFallback(height: height);
      },
    );
  }
}

class _HireHubFallback extends StatelessWidget {
  final double height;

  const _HireHubFallback({required this.height});

  @override
  Widget build(BuildContext context) {
    final markSize = height * 0.62;
    return SizedBox(
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: markSize,
            height: markSize,
            child: const CustomPaint(painter: _HireHubMarkPainter()),
          ),
          SizedBox(height: height * 0.04),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: height * 0.14,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.2,
              ),
              children: const [
                TextSpan(
                  text: 'Hire',
                  style: TextStyle(color: Color(0xFF4C6FFF)),
                ),
                TextSpan(
                  text: 'Hub',
                  style: TextStyle(color: Color(0xFF22D3EE)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HireHubMarkPainter extends CustomPainter {
  const _HireHubMarkPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final cyan = Paint()..color = const Color(0xFF22D3EE);
    final blue = Paint()..color = const Color(0xFF4C6FFF);
    final w = size.width;
    final h = size.height;

    final leftBar = Path()
      ..moveTo(w * 0.20, h * 0.10)
      ..lineTo(w * 0.38, h * 0.10)
      ..lineTo(w * 0.38, h * 0.90)
      ..lineTo(w * 0.20, h * 0.90)
      ..close();
    canvas.drawPath(leftBar, cyan);

    final rightBar = Path()
      ..moveTo(w * 0.62, h * 0.10)
      ..lineTo(w * 0.80, h * 0.10)
      ..lineTo(w * 0.80, h * 0.90)
      ..lineTo(w * 0.62, h * 0.90)
      ..close();
    canvas.drawPath(rightBar, cyan);

    final ribbon = Path()
      ..moveTo(w * 0.20, h * 0.58)
      ..lineTo(w * 0.38, h * 0.46)
      ..lineTo(w * 0.80, h * 0.18)
      ..lineTo(w * 0.80, h * 0.38)
      ..lineTo(w * 0.42, h * 0.64)
      ..lineTo(w * 0.20, h * 0.78)
      ..close();
    canvas.drawPath(ribbon, blue);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
