
class PointsState {}

class PointsInitialized extends PointsState {}

class GetPointsLoading extends PointsState {}

class GetPointsSucceed extends PointsState {}

class GetPointsFailed extends PointsState {}

class SendPointsLoading extends PointsState {}

class SendPointsSucceed extends PointsState {}

class SendPointsFailed extends PointsState {
  String message;

  SendPointsFailed(this.message);
}