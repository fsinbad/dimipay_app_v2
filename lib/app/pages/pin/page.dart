import 'package:dimipay_app_v2/app/pages/pin/controller.dart';
import 'package:dimipay_app_v2/app/pages/pin/widget/pin_page_base.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PinPage extends GetView<PinPageController> {
  const PinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Builder(
        builder: (context) {
          switch (controller.pinPageType) {
            case PinPageType.unlock:
              return const UnlockPinPage();
            case PinPageType.onboarding:
              return const OnboardingPinPage();
            case PinPageType.editPin:
              return const EditPinPage();
            case PinPageType.register:
              return const RegisterPinPage();
            default:
              return const UnlockPinPage();
          }
        },
      ),
    );
  }
}

class RegisterPinPage extends GetView<PinPageController> {
  const RegisterPinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        switch (controller.status) {
          case PinPageStatus.nomal:
            return PinPageBase(
              headerText: '앞으로 사용할\n핀을 입력해주세요',
              onPinComplete: controller.registerPinNomal,
              // pinCouont: controller.pinCount,
              // showForgotPasswordMessage: '결제 핀을 잊어버렸어요',
            );
          case PinPageStatus.doubleCheck:
            return PinPageBase(
              headerText: '다시 한번 입력해주세요\n',
              onPinComplete: controller.registerPinDoubleCheck,
              // pinCouont: controller.pinCount,
              // showForgotPasswordMessage: '결제 핀을 잊어버렸어요',
            );
          default:
            return Container();
        }
      },
    );
  }
}

class OnboardingPinPage extends GetView<PinPageController> {
  const OnboardingPinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PinPageBase(
        headerText: '로그인을 완료하기 위해\n핀을 입력해주세요',
        onPinComplete: controller.onboardingAuth,
        pinCouont: controller.pinCount,
        // showForgotPasswordMessage: '결제 핀을 잊어버렸어요',
      ),
    );
  }
}

class UnlockPinPage extends GetView<PinPageController> {
  const UnlockPinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PinPageBase(
        headerText: '핀을 입력해\n잠금을 해제하세요',
        onPinComplete: controller.pinCheck,
        pinCouont: controller.pinCount,
        faceIDAvailable: true,
      ),
    );
  }
}

class EditPinPage extends GetView<PinPageController> {
  const EditPinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        switch (controller.status) {
          case PinPageStatus.preCheck:
            return PinPageBase(
              headerText: '기존의 결제 핀을\n입력해주세요',
              onPinComplete: controller.changePinPreCheck,
              pinCouont: controller.pinCount,
            );
          case PinPageStatus.nomal:
            return PinPageBase(
              headerText: '앞으로 사용할\n새 결제 핀을 입력해주세요',
              onPinComplete: controller.changePinNomal,
              pinCouont: controller.pinCount,
            );
          case PinPageStatus.doubleCheck:
            return PinPageBase(
              headerText: '앞으로 사용할\n결제 핀을 다시 입력해주세요',
              onPinComplete: controller.changePinDoubleCheck,
              pinCouont: controller.pinCount,
            );
        }
      },
    );
  }
}
