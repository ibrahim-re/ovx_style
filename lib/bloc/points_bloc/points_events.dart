
class PointsEvent {}

class GetPoints extends PointsEvent {}

class SendPoint extends PointsEvent {
 String senderId;
 String receiverUserCode;
 int pointsAmount;

 SendPoint(
     this.senderId,
     this.receiverUserCode,
     this.pointsAmount,
     );

}

class AddPoints extends PointsEvent {
 int totalAmount;

 AddPoints(this.totalAmount);
}

class RemovePoints extends PointsEvent {
 int totalAmount;

 RemovePoints(this.totalAmount);
}
