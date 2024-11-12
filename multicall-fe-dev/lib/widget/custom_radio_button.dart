import 'package:flutter/material.dart';

class CustomRadio extends StatefulWidget {
  final int value;
  final int groupValue;
  final void Function(int) onChanged;

  const CustomRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  CustomRadioState createState() => CustomRadioState();
}

class CustomRadioState extends State<CustomRadio> {
  @override
  Widget build(BuildContext context) {
    bool selected = (widget.value == widget.groupValue);

    return GestureDetector(
      onTap: () => widget.onChanged(widget.value),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(4.5),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: selected ? Colors.white : Colors.transparent,
            border: Border.all(
              color: selected ? Colors.green : const Color(0XFFDDE1E4),
            ),
        ),

        child: Icon(
          Icons.circle,
          size: 15,
          color: selected ? Colors.green : const Color(0XFFDDE1E4),
        ),
      ),
    );
  }
}
