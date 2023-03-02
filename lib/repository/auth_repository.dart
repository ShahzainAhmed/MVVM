import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mvvm/data/network/base_api_services.dart';
import 'package:mvvm/data/network/network_api_servcies.dart';
import 'package:mvvm/resources/app_url.dart';
import 'package:another_flushbar/flushbar.dart';

class AuthRepository {
  BaseApiServices _apiServices = NetworkApiServices();

// For Login Api
  Future<dynamic> loginApi(dynamic data) async {
    try {
      dynamic response =
          await _apiServices.getPostApiResponse(AppUrl.loginURL, data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

// For Sign-Up Api
  Future<dynamic> signUpApi(dynamic data) async {
    try {
      dynamic response =
          await _apiServices.getPostApiResponse(AppUrl.signUpApiURL, data);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
