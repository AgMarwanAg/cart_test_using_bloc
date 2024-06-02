class Modifier {
  String id;
  int modifierId;
  ModifierDetails modifier;
  List<Option> options;

  Modifier({
    required this.id,
    required this.modifierId,
    required this.modifier,
    required this.options,
  });

  factory Modifier.fromJson(Map<String, dynamic> json) {
    var optionsList = json['options'] as List;
    List<Option> options = optionsList.map((i) => Option.fromJson(i)).toList();

    return Modifier(
      id: json['slack'],
      modifierId: json['modifier_id'],
      modifier: ModifierDetails.fromJson(json['modifier']),
      options: options,
    );
  }


  static List<Modifier> fromList(List<dynamic> jsonList) {
    return jsonList.map((json) => Modifier.fromJson(json)).toList();
  }
}

class ModifierDetails {
  int id;
  String slack;
  String name;

  bool allowMultipleSelections;

  ModifierDetails({
    required this.id,
    required this.slack,
    required this.name,
    required this.allowMultipleSelections,
  });

  factory ModifierDetails.fromJson(Map<String, dynamic> json) {
    return ModifierDetails(
      id: json['id'],
      slack: json['slack'],
      name: json['name'],
      allowMultipleSelections: json['allow_multiple_selections'],
    );
  }
}

class Option {
  String slack;
  String optionName;
  String salePrice;

  Option({
    required this.slack,
    required this.optionName,
    required this.salePrice,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(slack: json['slack'], optionName: json['option_name'], salePrice: json['sale_price']);
  }

  
}
