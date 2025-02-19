enum HiveBox {
  activity('activities-db'),
  ongoing('ongoing-activities-db'),
  ;

  const HiveBox(this.boxName);

  final String boxName;
}
