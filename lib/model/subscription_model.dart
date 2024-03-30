

class PremiumSubscriptionModelFields{
  static const String subscriptionId="subscriptionId";
  static const String subscriptionType="subscriptionType";
  static const String subscriptionDate="subscriptionDate";
  static const String subscriptionExpiryDate="SubscriptionExpiryDate";
  static const String subscriptionAmount="subscriptionAmount";
  static const String subscriptionStatus="subscriptionStatus";
}

class PremiumSubscriptionModel{
  final String subscriptionId;
  final String subscriptionType;
  final String subscriptionDate;
  final String subscriptionExpiryDate;
  final String subscriptionAmount;
  final String subscriptionStatus;

  PremiumSubscriptionModel({
   required this.subscriptionAmount,
   required this.subscriptionDate,
   required this.subscriptionExpiryDate,
   required this.subscriptionId,
   required this.subscriptionType,
    required this.subscriptionStatus
});

  Map<String,dynamic>toMap()=>{
    PremiumSubscriptionModelFields.subscriptionType:subscriptionType,
    PremiumSubscriptionModelFields.subscriptionAmount:subscriptionAmount,
    PremiumSubscriptionModelFields.subscriptionId:subscriptionId,
    PremiumSubscriptionModelFields.subscriptionExpiryDate:subscriptionExpiryDate,
    PremiumSubscriptionModelFields.subscriptionDate:subscriptionDate,
    PremiumSubscriptionModelFields.subscriptionStatus:subscriptionStatus
  };

  factory PremiumSubscriptionModel.fromJson(Map<String,dynamic> json)=>PremiumSubscriptionModel(
      subscriptionAmount: json[PremiumSubscriptionModelFields.subscriptionAmount],
      subscriptionDate: json[PremiumSubscriptionModelFields.subscriptionDate],
      subscriptionExpiryDate: json[PremiumSubscriptionModelFields.subscriptionExpiryDate],
      subscriptionId: json[PremiumSubscriptionModelFields.subscriptionId],
      subscriptionStatus: json[PremiumSubscriptionModelFields.subscriptionStatus],
      subscriptionType: json[PremiumSubscriptionModelFields.subscriptionType]);
}