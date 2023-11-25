part of 'breed_bloc.dart';

abstract class BreedState extends Equatable {
  const BreedState();
  
  @override
  List<Object> get props => [];
}

class BreedInitial extends BreedState {}

class BreedLoading extends BreedState {}

class BreedLoaded extends BreedState {
  final List<BreedModel> breeds;

  const BreedLoaded(this.breeds);

  @override
  List<Object> get props => [breeds];
}

class BreedError extends BreedState {
  final String message;

  const BreedError(this.message);

  @override
  List<Object> get props => [message];
}
