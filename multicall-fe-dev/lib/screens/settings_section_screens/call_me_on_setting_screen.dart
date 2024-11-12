import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/call_me_on_controller.dart';
import 'package:multicall_mobile/models/labels_model.dart';
import 'package:multicall_mobile/models/message.dart';
import 'package:multicall_mobile/models/response_call_me_on_restore.dart';
import 'package:multicall_mobile/models/response_call_me_on_update.dart';
import 'package:multicall_mobile/screens/settings_section_screens/add_phone_number_dropdown.dart';
import 'package:multicall_mobile/utils/preference_helper.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/custom_container.dart';
import 'package:multicall_mobile/widget/text_button.dart';
import 'package:provider/provider.dart';

class CallMeOnScreenSettingsScreen extends StatefulWidget {
  static const routeName = '/call-me-on-settings-screen';

  const CallMeOnScreenSettingsScreen({super.key});

  @override
  State<CallMeOnScreenSettingsScreen> createState() =>
      _CallMeOnScreenSettingsScreenState();
}

class _CallMeOnScreenSettingsScreenState
    extends State<CallMeOnScreenSettingsScreen> {
  int selectedOption = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CallMeOnController>(
        context,
        listen: false,
      ).callMeOnRestore();
    });

    selectedOption =
        PreferenceHelper.get(PrefUtils.selectedCallMeOnNumberPosition) ?? 0;
    setState(() {});
  }

  Future<void> removeItemById(int index) async {
    var provider = Provider.of<CallMeOnController>(context, listen: false);
    final tempFilteredList = provider.filteredCallMeOnList;
    if (index ==
        PreferenceHelper.get(PrefUtils.selectedCallMeOnNumberPosition)) {

      /// Reset the selected option
      await PreferenceHelper.set(PrefUtils.selectedCallMeOnNumberPosition, 0);
      selectedOption = 0;
    }

    if (provider.filteredCallMeOnList.isNotEmpty) {
      // remove registered phone number
      tempFilteredList.removeAt(index);

      // create List<NumberEntry> members from tempFilteredList
      List<NumberEntry> tempList = [];
      for (var i = 1; i < tempFilteredList.length; i++) {
        tempList.add(NumberEntry(
          type: tempFilteredList[i].labelType,
          callMeOnNumber: tempFilteredList[i].callMeOn,
        ));
      }

      // calling update call me on api
      var response = await provider.updateCallMeOn(
        tempList.length,
        tempList,
      ) as ResponseCallMeOnUpdate;

      if (response.status == true) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Provider.of<CallMeOnController>(context, listen: false)
              .addNumberSuccess(response.status);
          if (response.status) {
            showToast("Call Me On number removed successfully.");
          }
        });
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<CallMeOnController>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          appBar: const CustomAppBar(
            leading: Text("Call-Me-On"),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: CustomStyledContainer(
                    height: double.infinity,
                    width: size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Phone Numbers',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: ListView.builder(
                              itemCount: provider.filteredCallMeOnList.length,
                              itemBuilder: (context, index) {
                                CallMeOn option =
                                    provider.filteredCallMeOnList[index];
                                return CallMeOnCard(
                                  index: index,
                                  callMeOnObj: option,
                                  isRegistered: option.labelType == -1,
                                  option: {
                                    'index': index,
                                    'title': option.labelType == -1
                                        ? 'Registered'
                                        : LabelModel.getLabelByCode(
                                            option.labelType),
                                    'number': option.callMeOn,
                                  },
                                  isLastItem: index ==
                                      provider.filteredCallMeOnList.length - 1,
                                  onRemoveClicked: (value) {
                                    removeItemById(index);
                                  },
                                  onPressed: (value) async {
                                    selectedOption = value;
                                    await PreferenceHelper.set(
                                        PrefUtils
                                            .selectedCallMeOnNumberPosition,
                                        index);
                                    setState(() {});
                                  },
                                  isSelected: selectedOption == index,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: Theme.of(context).colorScheme.primary,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: TextButtonWithBG(
                    title: 'Add Phone Number',
                    action: () {
                      Navigator.pushNamed(
                          context, AddPhoneNumberDropDownScreen.routeName);
                    },
                    color: const Color.fromRGBO(98, 180, 20, 1),
                    textColor: Colors.white,
                    fontSize: 16,
                    // iconData: iconData,
                    iconColor: Colors.white,
                    width: size.width,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CallMeOnCard extends StatelessWidget {
  const CallMeOnCard({
    super.key,
    required this.index,
    required this.callMeOnObj,
    required this.option,
    required this.onPressed,
    required this.isLastItem,
    required this.onRemoveClicked,
    required this.isRegistered,
    required this.isSelected,
  });

  final int index;
  final CallMeOn callMeOnObj;
  final Map<String, dynamic> option;
  final bool isLastItem;
  final Function onRemoveClicked;
  final Function onPressed;
  final bool isRegistered;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPressed(index);
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 16,
                      child: Text(
                        option['title']!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: isRegistered
                              ? const Color(0XFF8E98A0)
                              : const Color(0XFF6E7A84),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    SizedBox(
                      height: 20,
                      child: Text(
                        option['number']!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: isRegistered
                              ? const Color(0XFFADB5BB)
                              : const Color(0XFF101315),
                        ),
                      ),
                    ),
                    if (isSelected)
                      const SizedBox(
                        height: 6,
                      ),
                    if (isSelected)
                      Container(
                        height: 24,
                        width: 55,
                        decoration: const BoxDecoration(
                          color: Color(0XFFEDF0F2),
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "Default",
                            style: TextStyle(
                                color: Color(0XFF3E4A54),
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                  ],
                ),
                if (!isRegistered)
                  TextButton(
                    onPressed: () {
                      onRemoveClicked(index);
                    },
                    child: const Text(
                      "Remove",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
              ],
            ),
          ),
          if (!isLastItem)
            const Divider(
              color: Color(0XFFCDD3D7),
            ),
        ],
      ),
    );
  }
}
