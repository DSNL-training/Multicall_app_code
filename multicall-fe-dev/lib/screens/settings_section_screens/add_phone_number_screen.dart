import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/calls_controller.dart';
import 'package:multicall_mobile/controller/group_controller.dart';
import 'package:multicall_mobile/models/group.dart';
import 'package:multicall_mobile/models/member_list_model.dart';
import 'package:multicall_mobile/models/message.dart';
import 'package:multicall_mobile/models/response_restore_schedule_members.dart';
import 'package:multicall_mobile/providers/contact_provider.dart';
import 'package:multicall_mobile/providers/instant_call_provider.dart';
import 'package:multicall_mobile/screens/call_now/maximum_member_alert_bottomsheet.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/custom_container.dart';
import 'package:multicall_mobile/widget/phone_number_input_field.dart';
import 'package:multicall_mobile/widget/text_button.dart';
import 'package:provider/provider.dart';

class AddPhoneNumberScreen extends StatefulWidget {
  static const routeName = '/add-phone-number';

  final bool isFromNewGroupScreen;
  final bool isFromGroupDetails;
  final bool isFromScheduleScreen;
  final String buttonTitle;
  final bool isFromCallNow;
  final bool isFromCurrentCallingScreen;
  final bool isFromRescheduleScreen;

  const AddPhoneNumberScreen({
    super.key,
    this.isFromNewGroupScreen = false,
    this.isFromGroupDetails = false,
    this.isFromScheduleScreen = false,
    this.buttonTitle = "Add Phone Number",
    this.isFromCallNow = false,
    this.isFromCurrentCallingScreen = false,
    this.isFromRescheduleScreen = false,
  });

  @override
  AddPhoneNumberScreenState createState() => AddPhoneNumberScreenState();
}

class AddPhoneNumberScreenState extends State<AddPhoneNumberScreen> {
  final TextEditingController _numberController = TextEditingController();
  final FocusNode _phoneNumberFocus = FocusNode();
  String phoneNumberErrorText = "";
  bool isButtonEnabled = false;

  final List<GroupMembers> _phoneNumbers = [];

  Future<void> _addPhoneNumber() async {
    if (_numberController.text.isEmpty) {
      phoneNumberErrorText = 'Please enter a phone number';
      setState(() {});
    }

    if (!RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(_numberController.text)) {
      phoneNumberErrorText = 'Please enter a valid phone number';
      setState(() {});
    } else {
      phoneNumberErrorText = "";
      isButtonEnabled = _numberController.text.isNotEmpty;
      final contactMember =
          await Provider.of<ContactProvider>(context, listen: false)
              .getMappedMember(_numberController.text);
      var memberName = "Unknown";
      if (contactMember != null) {
        memberName = contactMember.name ?? "Unknown";
      }

      setState(() {
        _phoneNumbers.add(GroupMembers(
          memberName: memberName,
          memberTelephone: _numberController.text,
        ));
        _numberController.clear();
      });
    }
  }

