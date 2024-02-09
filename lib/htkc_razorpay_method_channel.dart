import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'htkc_razorpay_platform_interface.dart';

/// An implementation of [HCRazorpayPlatform] that uses method channels.
class MethodChannelHCRazorpay extends HCRazorpayPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('htkc_razorpay');

  @override
  getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
