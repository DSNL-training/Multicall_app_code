import 'dart:math' as math;

import 'package:contacts_service/contacts_service.dart';
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
import 'package:multicall_mobile/utils/ensure_permission.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/widget/common/multicall_text_widget.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/custom_container.dart';
import 'package:multicall_mobile/widget/text_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class ContactScreen extends StatefulWidget {
  static const routeName = '/contact_screen';

  final bool isFromNewGroupScreen;
  final bool isFromScheduleScreen;
  final bool isFromGroupDetailsScreen;
  final bool isFromCallNowScreen;
  final bool isFromCurrentCallingScreen;
  final bool isFromRescheduleScreen;

  const ContactScreen({
    super.key,
    this.isFromNewGroupScreen = false,
    this.isFromScheduleScreen = false,
    this.isFromGroupDetailsScreen = false,
    this.isFromCallNowScreen = false,
    this.isFromCurrentCallingScreen = false,
    this.isFromRescheduleScreen = false,
  });

  @override
  ContactScreenState createState() => ContactScreenState();
}

class ContactScreenState extends State<ContactScreen> {
  List<Contact>? allContacts;
  List<Contact> selectedContacts = [];
  bool _isLoading = true;
  String searchQuery = '';
  Map<String, List<Contact>> _groupedContacts = {};

  @override
  void initState() {
    super.initState();
    getContacts();
  }

  Future<void> getContacts() async {
    bool status = await ensureContactPermission();
    if (status) {
      try {
        setState(() {
          _isLoading = true;
        }); // Trigger loading state
        ContactProvider contactProvider =
            Provider.of<ContactProvider>(context, listen: false);
        allContacts = contactProvider.allContacts;
        _groupContacts(allContacts ?? []);

        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        // Handle errors gracefully
        debugPrint('Error fetching contacts: $e');
        setState(() {
          _isLoading = false;
          allContacts = [];
        });
      }
    } else {
      Navigator.pop(context);
      showToast("Contact permission denied");
      debugPrint('No permission to fetch contacts');
    }
  }

