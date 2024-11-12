import 'package:flutter/material.dart';

/// A widget that displays a list of member names in a single line.
/// The names are truncated with an ellipsis if they exceed the available width.
/// The widget also appends "You" or "and You" at the end of the names list.
///
/// Author: Darshak Kakkad
class MembersList extends StatelessWidget {
  final List<String> members;
  final TextStyle? textStyle;

  /// Creates a [MembersList] widget.
  ///
  /// [members] The list of member names to display.
  /// [textStyle] The style to apply to the member names text.
  ///
  /// Author: Darshak Kakkad
  const MembersList({
    super.key,
    required this.members,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        String myName = 'You';
        if (members.isNotEmpty && members.length > 1) members.removeAt(0);
        List<String> displayNames = List.from(members);
        String endText = members.isEmpty ? myName : "and $myName";
        double maxWidth = constraints.maxWidth;

        // Measure the width of the end text
        TextSpan endTextSpan = TextSpan(
          style: textStyle ?? const TextStyle(fontSize: 16.0),
          text: ' $endText',
        );
        TextPainter endTextPainter = TextPainter(
          text: endTextSpan,
          maxLines: 1,
          textDirection: TextDirection.ltr,
        );
        endTextPainter.layout();

        double endTextWidth = endTextPainter.width;
        double remainingWidth = maxWidth - endTextWidth;

        debugPrint(
            "Max width: $maxWidth, End text width: $endTextWidth, Remaining width: $remainingWidth");

        // Adjust truncation logic
        displayNames = _fitNamesInWidth(displayNames, remainingWidth);

        debugPrint(
            "Display names after truncation: ${displayNames.join(', ')}");

        return Text(
          '${displayNames.join(', ')} $endText',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textStyle ?? const TextStyle(fontSize: 16.0),
        );
      },
    );
  }

  /// Fits as many names as possible within the specified width.
  /// If a name doesn't fit, it tries to fit a partial name and always adds an ellipsis at the end.
  ///
  /// [names] The list of names to display.
  /// [maxWidth] The maximum width available for the names.
  ///
  /// Returns a list of names that fit within the width, with an ellipsis at the end.
  ///
  /// Author: Darshak Kakkad
  List<String> _fitNamesInWidth(List<String> names, double maxWidth) {
    TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );

    List<String> fittedNames = [];
    double currentWidth = 0;

    for (String name in names) {
      TextSpan span = TextSpan(
        text: (fittedNames.isEmpty ? '' : ', ') + name,
        style: const TextStyle(fontSize: 16.0),
      );
      textPainter.text = span;
      textPainter.layout();

      if (currentWidth + textPainter.width <= maxWidth) {
        fittedNames.add(name);
        currentWidth += textPainter.width;
      } else {
        // Try to fit as much of the next name as possible
        String partialName =
            _getPartialName(name, maxWidth - currentWidth - _ellipsisWidth());
        if (partialName.isNotEmpty) {
          fittedNames.add(partialName);
        }
        fittedNames.add('...'); // Always add ellipsis at the end
        break;
      }
    }

    return fittedNames;
  }

  /// Gets a partial name that fits within the available width.
  ///
  /// [name] The name to truncate.
  /// [availableWidth] The width available for the partial name.
  ///
  /// Returns the partial name that fits within the available width.
  ///
  /// Author: Darshak Kakkad
  String _getPartialName(String name, double availableWidth) {
    TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );

    for (int i = 1; i <= name.length; i++) {
      String partialName = name.substring(0, i);
      TextSpan span = TextSpan(
        text: partialName,
        style: const TextStyle(fontSize: 16.0),
      );
      textPainter.text = span;
      textPainter.layout();

      if (textPainter.width > availableWidth) {
        return name.substring(0, i - 1);
      }
    }

    return name; // If the entire name fits, return it
  }

  /// Measures and returns the width of the ellipsis ("...").
  ///
  /// Returns the width of the ellipsis.
  ///
  /// Author: Darshak Kakkad
  double _ellipsisWidth() {
    TextPainter textPainter = TextPainter(
      text: const TextSpan(
        text: '...',
        style: TextStyle(fontSize: 16.0),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );
    textPainter.layout();
    return textPainter.width;
  }
}
