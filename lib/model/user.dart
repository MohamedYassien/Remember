class Users {
  String name;
  String email;
  String phone;

  Users({
    this.name,
    this.email,
    this.phone,
  });

  @override
  String toString() {
    return '{ ${this.name} '
        ',${this.email} ,${this.phone}';
  }
}
