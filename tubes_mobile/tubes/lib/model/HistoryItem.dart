class HistoryItem {
  final int id;
  final String campaignName;
  final double totalDonated;
  final String donationTime;
  final String status;

  HistoryItem({
    required this.id,
    required this.campaignName,
    required this.totalDonated,
    required this.donationTime,
    required this.status,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id'],
      campaignName: json['campaign_name'] ?? '-',
      totalDonated: (json['total_donated'] as num).toDouble(),
      donationTime: json['donation_time'],
      status: json['status'] ?? '',
    );
  }
}