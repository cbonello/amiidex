import 'package:flutter/material.dart';
import 'package:amiidex/util/i18n.dart';

Future<void> okDialog(
  BuildContext context,
  Widget title,
  List<Widget> body,
) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: title,
        content: SingleChildScrollView(
          child: ListBody(
            children: body,
          ),
        ),
        actions: <Widget>[
          RaisedButton(
            textColor: Colors.white,
            child: Text(I18n.of(context).text('ok-button')),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ],
      );
    },
  );
}

Future<void> errorDialog(
  BuildContext context,
  Widget title,
  List<Widget> body,
) async {
  await okDialog(
    context,
    Row(
      children: <Widget>[
        const Icon(Icons.error, color: Colors.red),
        const SizedBox(width: 5.0),
        title,
      ],
    ),
    body,
  );
}
