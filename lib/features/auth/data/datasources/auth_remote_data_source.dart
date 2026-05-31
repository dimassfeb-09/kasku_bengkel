import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String username, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> login(String username, String password) async {
    // Mocking network delay
    await Future.delayed(const Duration(seconds: 1));
    
    if (username == 'admin' && password == 'admin') {
      return const UserModel(id: '1', username: 'admin');
    } else {
      throw Exception('Invalid credentials');
    }
  }
}
