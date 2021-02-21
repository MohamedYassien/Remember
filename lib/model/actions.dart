class ActionsModel {
  String action;
  List<String> element;

  ActionsModel({this.action, this.element});

  @override
  String toString() {
    return '{ ${this.action}, ${this.element} }';
  }
}
