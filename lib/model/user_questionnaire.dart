class QuestionnaireModelList {
  String question;
  List<String> choiceElement;
  String userName;
  String date;

  QuestionnaireModelList(
      {this.question, this.choiceElement, this.userName, this.date});

  @override
  String toString() {
    return '{ ${this.question}, ${this.choiceElement} ,${this.userName},${this.date}';
  }
}
