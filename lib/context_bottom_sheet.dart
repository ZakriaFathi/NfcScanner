/*
 * Created by Mr4G.
 * Copyright © 2022 Mr4G. All rights reserved.
 */

import 'package:flutter/material.dart';

extension BottomSheetHelper on BuildContext {
  void showBottomSheeT(Widget content) => showBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
    ),
    context: this,
    builder: (ctx) => content,
  );
}
