import 'package:flutter/material.dart';
import 'package:sheep/util/animation/animation_sizeBox.dart';
import 'package:sheep/util/widgets/custom_text.dart';

 


class ValidateWidget extends FormField {
  ValidateWidget({
    super.onSaved,
    super.validator,
    Widget? child,
    super.key,
  }) : super(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (FormFieldState state) {
            return AnimatedSizeWidget(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Builder(
                    builder: (BuildContext context) {
                      return Column(
                        children: [child!],
                      );
                    },
                  ),
                  if (state.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Builder(
                        builder: (BuildContext context) => CustomText(
                         text:  state.errorText!,
                          color: Colors.red,
                        ),
                      ),
                    )
                ],
              ),
            );
          },
        );
}