  void _groupContacts(List<Contact> contacts) {
    final contactProvider =
        Provider.of<ContactProvider>(context, listen: false);

    var filteredContacts = (contacts.where((contact) => contactProvider
        .sanitizeContactName(contact.displayName ?? '')
        .toLowerCase()
        .contains(searchQuery.toLowerCase()))).toList();

    filteredContacts
        .sort((a, b) => (a.displayName ?? '').compareTo(b.displayName ?? ''));

    Map<String, List<Contact>> groupedContacts = {};

    for (var contact in filteredContacts) {
      String displayName = contact.displayName ?? '';
      if (displayName.isNotEmpty) {
        String initial = displayName[0].toUpperCase();
        if (!RegExp(r'^[A-Z]$').hasMatch(initial)) {
          initial = '#';
        }
        if (!groupedContacts.containsKey(initial)) {
          groupedContacts[initial] = [];
        }
        groupedContacts[initial]!.add(contact);
      }
    }

    setState(() {
      _groupedContacts = groupedContacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        appBar: const CustomAppBar(
          leading: Text('Contacts'),
        ),
        body: _isLoading && (allContacts == null || allContacts!.isEmpty)
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              )
            : allContacts != null && allContacts!.isNotEmpty
                ? Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: CustomStyledContainer(
                              height: selectedContacts.isNotEmpty
                                  ? size.height -
                                      math.max(size.height * 0.27, 200)
                                  : size.height -
                                      math.max(size.height * 0.17, 140),
                              width: size.width,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: SizedBox(
                                      height: 50,
                                      child: TextField(
                                        cursorColor: Colors.blue,
                                        onChanged: (value) {
                                          setState(() {
                                            searchQuery = value;
                                            _groupContacts(allContacts ?? []);
                                          });
                                        },
                                        decoration: const InputDecoration(
                                          labelText: 'Search',
                                          prefixIcon: Icon(
                                            PhosphorIconsDuotone
                                                .magnifyingGlass,
                                            size: 20,
                                          ),
                                          labelStyle:
                                              TextStyle(color: Colors.black),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8.0),
                                            ),
                                            borderSide: BorderSide(
                                                color: Color(0XFFCDD3D7)),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8.0),
                                            ),
                                            borderSide: BorderSide(
                                                color: Color(0XFFCDD3D7)),
                                          ),
                                          fillColor: Colors.white,
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8.0),
                                            ),
                                            borderSide: BorderSide(
                                                color: Color(0XFFCDD3D7)),
                                          ),
                                          filled: true,
                                          focusColor: Colors.white,
                                          hintText: "Search",
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        enableInteractiveSelection: true,
                                      ),
                                    ),
                                  ),
                                  selectedContacts.isNotEmpty
                                      ? SizedBox(
                                          height: 76.0,
                                          child: ListView(
                                            scrollDirection: Axis.horizontal,
                                            children: selectedContacts
                                                .asMap()
                                                .entries
                                                .map((entry) {
                                              return selectedContactListCell(
                                                  entry.value);
                                            }).toList(),
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                  SizedBox(
                                    height:
                                        selectedContacts.isNotEmpty ? 24 : 0,
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: _groupedContacts.keys.length,
                                      itemBuilder: (context, index) {
                                        String initial = _groupedContacts.keys
                                            .elementAt(index);
                                        List<Contact> contacts =
                                            _groupedContacts[initial]!;
                                        return _buildGroup(initial, contacts);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (selectedContacts.isNotEmpty)
                        Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: TextButtonWithBG(
                              title: 'Add',
                              action: () {
                                FocusScope.of(context).unfocus();

                                debugPrint(
                                    'Selected Contacts: ${selectedContacts.map((e) => e.displayName).join(', ')}');

                                if (selectedContacts.isNotEmpty) {
                                  if (widget.isFromNewGroupScreen) {
                                    addMembersToNewCreatingGroup();
                                  } else if (widget.isFromGroupDetailsScreen) {
                                    addMembersToGroup();
                                  } else if (widget.isFromScheduleScreen) {
                                    addMembersToScheduleCall();
                                  } else if (widget.isFromCallNowScreen) {
                                    addMembersToCallNow();
                                  } else if (widget
                                      .isFromCurrentCallingScreen) {
                                    addMembersToCallingScreen(context);
                                  } else if (widget.isFromRescheduleScreen) {
                                    addMembersToRescheduleCall(context);
                                  }
                                } else {
                                  showToast("Please select contact.");
                                }
                              },
                              color: const Color.fromRGBO(98, 180, 20, 1),
                              textColor: Colors.white,
                              fontSize: 16,
                              width: size.width,
                            ),
                          ),
                        ),
                    ],
                  )
                : const Center(
                    child: Text('No contacts found'),
                  ),
      ),
    );
  }

  Widget _buildGroup(String initial, List<Contact> contacts) {
    return Consumer<ContactProvider>(
        builder: (BuildContext context, provider, Widget? child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 3),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.all(
                Radius.circular(4),
              ),
            ),
            child: Text(
              initial,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          ...contacts.map((contact) => ListTile(
                leading: Checkbox(
                  value: selectedContacts.contains(contact),
                  onChanged: (bool? value) {
                    setState(() {
                      if (selectedContacts.contains(contact)) {
                        selectedContacts.remove(contact);
                      } else {
                        selectedContacts.add(contact);
                      }
                    });
                  },
                  checkColor: Colors.white,
                  activeColor: Colors.green,
                ),
                title: Row(
                  children: [
                    (contact.avatar != null && contact.avatar!.isNotEmpty)
                        ? CircleAvatar(
                            backgroundImage: MemoryImage(contact.avatar!),
                          )
                        : CircleAvatar(
                            backgroundColor:
                                const Color.fromRGBO(0, 134, 181, 1),
                            child: Text(
                              provider.sanitizeContactName(contact.initials()),
                            ),
                          ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        provider.sanitizeContactName(contact.displayName ?? ''),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      );
    });
  }

  Widget selectedContactListCell(Contact contact) {
    return Consumer<ContactProvider>(
      builder: (BuildContext context, provider, Widget? child) {
        return SizedBox(
          width: 72,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: 60,
                child: Stack(children: [
                  Center(
                    child: Container(
                      height: 44,
                      width: 44,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(22)),
                        color: Color.fromRGBO(0, 134, 181, 1),
                      ),
                      child: Center(
                        child: MultiCallTextWidget(
                          text:
                              provider.sanitizeContactName(contact.initials()),
                          textColor: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: -8,
                    top: -10,
                    child: IconButton(
                      onPressed: () {
                        if (selectedContacts.contains(contact)) {
                          selectedContacts.remove(contact);
                          setState(() {});
                        }
                      },
                      icon: Container(
                        height: 18,
                        width: 18,
                        decoration: const BoxDecoration(
                          color: Color(0XFF4E5D69),
                          borderRadius: BorderRadius.all(
                            Radius.circular(9.0),
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.close,
                            size: 16,
                          ),
                        ),
                      ),
                      color: Colors.white,
                    ),
                  )
                ]),
              ),
              MultiCallTextWidget(
                text: contact.displayName ?? "",
                textColor: const Color(0XFF101315),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                textOverflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  addMembersToGroup() {
    GroupController groupController =
        Provider.of<GroupController>(context, listen: false);
    Group tempGroup = groupController.groupInAction!;

    var newMembers = selectedContacts
        .map((contact) =>
            contact.phones?.first.value?.replaceAll(RegExp(r'[ \-()]'), ''))
        .toList();

    final Set<String> phoneNumbersSet =
        tempGroup.members.map((member) => member.memberTelephone).toSet();

    if (newMembers.length == 1 && phoneNumbersSet.contains(newMembers.first)) {
      showToast("Number Already Added!, Please select different number.");
      return;
    }

    final newMemberCount = selectedContacts.length;
    for (var number in newMembers) {
      if (phoneNumbersSet.contains(number)) {
        selectedContacts.removeWhere((element) =>
            (element.phones?.first.value?.replaceAll(RegExp(r'[ \-()]'), '')) ==
            number);
      }
    }
    if (newMemberCount != selectedContacts.length) {
      showToast("Duplicate number found!");
    }

    for (var contact in selectedContacts) {
      String phone = processPhoneNumber(contact.phones?.first.value);
      tempGroup.members.add(GroupMembers(
          memberTelephone: phone, memberName: contact.displayName));
    }
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
    Navigator.pop(context);
  }

  addMembersToNewCreatingGroup() {
    final newNumbers = selectedContacts
        .map((contact) => GroupMembers(
            memberName: contact.displayName,
            memberTelephone: (contact.phones?.first.value ?? "")
                .replaceAll(RegExp(r'[ \-()]'), '')))
        .toList();
    GroupController groupController =
        Provider.of<GroupController>(context, listen: false);
    bool status = groupController.addMembersToNewGroup(newNumbers);
    if (status) {
      Navigator.pop(context);
    }
  }

  addMembersToScheduleCall() {
    var provider = Provider.of<CallsController>(context, listen: false);
    var tempMembers = selectedContacts
        .map(
          (contact) => ScheduleCallMember(
            memberName: (contact.displayName ?? "").length > 15
                ? (contact.displayName ?? "").substring(0, 15).trim()
                : (contact.displayName ?? "").trim(),
            memberTelephone: processPhoneNumber(contact.phones?.first.value),
            memberEmail: "",
          ),
        )
        .toList();

    bool status =
        provider.addMembersToScheduleCallWithDuplicateCheck(tempMembers);
    if (status) {
      Navigator.pop(context);
    }
  }

  addMembersToCallNow() {
    var newMembers = selectedContacts
        .map((contact) => MemberListModel(
              name: contact.displayName ?? '',
              phoneNumber: processPhoneNumber(contact.phones?.first.value),
            ))
        .toList();
    var provider = Provider.of<InstantCallProvider>(context, listen: false);
    bool status = provider.addMembersToCallNow(
        newMembers: newMembers, addToActiveCall: false);
    if (status) {
      Navigator.pop(context);
    }
  }

  void addMembersToCallingScreen(BuildContext context) {
    /// Check the profile size then
    /// Call the API for add Conferee
    /// Then add members to list

    var provider = Provider.of<InstantCallProvider>(context, listen: false);
    var selectedProfile = provider.selectedProfile;
    int selectedProfileSize = selectedProfile?.profileSize == 0
        ? 4
        : selectedProfile?.profileSize ?? 4;

    var tempMembers = selectedContacts
        .map((contact) => MemberListModel(
              name: contact.displayName ?? '',
              phoneNumber: processPhoneNumber(contact.phones?.first.value),
            ))
        .toList();

    int totalMemberLength = provider.memberList.length + tempMembers.length;

    if (totalMemberLength > selectedProfileSize) {
      debugPrint("Not allow to add...");
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

  /// Adds members from selected contacts to a rescheduled call.
  ///
  /// This function performs the following steps:
  /// 1. Retrieves the schedule details from the `CallsController` provider.
  /// 2. Converts the selected contacts to `ScheduleCallMembers` format, processing the phone numbers.
  /// 3. Calls `addMembersToRescheduleCallWithDuplicateCheck` to add the members, checking for duplicates.
  /// 4. If the operation is successful, navigates back to the previous screen.
  ///
  /// Args:
  ///   context (BuildContext): The build context of the widget.
  ///
  /// Returns:
  ///   Future<void>: A Future that completes when all operations are done.
  Future<void> addMembersToRescheduleCall(BuildContext context) async {
    var provider = Provider.of<CallsController>(context, listen: false);
    var scheduleDetail = provider
        .mergedScheduleCalls[provider.selectedUpcomingCallPosition]
        .scheduleDetail;
    var tempMembers = selectedContacts
        .map(
          (contact) => ScheduleCallMembers(
              name: contact.displayName ?? "",
              phone: processPhoneNumber(contact.phones?.first.value),
              email: ""),
        )
        .toList();

    bool status = await provider.addMembersToRescheduleCallWithDuplicateCheck(
        tempMembers, scheduleDetail);

    if (!context.mounted) return; // Check if the context is still valid

    if (status) {
      Navigator.pop(context);
    }
  }
}
