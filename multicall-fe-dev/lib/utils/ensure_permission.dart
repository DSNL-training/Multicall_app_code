// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multicall_mobile/main.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> ensureContactPermission({bool openSettingsDialog = true}) async {
  const contactPermission = Permission.contacts;
  PermissionStatus permissionStatus = await contactPermission.request();
  if (permissionStatus.isPermanentlyDenied) {
    if (navigatorKey.currentState?.context == null) {
      log("Context not present to show dialog box");
      return false;
    }
    if (openSettingsDialog) {
      await showDialog(
        context: navigatorKey.currentState!.context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('Contact Permission'),
          content: const Text(
            'This app needs contact access to get contacts ',
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text(
                'Deny',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            CupertinoDialogAction(
              child: const Text(
                'Settings',
                style: TextStyle(color: Color(0XFF0086B5)),
              ),
              onPressed: () async {
                await openAppSettings();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }
  if (!permissionStatus.isGranted) return false;
  return true;
}
