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
  relevance("Relevance", "name_asc"),
  priceLowToHigh("Price:Low-High", "price_low"),
  priceHighToLow("Price:High-Low", "price_high");

  final String value;
  final String displayValue;

  const ProductSortType(this.value, this.displayValue);
}

enum OrderStatus {
  placed("placed", "Order Placed", "We have received your order"),
  packing("packing", "Packing", "Your items are being prepared"),
  inTransit("in transit", "In Transit", "Your order is on the way"),
  delivered("delivered", "Delivered", "Order delivered successfully");

  const OrderStatus(this.value, this.displayTitle, this.displaySubtitle);

  final String value;
  final String displayTitle;
  final String displaySubtitle;
}
