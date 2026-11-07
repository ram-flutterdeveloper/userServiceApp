import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/utils/common_utils.dart';
import 'package:user_servicehub/core/utils/extensions.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final double? height;
  final double? width;
  final Widget? prefix;
  final Widget? suffix;
  final String? hintText;
  final String? labelText;
  final TextInputType? keyBoardType;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final bool readOnly;
  final bool isEnabledBorder;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final void Function()? onTapOutside;
  final void Function()? onTap;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final double? borderRadius;
  final Color? fillColor;
  final Color? borderColor;
  final InputBorder? enabledBorder;
  final int? maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlign textAlign;
  final double? horizontalContentPadding;
  final double? verticalContentPadding;
  final FocusNode? focusNode;
  final Function()? functionCallOutsideOfTextfield;
  final Widget? counterWidget;

  final Iterable<String>? autofillHints;

  const CustomTextField({
    Key? key,
    this.controller,
    this.hintText,
    this.height,
    this.width,
    this.prefix,
    this.suffix,
    this.validator,
    this.labelText,
    this.keyBoardType,
    this.obscureText = false,
    this.onTapOutside,
    this.textInputAction = TextInputAction.next,
    this.readOnly = false,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.textStyle,
    this.hintStyle,
    this.borderRadius,
    this.fillColor,
    this.borderColor,
    this.enabledBorder,
    this.isEnabledBorder = false,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.textAlign = TextAlign.start,
    this.horizontalContentPadding,
    this.verticalContentPadding,
    this.focusNode,
    this.functionCallOutsideOfTextfield,
    this.counterWidget,
    this.autofillHints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.done,
      autofillHints: autofillHints,
      focusNode: focusNode ?? FocusNode(),
      textAlign: textAlign,
      maxLines: maxLines,
      maxLength: maxLength,
      scrollPhysics: AlwaysScrollableScrollPhysics(),
      scrollPadding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 180,
      ),
      readOnly: readOnly,
      inputFormatters: inputFormatters,
      validator: validator,
      controller: controller,
      style: textStyle ?? context.bodyTxtStyle,
      obscureText: obscureText,
      keyboardType: keyBoardType,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          borderSide: BorderSide(color: Colors.red),
        ),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          borderSide: const BorderSide(color: AppColors.primary, width: 1),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),

      // decoration: InputDecoration(
      //   filled: true,
      //   fillColor: Color(0xFFE0E0E0),
      //   border: OutlineInputBorder(
      //     borderRadius: BorderRadius.all(Radius.circular(20)),
      //     borderSide: BorderSide.none,
      //   ),
      //   counter: counterWidget,
      //   hintStyle:
      //       hintStyle ??
      //       context.subTitleTxtStyleblack.copyWith(
      //         color: context.appColor.lightBlackColor,
      //       ),
      //   labelStyle: context.subTitleTxtStyleblack.copyWith(
      //     color: context.appColor.blackColor,
      //     fontSize: 16.sp,
      //   ),
      //   contentPadding: EdgeInsets.symmetric(
      //     horizontal: horizontalContentPadding ?? 10.w,
      //     vertical: verticalContentPadding ?? 10.h,
      //   ),

      //   labelText: labelText,
      //   hintText: hintText,
      //   prefixIcon: prefix,
      //   suffixIcon: suffix,
      // ),
      onTapOutside: (value) {
        onTapOutside ?? ();
        FocusScope.of(context).unfocus();
        hideKeyBoard();
      },
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      onTap: onTap,
    );
  }
}
