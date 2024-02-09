import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'htkc_razorpay_method_channel.dart';

abstract class HCRazorpayPlatform extends PlatformInterface {
  /// Constructs a HCRazorpayPlatform.
  HCRazorpayPlatform() : super(token: _token);

  static final Object _token = Object();

  static HCRazorpayPlatform _instance = MethodChannelHCRazorpay();

  /// The default instance of [HCRazorpayPlatform] to use.
  ///
  /// Defaults to [MethodChannelHCRazorpay].
  static HCRazorpayPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [HCRazorpayPlatform] when
  /// they register themselves.
  static set instance(HCRazorpayPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
