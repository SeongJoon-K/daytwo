import 'package:flutter/widgets.dart';

export '../widgets/common/primary_button.dart';
export '../widgets/common/secondary_button.dart';
export '../widgets/common/daytwo_app_bar.dart';
export '../widgets/common/daytwo_icon_button.dart';
export '../widgets/common/common_padding_box.dart';
export '../widgets/match/rounded_card.dart';

/// Shared radius + elevation contract so custom widgets stay aligned.
class DaytwoComponentTokens {
  DaytwoComponentTokens._();

  static const BorderRadius mediumRadius = BorderRadius.all(Radius.circular(16));
  static const BorderRadius compactRadius = BorderRadius.all(Radius.circular(12));
  static const double elevatedShadow = 8;
}
