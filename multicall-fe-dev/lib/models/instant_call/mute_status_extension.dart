enum MuteStatus { muted, unMuted }

extension MuteStatusExtension on MuteStatus {
  static MuteStatus fromInt(int value) {
    switch (value) {
      case 1:
        return MuteStatus.muted;
      case 0:
        return MuteStatus.unMuted;
      default:
        throw Exception("Invalid mute status value");
    }
  }

  int toInt() {
    switch (this) {
      case MuteStatus.muted:
        return 1;
      case MuteStatus.unMuted:
        return 0;
      default:
        throw Exception("Invalid mute status");
    }
  }

  String get message {
    switch (this) {
      case MuteStatus.muted:
        return "Muted";
      case MuteStatus.unMuted:
        return "Unmuted";
      default:
        return "Unknown status";
    }
  }
}
