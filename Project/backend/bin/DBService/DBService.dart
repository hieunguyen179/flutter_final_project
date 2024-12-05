import 'package:mysql_client/mysql_client.dart';

class Mysql {

  Future<MySQLConnection> getConnect() async {
    return await MySQLConnection.createConnection(
        host: '192.168.42.2',
        port: 3306,
        userName: "root",
        password: "123123",
        databaseName: "_project",
    );
  }
}