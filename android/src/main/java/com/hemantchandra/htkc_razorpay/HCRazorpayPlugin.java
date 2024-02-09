package com.hemantchandra.htkc_razorpay;

import androidx.annotation.NonNull;

import org.json.JSONException;

import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * HCRazorpayPlugin
 */
public class HCRazorpayPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {

  private RazorpayDelegate razorpayDelegate;
  private ActivityPluginBinding pluginBinding;
  private static final String CHANNEL_NAME = "htkc_razorpay";
  Map<String, Object> _arguments;
  String customerMobile ;
  String color;


  public HCRazorpayPlugin() {
  }

  /**
   * Plugin registration for Flutter version < 1.12
   */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), CHANNEL_NAME);
    channel.setMethodCallHandler(new HCRazorpayPlugin(registrar));
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    final MethodChannel channel = new MethodChannel(binding.getBinaryMessenger(), CHANNEL_NAME);
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
  }


  /**
   * Constructor for Flutter version < 1.12
   * @param registrar
   */
  private HCRazorpayPlugin(Registrar registrar) {
    this.razorpayDelegate = new RazorpayDelegate(registrar.activity());
    registrar.addActivityResultListener(razorpayDelegate);
  }

  @Override
  @SuppressWarnings("unchecked")
  public void onMethodCall(MethodCall call, Result result) {


    switch (call.method) {

      case "open":
        razorpayDelegate.openCheckout((Map<String, Object>) call.arguments, result);
        break;

      case "setPackageName":
        razorpayDelegate.setPackageName((String)call.arguments);
        break;

      case "resync":
        razorpayDelegate.resync(result);
        break;

      case "setKeyID":
        String key = call.arguments().toString();
        razorpayDelegate.setKeyID(key,  result);
        break;
      case "linkNewUpiAccount":
        _arguments = call.arguments();
        customerMobile = (String) _arguments.get("customerMobile");
        color = (String) _arguments.get("color");
        razorpayDelegate.linkNewUpiAccount(customerMobile, color , result);
        break;

      case "manageUpiAccounts":
        _arguments = call.arguments();
        customerMobile = (String) _arguments.get("customerMobile");
        color = (String) _arguments.get("color");
        razorpayDelegate.manageUpiAccounts(customerMobile, color , result);
        break;
      case "isTurboPluginAvailable":
        razorpayDelegate.isTurboPluginAvailable(result);
        break;
      default:
        result.notImplemented();

    }

  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    this.razorpayDelegate = new RazorpayDelegate(binding.getActivity());
    this.pluginBinding = binding;
    binding.addActivityResultListener(razorpayDelegate);
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity();
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    onAttachedToActivity(binding);
  }

  @Override
  public void onDetachedFromActivity() {
    pluginBinding.removeActivityResultListener(razorpayDelegate);
    pluginBinding = null;
  }
}
