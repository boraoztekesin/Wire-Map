import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wire_app2/models/car_model.dart';
import 'package:wire_app2/models/login_model.dart';
import 'package:wire_app2/models/register_model.dart';
import 'package:wire_app2/models/reservation_model.dart';
import 'package:wire_app2/models/station_model.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:wire_app2/models/user_model.dart';

class Api {
  static String baseURL = "EXAMPLE_URL";

  Future<int> getDecodedId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    int id = decodedToken['id'];
    return id;
  }

  static Map<String, dynamic>? getResponseBody(dynamic jsonResponse) {
    if (jsonResponse == null) {
      return null;
    }

    final body = jsonDecode(utf8.decode(jsonResponse.bodyBytes));
    if (body == null) {
      return null;
    }
    return Map<String, dynamic>.from(body);
  }

  static Future<UserLoginResponse?> loginCall(
      {required UserLoginRequest loginRequest}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json;charset=UTF-8',
    };

    var response = await http.post(
      Uri.parse(baseURL + "users/login/"),
      body: jsonEncode(loginRequest.toJson()),
      headers: headers,
    );
    try {
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        final userLoginResponse = UserLoginResponse.fromJson(result);

        var tokenFromBody = result["user"]["token"];
        if (tokenFromBody != null) {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString("token", tokenFromBody);
          return userLoginResponse;
        } else {
          throw ("Token not found in response");
        }
      } else {
        throw ("Login failed");
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
  static Future<UserRegisterResponse?> registerCall(
      {required UserRegisterRequest registerRequest}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json;charset=UTF-8',
    };

    var response = await http.post(
      Uri.parse(baseURL + "users/register/"),
      body: jsonEncode(registerRequest.toJson()),
      headers: headers,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final result = json.decode(response.body);
      final userRegisterResponse = UserRegisterResponse.fromJson(result);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("token", userRegisterResponse.token.toString());

      return userRegisterResponse;
    } else {
      print(response.statusCode.toString());
      print(response.body.toString());
      print("Registration failed");
    }
  }

  static Future<List<StationModel>?> getStations() async {
    final url = Uri.parse(baseURL + "stations/");
    final prefs = await SharedPreferences.getInstance();

    String token = prefs.getString("token") ?? '';
    print("token" + token);
    final headers = {
      "Content-type": "application/json",
      'Accept': 'application/json;charset=UTF-8',
      "Authorization": "Token $token"
    };

    var response = await http.get(url, headers: headers);

    try {
      if (response.statusCode == 200) {
        final result = jsonDecode(utf8.decode(response.bodyBytes));
        List<StationModel> stations = [];
        for (var item in result) {
          var station = StationModel.fromJson(item);
          stations.add(station);
        }
        return stations;
      } else {
        print("API Response Body: ${response.body}");
        throw Exception("Error occurred: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<ReservationModel?> createReservation(
      {required ReservationModel reservationRequest}) async {
    final url = Uri.parse(baseURL + "reservations/");
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? '';
    final headers = {
      "Content-type": "application/json",
      'Accept': 'application/json;charset=UTF-8',
      "Authorization": "Token $token"
    };

    var response = await http.post(url,
        headers: headers, body: jsonEncode(reservationRequest.toJson()));

    try {
      if (response.statusCode == 201) {
        return ReservationModel.fromJson(jsonDecode(response.body));
      } else {
        throw ("Error occurred");
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<List<ReservationModel>?> getUserReservations() async {
    final url = Uri.parse(baseURL + "reservations/");
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? '';
    final headers = {
      "Content-type": "application/json",
      'Accept': 'application/json;charset=UTF-8',
      "Authorization": "Token $token"
    };

    var response = await http.get(url, headers: headers);

    try {
      if (response.statusCode == 200) {
        final List result = jsonDecode(utf8.decode(response.bodyBytes));
        return result.map((item) => ReservationModel.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<UserModel?> getUserDetails() async {
    final url = Uri.parse(baseURL + "user");
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? '';
    final headers = {
      "Content-type": "application/json",
      'Accept': 'application/json;charset=UTF-8',
      "Authorization": "Token $token"
    };

    var response = await http.get(url, headers: headers);
    try {
      if (response.statusCode == 200) {
        final result = jsonDecode(utf8.decode(response.bodyBytes));
        return UserModel.fromJson(result);
      } else {
        print(response.body.toString());
        print(response.statusCode);

        throw ("Error occurred");
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<List<CarModel>?> getCars() async {
    final url = Uri.parse(baseURL + "cars/");
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? '';
    final headers = {
      "Content-type": "application/json",
      'Accept': 'application/json;charset=UTF-8',
      "Authorization": "Token $token"
    };

    var response = await http.get(url, headers: headers);

    try {
      if (response.statusCode == 200) {
        final result = jsonDecode(utf8.decode(response.bodyBytes)) as List;
        return result.map((item) => CarModel.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<StationModel?> getStation(int id) async {
    final url = Uri.parse(baseURL + "stations/$id");
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? '';
    final headers = {
      "Content-type": "application/json",
      'Accept': 'application/json;charset=UTF-8',
      "Authorization": "Token $token"
    };

    var response = await http.get(url, headers: headers);

    try {
      if (response.statusCode == 200) {
        final result = jsonDecode(utf8.decode(response.bodyBytes));
        return StationModel.fromJson(result);
      } else {
        throw ("Error occurred");
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<CarModel?> createCar({required CarModel car}) async {
    final url = Uri.parse(baseURL + "cars/");
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? '';
    final headers = {
      "Content-type": "application/json",
      'Accept': 'application/json;charset=UTF-8',
      "Authorization": "Token $token"
    };

    var response =
        await http.post(url, headers: headers, body: jsonEncode(car.toJson()));

    try {
      if (response.statusCode == 201) {
        final result = jsonDecode(utf8.decode(response.bodyBytes));
        return CarModel.fromJson(result);
      } else {
        throw ("Error occurred");
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<CarModel?> getCar(int id) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token").toString();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json;charset=UTF-8',
      "Authorization": "Token $token"
    };
    var response =
        await http.get(Uri.parse(baseURL + "cars/$id"), headers: headers);
    if (response.statusCode == 200) {
      return CarModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load car details");
    }
  }

  static Future updateCar(int id,
      {required Map<String, dynamic> carData}) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token").toString();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json;charset=UTF-8',
      "Authorization": "Token $token"
    };
    var response = await http.put(Uri.parse(baseURL + "cars/$id"),
        headers: headers, body: jsonEncode(carData));
    if (response.statusCode == 200) {
      return getResponseBody(response);
    } else {
      throw Exception("Failed to update car details");
    }
  }

  static Future deleteCar(int id) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token").toString();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json;charset=UTF-8',
      "Authorization": "Token $token"
    };
    var response =
        await http.delete(Uri.parse(baseURL + "cars/$id"), headers: headers);
    if (response.statusCode != 200) {
      throw Exception("Failed to delete car");
    }
  }

  static Future<ReservationModel?> getReservation(int id) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token").toString();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json;charset=UTF-8',
      "Authorization": "Token $token"
    };
    var response = await http.get(Uri.parse(baseURL + "reservations/$id"),
        headers: headers);
    if (response.statusCode == 200) {
      return ReservationModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load reservation details");
    }
  }

  static Future updateReservation(int id,
      {required Map<String, dynamic> reservationData}) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token").toString();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json;charset=UTF-8',
      "Authorization": "Token $token"
    };
    var response = await http.put(Uri.parse(baseURL + "reservations/$id"),
        headers: headers, body: jsonEncode(reservationData));
    if (response.statusCode == 200) {
      return getResponseBody(response);
    } else {
      throw Exception("Failed to update reservation details");
    }
  }

  static Future deleteReservation(int id) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token").toString();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json;charset=UTF-8',
      "Authorization": "Token $token"
    };
    var response = await http.delete(Uri.parse(baseURL + "reservations/{$id}"),
        headers: headers);
    if (response.statusCode != 200) {
      print(response.statusCode);
      print(response.body.toString());
      throw Exception("Failed to delete reservation");
    }
  }

  static Future updateUser({required Map<String, dynamic> userData}) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token").toString();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json;charset=UTF-8',
      "Authorization": "Token $token"
    };
    var response = await http.put(Uri.parse(baseURL + "users/me/"),
        headers: headers, body: jsonEncode(userData));
    if (response.statusCode == 200) {
      return getResponseBody(response);
    } else {
      throw Exception("Failed to update user details");
    }
  }

  static Future<CarModel?> updateCarWithPatch(int id,
      {required CarModel carData}) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token").toString();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json;charset=UTF-8',
      "Authorization": "Token $token"
    };
    var response = await http.patch(Uri.parse(baseURL + "cars/$id"),
        headers: headers, body: jsonEncode(carData.toJson()));
    if (response.statusCode == 200) {
      return CarModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to update car details");
    }
  }
}
