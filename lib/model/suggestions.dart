class Suggestions {
  String username;
  String date;
  String question;
  String answer;

  Suggestions({this.username, this.date, this.question, this.answer});

  @override
  String toString() {
    return '{ ${this.username}, ${this.date} '
        ',${this.question},${this.answer}';
  }
}
