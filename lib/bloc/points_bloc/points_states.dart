
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

class AddPointsLoading extends PointsState {}

class AddPointsSucceed extends PointsState {}

class AddPointsFailed extends PointsState {
  String message;

  AddPointsFailed(this.message);
}

class RemovePointsLoading extends PointsState {}

class RemovePointsSucceed extends PointsState {}

class RemovePointsFailed extends PointsState {
  String message;

  RemovePointsFailed(this.message);
}