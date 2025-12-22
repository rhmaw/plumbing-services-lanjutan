import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LogoutEvent>((event, emit) async {
      await Future.delayed(const Duration(milliseconds: 300));
      emit(AuthUnauthenticated());
    });
  }
}
