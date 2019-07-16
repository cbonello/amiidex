import 'package:flutter/material.dart';
import 'package:amiidex/providers/view_as.dart';

int columnsCount(BuildContext context, ViewAsProvider viewAsProvider) {
  final double width = MediaQuery.of(context).size.width;

  if (MediaQuery.of(context).orientation == Orientation.portrait) {
    if (width <= 480) {
      return viewAsProvider.viewAs == DisplayType.grid_small ? 3 : 2;
    } else if (width <= 600) {
      return viewAsProvider.viewAs == DisplayType.grid_small ? 4 : 3;
    } else {
      return viewAsProvider.viewAs == DisplayType.grid_small ? 5 : 4;
    }
  } else {
    if (width <= 600) {
      return viewAsProvider.viewAs == DisplayType.grid_small ? 4 : 3;
    } else if (width <= 960) {
      return viewAsProvider.viewAs == DisplayType.grid_small ? 5 : 4;
    } else {
      return viewAsProvider.viewAs == DisplayType.grid_small ? 6 : 5;
    }
  }
}
