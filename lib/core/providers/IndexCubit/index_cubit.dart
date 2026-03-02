import 'package:bloc/bloc.dart';

class IndexCubit extends Cubit<int> {
  IndexCubit() : super(0); // Initialize with index 0

  // Method to update the index
  void updateIndex(int newIndex) {
    emit(newIndex);
  }
}
