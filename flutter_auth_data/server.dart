import 'dart.io';
import 'package:shelf/shelf.dart';
import 'package:shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:mysql1/mysql1.dart';

final settings = ConnectionSettings(
  host: 'localhost',
  port: 3306,
  user: 'root',
  password: '@Sadgirl1941',
  db: 'flutter_auth',
);

Future<Response> loginhandling(Request request) async {
  final body = await request.readAsString();
  final data = Uri.splitQueryString(body);

  final email = data['email'];
  final password = data['password'];

  final conn = await MySqlConnection.connect(settings);

  final results = await conn.query(
    'SELECT FROM users WHERE email = ? AND password = ?',
    [email, password],
  );

  await conn.close();
  if (results.isEmpty) {
    return Response.ok(
      '{"success": false, "message":"User not found"}',
      headers: {'Content-Type': 'application/json'},
    );
  }

  final user = results.first;
  final dbPassword = user['password'];

  if (dbPassword == password) {
    return Response.ok(
      '{"success":true,"message":"Login successfull"}',
      headers: {'Content-Type': 'application/json'},
    );
  } else {
    return Response.ok(
      '{"success":false, "message": "Incorrect password"}',
      headers: {'Content-Type': 'application/json'},
    );
  }
}

void main() async {
  final router = Router();
  router.post('/login', loginhandling);
  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(router);
}
