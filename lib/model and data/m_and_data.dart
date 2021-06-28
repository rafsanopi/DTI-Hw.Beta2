class Grpname {
  final String grpname;

  const Grpname(this.grpname);
}

const grpdata = const [
  Grpname("A1"),
  Grpname("B"),
  Grpname("A2"),
];

class Hwdetails {
  final String date, hwdetails;

  const Hwdetails(this.date, this.hwdetails);
}

const hd = const [
  Hwdetails("5 may", "Reloaded 0 libraries in 137ms"),
  Hwdetails("6 may", "Reloaded 0 libraries in 137ms"),
  Hwdetails("7 may", "Reloaded 0 libraries in 137ms"),
  Hwdetails("8 may", "Reloaded 0 libraries in 137ms"),
  Hwdetails("9 may", "Reloaded 0 libraries in 137ms"),
];

final List<Event> events = [
  Event("A1", 'steve-johnson.jpeg', 'Shenzhen GLOBAL DESIGN AWARD 2018',
      '4.20-30'),
  Event("A2", 'efe-kurnaz.jpg', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event("B", 'rodion-kutsaev.jpeg', 'Dawan District Guangdong Hong Kong',
      '4.28-31'),
];

class Event {
  final String id;

  final String assetName;
  final String title;
  final String date;

  Event(
    this.id,
    this.assetName,
    this.title,
    this.date,
  );
}
