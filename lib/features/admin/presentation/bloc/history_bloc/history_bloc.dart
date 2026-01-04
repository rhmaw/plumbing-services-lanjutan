import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  
  HistoryBloc() : super(HistoryInitial()) {
    on<LoadHistory>(_onLoadHistory);
    on<SearchHistory>(_onSearchHistory);
  }

  String getBaseUrl() {
    if (kIsWeb) return 'http://127.0.0.1:8080/api';
    if (Platform.isAndroid) return 'http://YOUR_IP_ADDRESS_CONNECTION:8080/api';
    return 'http://YOUR_IP_ADDRESS_CONNECTION:8080/api'; 
  }

  Future<void> _onLoadHistory(LoadHistory event, Emitter<HistoryState> emit) async {
    emit(HistoryLoading());
    try {
      final url = Uri.parse('${getBaseUrl()}/admin/worker-salaries');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final data = json['data'] ?? [];
        emit(HistoryLoaded(history: data, filteredHistory: data));
      } else {
        emit(const HistoryError("Gagal memuat data"));
      }
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }

  void _onSearchHistory(SearchHistory event, Emitter<HistoryState> emit) {
    if (state is HistoryLoaded) {
      final currentState = state as HistoryLoaded;
      final query = event.query.toLowerCase();
      
      final results = currentState.history.where((item) {
        final name = (item['username'] ?? '').toString().toLowerCase();
        return name.contains(query);
      }).toList();

      emit(HistoryLoaded(
        history: currentState.history, 
        filteredHistory: results
      ));
    }
  }
}