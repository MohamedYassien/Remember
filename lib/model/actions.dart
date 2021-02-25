class ActionsModel {
  String action;
  List<String> element;
  List<String> point;

  ActionsModel({this.action, this.element, this.point});

  @override
  String toString() {
    return '{ ${this.action}, ${this.element} ,${this.point}}';
  }
}
