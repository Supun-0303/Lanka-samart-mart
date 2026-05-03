import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math';

class ShakeDetector {
  static const double shakeThresholdGravity = 2.7;
  static const int shakeSlopTimeMS = 500;
  static const int shakeCountResetTime = 3000;

  int shakeCount = 0;
  DateTime? lastShakeTime;
  DateTime? lastShakeCountResetTime;

  final Function onShakeDetected;

  ShakeDetector({required this.onShakeDetected});

  void startListening() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      _checkShake(event.x, event.y, event.z);
    });
  }

  void _checkShake(double x, double y, double z) {
    double acceleration = sqrt(x * x + y * y + z * z);

    if (acceleration > shakeThresholdGravity) {
      DateTime now = DateTime.now();

      if (lastShakeTime == null) {
        lastShakeTime = now;
        shakeCount = 1;
        lastShakeCountResetTime = now;
        return;
      }

      int timeSinceLastShake = now.difference(lastShakeTime!).inMilliseconds;

      if (timeSinceLastShake > shakeSlopTimeMS) {
        if (now.difference(lastShakeCountResetTime!).inMilliseconds >
            shakeCountResetTime) {
          shakeCount = 1;
          lastShakeCountResetTime = now;
        } else {
          shakeCount++;
        }

        lastShakeTime = now;

        if (shakeCount >= 3) {
          onShakeDetected();
          shakeCount = 0;
        }
      }
    }
  }
}
