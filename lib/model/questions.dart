class Questions {
  String date;
  String question;

  Questions({
    this.date,
    this.question,
  });

  @override
  String toString() {
    return '{ ${this.date} '
        ',${this.question}';
  }
}
