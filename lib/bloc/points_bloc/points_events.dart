
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
