class LabelModel {
  final int code;
  final String value;

  LabelModel({required this.code, required this.value});

  static List<LabelModel> getDefaultLabels() {
    return [
      LabelModel(code: 0, value: 'Home'),
      LabelModel(code: 1, value: 'Work'),
      LabelModel(code: 2, value: 'Mobile'),
      LabelModel(code: 3, value: 'Hotel'),
      LabelModel(code: 4, value: 'Other'),
    ];
  }

  /// Get label from code
  static String getLabelByCode(int codeToSearch) {
    return getDefaultLabels()
        .firstWhere((label) => label.code == codeToSearch)
        .value;
  }

  /// Get code from label
  static int getCodeByLabel(String labelToSearch) {
    return getDefaultLabels()
        .firstWhere((label) => label.value == labelToSearch)
        .code;
  }

  @override
  String toString() => 'LabelModel(code: $code, value: $value)';
}
