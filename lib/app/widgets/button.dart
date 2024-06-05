import 'package:dimipay_design_kit/dimipay_design_kit.dart';
import 'package:flutter/material.dart';

class DPButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final BoxBorder? border;

  const DPButton({
    Key? key,
    this.onTap,
    this.backgroundColor,
    this.border,
    this.foregroundColor,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DPColors colorTheme = Theme.of(context).extension<DPColors>()!;
    DPTypography textTheme = Theme.of(context).extension<DPTypography>()!;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          decoration: BoxDecoration(
            color: backgroundColor ?? colorTheme.primaryBrand,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: border,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: DefaultTextStyle.merge(
                style: textTheme.itemDescription.copyWith(color: foregroundColor ?? Colors.white),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
