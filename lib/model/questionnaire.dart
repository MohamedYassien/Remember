class QuestionnaireModel {
  String question;
  List<String> element;
  bool isMulti;

  QuestionnaireModel({this.question, this.element, this.isMulti});

  @override
  String toString() {
    return '{ ${this.question}, ${this.element} ,${this.isMulti}';
  }
}
