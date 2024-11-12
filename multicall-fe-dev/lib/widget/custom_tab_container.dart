import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/calls_controller.dart';
import 'package:multicall_mobile/utils/constants.dart';
import 'package:multicall_mobile/utils/preference_helper.dart';
import 'package:multicall_mobile/widget/all_calls_widget.dart';
import 'package:multicall_mobile/widget/upcoming_calls_widget.dart';
import 'package:provider/provider.dart';
import 'package:tab_container/tab_container.dart';

class CustomTabContainer extends StatefulWidget {
  final Function(bool) onIsEmptyChanged;

  const CustomTabContainer({
    super.key,
    required this.onIsEmptyChanged,
  });

  @override
  State<CustomTabContainer> createState() => _CustomTabContainerState();
}

class _CustomTabContainerState extends State<CustomTabContainer>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController.index == 1) {
      widget.onIsEmptyChanged(
          Provider.of<CallsController>(context, listen: false)
                  .mergedScheduleCalls
                  .isEmpty &&
              Provider.of<CallsController>(context, listen: false)
                  .invitations
                  .isEmpty);
      return;
    } else if (_tabController.index == 0) {
      widget.onIsEmptyChanged(
          Provider.of<CallsController>(context, listen: false)
              .allCallsHistory
              .isEmpty);
      return;
    }
    widget.onIsEmptyChanged(true); // Example callback usage
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      constraints: BoxConstraints.expand(height: size.height * 0.61),
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          if (shouldUseKey())
            Container(
              key: homePageTabs,
              child: SizedBox(
                height: 50.0,
                width: size.width,
              ),
            ),
          Consumer<CallsController>(
            builder: (context, provider, child) {
              /// Check list is empty
              checkListIsEmpty(provider, _tabController.index);
              return TabContainer(
                duration: const Duration(milliseconds: 100),
                tabBorderRadius: BorderRadius.circular(16),
                childPadding: const EdgeInsets.all(20),
                color: Theme.of(context).colorScheme.primary,
                selectedTextStyle: const TextStyle(
                  color: Color.fromRGBO(0, 134, 181, 1),
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
                unselectedTextStyle: const TextStyle(
                  color: Color.fromRGBO(16, 19, 21, 1),
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
                controller: _tabController,
                tabs: const [
                  Text('All Calls'),
                  Text('Upcoming Calls'),
                ],
                children: const [
                  AllCallsTab(),
                  UpcomingCallsTab(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  /// Check list is empty or not
  void checkListIsEmpty(CallsController provider, int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (index == 1) {
        if (provider.mergedScheduleCalls.isEmpty &&
            provider.invitations.isEmpty) {
          widget.onIsEmptyChanged(true);
        } else {
          widget.onIsEmptyChanged(false);
        }
      } else {
        if (provider.allCallsHistory.isEmpty) {
          widget.onIsEmptyChanged(true);
        } else {
          widget.onIsEmptyChanged(false);
        }
      }
    });
  }

  bool shouldUseKey() {
    return !(PreferenceHelper.get(PrefUtils.watchedIntro) ?? false);
  }
}
