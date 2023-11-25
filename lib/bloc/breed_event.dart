part of 'breed_bloc.dart';

abstract class BreedEvent extends Equatable {
  const BreedEvent();

  @override
  List<Object> get props => [];
}

class FetchBreeds extends BreedEvent {}
