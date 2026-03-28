enum PopupMenuItemType {
  edit,
  delete,
  mediaFiles,
  participants,
  showMedia,
  createDiscussion,
  activityLog,
  timeLog,
  deleteTask,
  share,
}

enum ProductSortType {
  relevance("name_asc"),
  priceLowToHigh("price_low"),
  priceHighToLow("price_high");

  final String displayValue;

  const ProductSortType(this.displayValue);
}

enum OrderStatus {
  packing("Packing", "2336 Jack Warren Rd, Delta Junction, Alaska 9..."),
  picked("Picked", "2417 Tongass Ave #111, Ketchikan, Alaska 99901..."),
  inTransit("In Transit", "16 Rr 2, Ketchikan, Alaska 99901, USA"),
  delivered("Delivered", "925 S Chugach St #APT 10, Alaska 99645");

  const OrderStatus(this.displayTitle, this.displaySubtitle);

  final String displayTitle;
  final String displaySubtitle;
}
