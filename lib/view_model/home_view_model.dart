import 'package:flutter/material.dart';
import 'package:mvvm/data/response/api_response.dart';
import 'package:mvvm/model/movies_model.dart';
import 'package:mvvm/repository/home_repository.dart';

class HomeViewModel with ChangeNotifier {
  final _myRepo = HomeRepository();

  ApiResponse<MovieListModel> moviesList = ApiResponse.loading();

  // setter method
  setMoviesList(ApiResponse<MovieListModel> response) {
    moviesList = response;
    notifyListeners();
  }

  Future<void> fetchMoviesListApi() async {
    setMoviesList(
      ApiResponse.loading(),
    );
    _myRepo.fetchMoviesList().then((value) {
      setMoviesList(
        ApiResponse.completed(value),
      );
    }).onError((error, stackTrace) {
      setMoviesList(ApiResponse.error(error.toString()));
    });
  }
}
