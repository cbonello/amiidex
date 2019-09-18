import 'package:amiidex/util/theme.dart';
import 'package:flutter/material.dart';

class Flag extends StatelessWidget {
  const Flag({
    Key key,
    @required this.asset,
    this.height = 24.0,
    this.width = 40.0,
    this.onTap,
  }) : super(key: key);

  final String asset;
  final double height, width;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: onTap == null ? Colors.grey[400] : lightBlueColor,
          ),
        ),
        child: Image.asset(
          asset,
          height: height,
          width: width,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
