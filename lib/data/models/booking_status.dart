enum BookingStatus {
  pending('PENDING'),
  confirmed('CONFIRMED'),
  providerAssigned('PROVIDER_ASSIGNED'),
  providerAccepted('PROVIDER_ACCEPTED'),
  providerRejected('PROVIDER_REJECTED'),
  onTheWay('ON_THE_WAY'),
  arrived('ARRIVED'),
  working('WORKING'),
  started('STARTED'),
  completed('COMPLETED'),
  cancelled('CANCELLED');

  const BookingStatus(this.value);

  final String value;

  static BookingStatus fromValue(String? value) {
    return BookingStatus.values.firstWhere(
      (s) => s.value == (value ?? '').toUpperCase(),
      orElse: () => BookingStatus.pending,
    );
  }

  bool get isUpcoming =>
      this == BookingStatus.pending || this == BookingStatus.confirmed;

  bool get isInProgress =>
      this == BookingStatus.providerAssigned ||
      this == BookingStatus.providerAccepted ||
      this == BookingStatus.onTheWay ||
      this == BookingStatus.arrived ||
      this == BookingStatus.working ||
      this == BookingStatus.started;

  bool get isCancelled =>
      this == BookingStatus.cancelled ||
      this == BookingStatus.providerRejected;
}
