import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/calls_controller.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/custom_container.dart';
import 'package:multicall_mobile/widget/text_button.dart';
import 'package:provider/provider.dart';

class SelectDurationScreen extends StatefulWidget {
  static const routeName = '/duration-selector-screen';

  const SelectDurationScreen({super.key});

  @override
  State<SelectDurationScreen> createState() => _SelectDurationScreenState();
}

class _SelectDurationScreenState extends State<SelectDurationScreen> {
  int selectedValue = 20;
  late FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = FixedExtentScrollController(
        initialItem: 3); // initial value for 20 (4th item in 5s)

    WidgetsBinding.instance.addPostFrameCallback((_) {
      selectedValue = Provider.of<CallsController>(context, listen: false)
          .getConferenceDuration();
      if (selectedValue != 0) {
        _scrollController.animateToItem((selectedValue - 1) ~/ 5,
            duration: Durations.long4, curve: Curves.easeInOut);
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: CustomAppBar(
        leading: const Text(
          'Select Duration',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
        trailing: BorderTextButton(
          title: 'Done',
          action: () {
            Navigator.pop(context);
            Provider.of<CallsController>(context, listen: false)
                .setConferenceDuration(selectedValue);
          },
          borderColor: const Color.fromRGBO(98, 180, 20, 1),
          textColor: const Color.fromRGBO(98, 180, 20, 1),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: CustomStyledContainer(
              height: size.height * 0.80,
              width: size.width,
              child: Center(
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Colors.transparent,
                        Colors.black,
                        Colors.black,
                        Colors.transparent
                      ],
                      stops: [
                        0.0,
                        0.3,
                        0.7,
                        1.0
                      ], // Adjust stops to control the fade area
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstIn,
                  child: SizedBox(
                    height: 250.0,
                    child: ListWheelScrollView.useDelegate(
                      controller: _scrollController,
                      itemExtent: 95.0, // 90 for item height + 5 for gap
                      diameterRatio: 2.0,
                      physics: const CustomScrollPhysics(),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedValue = ((index % 24) + 1) * 5;
                        });
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context, index) {
                          final value = ((index % 24) + 1) * 5;
                          return Container(
                            alignment: Alignment.center,
                            child: Text(
                              value.toString(),
                              style: TextStyle(
                                fontSize: 72,
                                color: value == selectedValue
                                    ? Colors.black
                                    : Colors.grey,
                                fontWeight: value == selectedValue
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          );
                        },
                        childCount: null, // Infinite child count
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomScrollPhysics extends FixedExtentScrollPhysics {
  const CustomScrollPhysics({super.parent});

  @override
  CustomScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double get minFlingVelocity => 60.0; // reduce the minimum fling velocity

  @override
  double get maxFlingVelocity => 200.0; // reduce the maximum fling velocity
}
