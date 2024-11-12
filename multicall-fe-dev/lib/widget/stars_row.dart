import 'package:flutter/material.dart';

typedef RatingChangeCallback = void Function(double rating);

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final RatingChangeCallback onRatingChanged;
  final Color color;
  final List<String> labels = ["Bad", "Poor", "Fair", "Good", "Excellent"];

  StarRating({
    super.key,
    this.starCount = 5,
    this.rating = .0,
    required this.onRatingChanged,
    required this.color,
  });

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = const Icon(
        Icons.star_rounded,
        size: 65,
        color: Color.fromRGBO(221, 225, 228, 1),
      );
    } else if (index > rating - 1 && index < rating) {
      icon = Icon(
        Icons.star_rounded,
        color: color,
        size: 65,
      );
    } else {
      icon = Icon(
        Icons.star_rounded,
        color: color,
        size: 65,
      );
    }

    return Column(
      children: [
        InkResponse(
          onTap: onRatingChanged == null
              ? null
              : () => onRatingChanged(index + 1.0),
          child: icon,
        ),
        const SizedBox(height: 4), // space between icon and text
        Text(labels[index],
            style: const TextStyle(
              color: Color.fromRGBO(16, 19, 21, 1),
              fontSize: 12,
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(starCount, (index) => buildStar(context, index)),
    );
  }
}
