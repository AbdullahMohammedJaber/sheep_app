part of 'root_cubit.dart';

final class RootState {
  int currenPage;
  RootState({this.currenPage = 0});
  RootState copyWith({int? currenPage}) {
    return RootState(currenPage: currenPage ?? this.currenPage);
  }
}
