import 'package:flutter/material.dart';
import 'package:lukyui/lukyui_components.dart';

class LukyPaswordEdittingController extends TextEditingController {
  LukyPaswordEdittingController({
    super.text,
    this.isObscure = true,
    this.isPassword = false,
  });

  bool isObscure;
  bool isPassword;

  void toggleObscure() {
    isObscure = !isObscure;
    notifyListeners();
  }

  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    final theme = Luky.of(context).theme;
    assert(!value.composing.isValid ||
        !withComposing ||
        value.isComposingRangeValid);

    List<TextSpan> textSpans = [];
    if (isObscure) {
      for (int i = 0; i < value.text.length; i++) {
        textSpans.add(TextSpan(
            text: isObscure ? null : value.text[i],
            children: !isObscure
                ? null
                : [
                    WidgetSpan(
                        child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: style?.wordSpacing ?? 1, vertical: 5),
                      child: Icon(
                        Icons.circle,
                        size:
                            (style?.fontSize ?? theme.fontSize.textBase) * 0.7,
                        color: style?.color,
                      ),
                    ))
                  ]));
      }
    } else {
      textSpans.add(TextSpan(text: value.text));
    }

    return TextSpan(
      style: style,
      children: textSpans,
    );
  }
}
