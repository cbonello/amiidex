import 'package:flutter/material.dart';

class LabeledButton extends StatelessWidget {
  const LabeledButton({
    this.label = '',
    @required this.padding,
    @required this.buttonLabel,
    this.onPressed,
  });

  final String label, buttonLabel;
  final EdgeInsets padding;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Text(label),
          ),
          Expanded(
            flex: 2,
            child: RaisedButton(onPressed: onPressed, child: Text(buttonLabel)),
          ),
        ],
      ),
    );
  }
}

class LabeledCheckbox extends StatelessWidget {
  const LabeledCheckbox({
    @required this.label,
    @required this.padding,
    @required this.value,
    this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final bool value;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Checkbox(
              value: value,
              onChanged: (bool newValue) => onChanged(newValue),
            ),
            Text(label, semanticsLabel: label),
          ],
        ),
      ),
    );
  }
}

class LabeledRadio<T> extends StatelessWidget {
  const LabeledRadio({
    @required this.label,
    @required this.padding,
    @required this.groupValue,
    @required this.value,
    this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final T groupValue;
  final T value;
  final Function(T) onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (value != groupValue) {
          onChanged(value);
        }
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Radio<T>(
              groupValue: groupValue,
              value: value,
              onChanged: (T newValue) => onChanged(newValue),
            ),
            Text(label),
          ],
        ),
      ),
    );
  }
}
