import 'dart:async';
import 'dart:developer';

import 'package:dimipay_app_v2/app/core/utils/haptic.dart';
import 'package:dimipay_app_v2/app/pages/home/widgets/pay_success.dart';
import 'package:dimipay_app_v2/app/pages/pin/controller.dart';
import 'package:dimipay_app_v2/app/routes/routes.dart';
import 'package:dimipay_app_v2/app/services/auth/service.dart';
import 'package:dimipay_app_v2/app/services/bio_auth/service.dart';
import 'package:dimipay_app_v2/app/services/pay/service.dart';
import 'package:dimipay_app_v2/app/services/payment/service.dart';
import 'package:dimipay_app_v2/app/services/user/service.dart';
import 'package:dimipay_app_v2/app/widgets/snackbar.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:screen_brightness/screen_brightness.dart';

import 'package:get/get.dart';

class HomePageController extends GetxController {
  final UserService userService = Get.find<UserService>();
  final PaymentService paymentService = Get.find<PaymentService>();
  final AuthService authService = Get.find<AuthService>();
  final PayService payService = Get.find<PayService>();
  final LocalAuthService localAuthService = Get.find<LocalAuthService>();

  final Rx<Duration?> timeRemaining = Rx(null);

  late Timer _displayTimer;
  Timer? _qrRefreshTimer;
  double? _screenBrightness;

  @override
  void onReady() {
    userService.fetchUser();
    paymentService.fetchPaymentMethods().then((_) {
      if (authService.bioKey.key != null || authService.pin != null) {
        _requestQR();
      }
    });
    _displayTimer = Timer.periodic(const Duration(seconds: 1), (_) => updateTimeRemainning());

    prefetchAuthAndQR();
    super.onReady();
  }

  Future<bool> biometricAuth() async {
    try {
      final res = await localAuthService.bioAuth();

      if (res) {
        await authService.bioKey.loadBioKey();
        return true;
      }
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        return false;
      } else {
        DPErrorSnackBar().open('생체 인증을 사용할 수 없습니다.(code: ${e.code})');
      }
    }
    return false;
  }

  Future<void> _requestQR() async {
    await payService.fetchPaymentToken(paymentService.mainMethod!);
    reserveQRRefresh(payService.expireAt!);
  }

  Future<void> setBrightness(double brightness) async {
    try {
      _screenBrightness = await ScreenBrightness().system;
      await ScreenBrightness().setScreenBrightness(brightness);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> resetBrightness() async {
    if (_screenBrightness != null) {
      try {
        await ScreenBrightness().setScreenBrightness(_screenBrightness!);
      } catch (e) {
        log(e.toString());
      }
    }
  }

  Future<void> prefetchAuthAndQR() async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (authService.bioKey.key == null) {
      await biometricAuth();
    }
    if (authService.bioKey.key == null && authService.pin == null) {
      await showPinDialog();
    }
    if (authService.bioKey.key == null && authService.pin == null) {
      return;
    }
    if (paymentService.mainMethod != null) {
      await _requestQR();
    }
  }

  Future<void> requestAuthAndQR() async {
    if (paymentService.mainMethod == null) {
      return;
    }
    if (authService.bioKey.key == null) {
      await biometricAuth();
    }
    if (authService.bioKey.key == null && authService.pin == null) {
      await showPinDialog();
    }
    if (authService.bioKey.key == null && authService.pin == null) {
      return;
    }
    await _requestQR();
  }

  void reserveQRRefresh(DateTime refreshAt, {bool recursive = true}) {
    _qrRefreshTimer?.cancel();
    updateTimeRemainning(useHaptic: false);
    Duration awaitTime = refreshAt.difference(DateTime.now());
    _qrRefreshTimer = Timer(awaitTime, () async {
      timeRemaining.value = null;
      await payService.fetchPaymentToken(paymentService.mainMethod!);

      if (recursive) {
        reserveQRRefresh(payService.expireAt!);
        HapticHelper.feedback(HapticPatterns.success, hapticType: HapticType.heavy);
      }
    });
  }

  void updateTimeRemainning({bool useHaptic = true}) {
    if (payService.expireAt == null || paymentService.mainMethod == null || Get.currentRoute != Routes.HOME) {
      timeRemaining.value = null;
      return;
    }
    setBrightness(1);
    timeRemaining.value = payService.expireAt!.difference(DateTime.now());
  }

  void openPaySuccess() {
    showSuccessDialog();
    _requestQR();
  }

  openKakaoChannelTalk() async {
    try {
      if (await isKakaoTalkInstalled()) {
        await launchBrowserTab(await TalkApi.instance.channelChatUrl('_gHxlCxj'));
      } else {
        DPErrorSnackBar().open("카카오톡이 현재 설치되어 있지 않습니다.\n설치 후 다시 시도해 주세요.");
      }
    } catch (error) {
      PlatformException exception = (error as PlatformException);
      if (exception.code != "CANCELED") {
        DPErrorSnackBar().open("카카오톡을 통한 문의 채널 연결에 실패하였습니다.");
      }
    }
  }

  @override
  Future<void> onClose() async {
    _displayTimer.cancel();
    _qrRefreshTimer?.cancel();
    await resetBrightness();
    super.onClose();
  }
}