  void _deletePhoneNumber(String number) {
    setState(() {
      _phoneNumbers.removeWhere((e) => e.memberTelephone == number);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        appBar: CustomAppBar(
            leading: const Text("Add Number"),
            trailing: InkWell(
              onTap: () async {
                if (_phoneNumbers.isEmpty) {
                  showToast("Add at least one number");
                  return;
                }

                if (widget.isFromNewGroupScreen) {
                  GroupController groupController =
                      Provider.of<GroupController>(context, listen: false);
                  bool status =
                      groupController.addMembersToNewGroup(_phoneNumbers);
                  if (status) {
                    Navigator.pop(context);
                  }
                } else if (widget.isFromGroupDetails) {
                  addMembersToGroup(_phoneNumbers);
                } else if (widget.isFromScheduleScreen) {
                  var provider =
                      Provider.of<CallsController>(context, listen: false);

                  var tempMembers = _phoneNumbers
                      .map(
                        (member) => ScheduleCallMember(
                          memberName: (member.memberName ?? "").length > 15
                              ? (member.memberName ?? "").substring(0, 15)
                              : (member.memberName ?? ""),
                          memberTelephone: member.memberTelephone,
                          memberEmail: "",
                        ),
                      )
                      .toList();

                  bool status = provider
                      .addMembersToScheduleCallWithDuplicateCheck(tempMembers);
                  if (status) {
                    Navigator.pop(context);
                  }
                } else if (widget.isFromRescheduleScreen) {
                  addMembersToRescheduleCall(context);
                } else if (widget.isFromCallNow) {
                  var tempMembers = _phoneNumbers
                      .map((e) => MemberListModel(
                            name: e.memberName ?? '',
                            phoneNumber: e.memberTelephone,
                          ))
                      .toList();
                  var provider =
                      Provider.of<InstantCallProvider>(context, listen: false);

                  bool status = provider.addMembersToCallNow(
                      newMembers: tempMembers, addToActiveCall: false);
                  if (status) {
                    Navigator.pop(context);
                  }
                } else if (widget.isFromCurrentCallingScreen) {
                  addMembersToCallingScreen(context);
                } else {}
              },
              child: Container(
                height: 32,
                width: 66,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  border: Border.all(
                    color: const Color(0XFF62B414),
                    width: 1,
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Done",
                    style: TextStyle(
                      color: Color(0XFF62B414),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            )),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: CustomStyledContainer(
                  width: size.width,
                  height: size.height - math.max(size.height * 0.28, 248),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (!widget.isFromGroupDetails &&
                            !widget.isFromNewGroupScreen &&
                            !widget.isFromCallNow &&
                            !widget.isFromScheduleScreen &&
                            !widget.isFromCurrentCallingScreen &&
                            !widget.isFromRescheduleScreen)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                "Please complete all fields to proceed",
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              CustomDropdownField(
                                size: size,
                                label: "Select Label",
                                items: const ['Work', 'Personal'],
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                            ],
                          ),
                        PhoneNumberInputField(
                          focusNode: _phoneNumberFocus,
                          size: size,
                          label: "Enter your mobile number",
                          errorText: phoneNumberErrorText,
                          controller: _numberController,
                          onChanged: (value) {
                            setState(() {
                              isButtonEnabled = value.isNotEmpty;
                            });
                          },
                        ),
                        _phoneNumbers.isEmpty
                            ? const SizedBox.shrink()
                            : Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 16.0),
                                      child: Divider(
                                        height: 1,
                                        color: Color(0XFFCDD3D7),
                                      ),
                                    ),
                                    const Text(
                                      'Mobile numbers',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 16.0,
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: _phoneNumbers.length,
                                        itemBuilder: (context, index) {
                                          return Row(
                                            children: [
                                              Expanded(
                                                  child: Text(
                                                _phoneNumbers[index]
                                                    .memberTelephone,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16.0,
                                                ),
                                              )),
                                              IconButton(
                                                icon: const Icon(Icons.close),
                                                onPressed: () =>
                                                    _deletePhoneNumber(
                                                        _phoneNumbers[index]
                                                            .memberTelephone),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 24.0,
                  right: 24.0,
                  top: 24.0,
                  bottom: 12.0 + MediaQuery.of(context).padding.bottom,
                ),
                child: TextButtonWithBG(
                  title: widget.buttonTitle,
                  action: _addPhoneNumber,
                  color: const Color.fromRGBO(98, 180, 20, 1),
                  textColor: Colors.white,
                  fontSize: 16,
                  iconColor: Colors.white,
                  width: size.width,
                  isDisabled: !isButtonEnabled,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  addMembersToGroup(List<GroupMembers> members) {
    GroupController groupController =
        Provider.of<GroupController>(context, listen: false);
    Group tempGroup = groupController.groupInAction!;

    var newMembers = members.map((member) => member.memberTelephone).toList();

    final Set<String> phoneNumbersSet =
        tempGroup.members.map((member) => member.memberTelephone).toSet();

    if (members.length == 1 &&
        phoneNumbersSet.contains(members.first.memberTelephone)) {
      showToast("Number Already Added!, Please select different number.");
      return;
    }

    final newMemberCount = members.length;
    for (var number in newMembers) {
      if (phoneNumbersSet.contains(number)) {
        members.removeWhere((element) => element.memberTelephone == number);
      }
    }

    if (newMemberCount != members.length) {
      showToast("Duplicate number found!");
    }

    tempGroup.members = groupController.groupInAction!.members + members;
    int totalIterations = (tempGroup.members.length / 2).ceil();

    groupController.requestToEditGroupDetails(
      groupMemberCount: tempGroup.members.length,
      oldGroupName: tempGroup.name,
      newGroupName: tempGroup.name,
      profileRefNumber: tempGroup.profileRefNum,
      totalIterations: totalIterations,
    );

    groupController.requestToEditGroupMembers(
      tempGroup.name,
      tempGroup.name,
      tempGroup.members,
    );

    groupController.fetchGroupMembers(tempGroup.groupId);
    Navigator.pop(context);
  }

  void addMembersToCallingScreen(BuildContext context) {
    var provider = Provider.of<InstantCallProvider>(context, listen: false);
    var selectedProfile = provider.selectedProfile;
    int selectedProfileSize = selectedProfile?.profileSize == 0
        ? 4
        : selectedProfile?.profileSize ?? 4;

    var tempMembers = _phoneNumbers
        .map((e) => MemberListModel(
              name: e.memberName ?? '',
              phoneNumber: e.memberTelephone,
            ))
        .toList();

    int totalMemberLength = provider.memberList.length + tempMembers.length;

    if (totalMemberLength > selectedProfileSize) {
      showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return MaximumMemberAlertBottomSheet(
            onTapSeePlan: () {
              // GOTO PLAN SCREEN
              debugPrint("On Tap See Plans");
            },
          );
        },
      );
    } else {
      bool status = provider.addMembersToCallNow(
          newMembers: tempMembers, addToActiveCall: true);
      if (status) {
        Navigator.pop(context);
      }
    }
  }

  /// Adds members to a rescheduled call.
  ///
  /// This function performs the following steps:
  /// 1. Retrieves the CallsController provider.
  /// 2. Converts phone numbers to ScheduleCallMembers format.
  /// 3. Gets schedule details from the provider.
  /// 4. Adds members to the rescheduled call with a duplicate check.
  /// 5. Checks if the context is still valid.
  /// 6. If the operation is successful, navigates back.
  ///
  /// Args:
  ///   context (BuildContext): The build context of the widget.
  ///
  /// Returns:
  ///   Future<void>: A Future that completes when all operations are done.
  Future<void> addMembersToRescheduleCall(BuildContext context) async {
    /// Retrieve the CallsController provider
    var provider = Provider.of<CallsController>(context, listen: false);

    /// Convert phone numbers to ScheduleCallMembers format
    var tempMembers = _phoneNumbers
        .map(
          (member) => ScheduleCallMembers(
              name: member.memberName ?? "",
              phone: member.memberTelephone,
              email: ""),
        )
        .toList();

    /// Get schedule details from the provider
    var scheduleDetail = provider
        .mergedScheduleCalls[provider.selectedUpcomingCallPosition]
        .scheduleDetail;

    /// Add members to the rescheduled call with a duplicate check
    bool status = await provider.addMembersToRescheduleCallWithDuplicateCheck(
        tempMembers, scheduleDetail);

    /// Check if the context is still valid
    if (!context.mounted) {
      return;
    }

    /// If the operation is successful, navigate back
    if (status) {
      Navigator.pop(context);
    }
  }
}
