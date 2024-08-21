import 'package:dimipay_app_v2/app/pages/admin/sync_product/controller.dart';
import 'package:dimipay_app_v2/app/widgets/appbar.dart';
import 'package:dimipay_app_v2/app/widgets/button.dart';
import 'package:dimipay_app_v2/app/widgets/dp_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SyncProductPage extends GetView<SyncProductPageController> {
  const SyncProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const DPAppbar(
              header: '상품 가격 동기화',
            ),
            const Spacer(
              flex: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  GetBuilder<SyncProductPageController>(
                    id: 'barcodeField',
                    builder: (_) => DPTextField(
                      labelText: '상품 바코드',
                      hintText: 'ex) 888132323',
                      controller: controller.barcodeController,
                      focusNode: controller.barcodeFocusNode,
                      hilightOnFocus: true,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Obx(
                    () {
                      if (controller.isSyncProductProgress) {
                        return DPButton.loading();
                      } else {
                        return DPButton(
                          onTap: controller.syncProduct,
                          child: const Text('가격 동기화'),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            const Spacer(
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }
}
