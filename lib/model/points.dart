class Points {
  String username;
  String date;
  String competiation;
  int sum;

  Points({this.username, this.date, this.competiation, this.sum});

  @override
  String toString() {
    return '{ ${this.username}, ${this.date} '
        ',${this.competiation},${this.sum}';
  }
}
